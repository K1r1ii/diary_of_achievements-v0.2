import 'package:auth/auth.dart';
import 'package:auth/models/db_models/help_models/user_role.dart';
import 'package:auth/models/db_models/role.dart';
import 'package:auth/models/db_models/user.dart';
import 'package:auth/utils/app_env.dart';
import 'package:auth/utils/app_response.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class AppUserController extends ResourceController {
  AppUserController(this.managedContext);
  final ManagedContext managedContext;

  @Operation.put()
  Future<Response> signUp() async {
    // Проверяем есть ли у создателя права админимтратора
    // проверяем есть ли в запросе поля Фамилия имя отчество
    // Конвертируем Фио в логин
    // Генирируем пароль
    // Создаем запись в User, UserRole
    try {
      return AppResponse.ok(message: "Пользователь успешно добавлен!");
    } catch (e) {
      return AppResponse.serverError(e,
          message: "Ошибка создания пользователя");
    }
  }

  @Operation.post("role")
  Future<Response> addRoleForUser(@Bind.query("role") String addedRole,
      @Bind.query("userId") int userId) async {
    try {
      print("Добавляемая роль: ");
      print(addedRole);
      final fetchUser = await managedContext.fetchObjectWithID<User>(userId);
      print(fetchUser);
      if (fetchUser == null) {
        throw QueryException.input("Пользователь не найден", []);
      }

      final qFetchRole = Query<Role>(managedContext)
        ..where((x) => x.title).equalTo(addedRole);
      final fetchRole = await qFetchRole.fetchOne();
      if (fetchRole == null) {
        throw QueryException.input("Роль не найдена", []);
      }
      TODO: "проверить что такого поля нет";
      final qAddRole = Query<UserRole>(managedContext)
        ..values.role = fetchRole
        ..values.user = fetchUser;
      final addRole = await qAddRole.insert();

      // print(fetchUser?.asMap());
      // //Query<User>(managedContext)
      //   ..where((x) => x.id).equalTo(userId)
      //   ..returningProperties((x) => [x.id, x.hashPassword]);
      // final fetchUser = await qFetchUser.fetchOne();
      return AppResponse.ok(
          message: "Роль для пользователя успешно добавлена!");
    } catch (e) {
      return AppResponse.serverError(e, message: "Ошибка добавления роли");
    }
  }

  @Operation.post()
  Future<Response> signIn(@Bind.body() User user1) async {
    if (user1.password == null || user1.login == null) {
      return AppResponse.badRequest(message: "Поля логин и пароль обязательны");
    }

    // найти пользователя по логину
    // проверить правильность пароля
    // создать пару токенов
    try {
      final qFetchUser = Query<User>(managedContext)
        ..where((x) => x.login).equalTo(user1.login)
        ..returningProperties((x) => [x.id, x.hashPassword]);
      final fetchUser = await qFetchUser.fetchOne();

      if (fetchUser == null) {
        throw QueryException.input("Пользователь не найден", []);
      }

      final userId = fetchUser.asMap()["id"];

      //Выгрузить все роли
      final qFetchRoleUser = Query<UserRole>(managedContext)
        ..where((x) => x.user?.id).equalTo(userId)
        ..join(object: (x) => x.role);
      final fetchRoleUser = await qFetchRoleUser.fetch();
      print(fetchRoleUser);

      // final qFetchUser2 = Query<User>(managedContext)
      //   ..where((x) => x.login).equalTo(user1.login)
      //   ..returningProperties((x) => [x.id])
      //   ..join(set: (x) => x.roleList)
      //       .join(object: (x) => x.role)
      //       .returningProperties((x) => [x.title]);
      // final fetchUser2 = await qFetchUser2.fetchOne();

      // Проверка на админа
      // for (int i = 0; i < fetchUser2?.asMap()["roleList"].length; i++) {
      //   if (fetchUser2?.asMap()["roleList"][i]["role"]["title"] == "admin") {
      //     print("ого, работает!");
      //   }
      // }

      // fetchUser2?.asMap()["roleList"].forEach((element)=>{
      //   if(element["role"]["title"]==AppEnv.adminRole){
      //     print("ого, работает!")
      //   }
      // });

      final hashPassword = generatePasswordHash(user1.password ?? "", "");
      if (fetchUser.hashPassword != hashPassword) {
        throw QueryException.input("Пароль не верный", []);
      }
      return AppResponse.ok(message: "Пользователь успешно авторизован!");
    } catch (e) {
      return AppResponse.serverError(e,
          message: "Ошибка авторизации пользователя");
    }
  }

  Map<String, dynamic> _getTokens(int id, String role) {
    final key = AppEnv.secretKey;
    final accessClaimSet = JwtClaim(
        maxAge: Duration(hours: 1), otherClaims: {"id": id, "role": role});
    final refrashClaimSet = JwtClaim(otherClaims: {"id": id});
    final tokens = <String, dynamic>{};
    tokens["access"] = issueJwtHS256(accessClaimSet, key);
    tokens["refresh"] = issueJwtHS256(refrashClaimSet, key);
    return tokens;
  }

  Future<void> _updateTokens(
      int id, String role, ManagedContext transaction) async {
    final Map<String, dynamic> tokens = _getTokens(id, role);
    final qUpdateTokens = Query<User>(transaction)
      ..where((user) => user.id).equalTo(id)
      ..values.accessToken = tokens["access"]
      ..values.refreshToken = tokens["refresh"];
    await qUpdateTokens.updateOne();
  }
}
