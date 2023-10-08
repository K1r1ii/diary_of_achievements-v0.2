import 'package:auth/auth.dart';
import 'package:auth/models/db_models/help_models/user_role.dart';
import 'package:auth/models/db_models/role.dart';
import 'package:auth/models/db_models/user.dart';
import 'package:auth/utils/app_env.dart';
import 'package:auth/utils/app_response.dart';

class AppSuperAdminController extends ResourceController {
  AppSuperAdminController(this.managedContext);
  final ManagedContext managedContext;


  @Operation.put()
  Future<Response> createSuperAdmin() async {
    // создаем роль admin
    // создаем пользователя superAdmin
    //
    // Проверяем есть ли у создателя права админимтратора
    // проверяем есть ли в запросе поля Фамилия имя отчество
    // Конвертируем Фио в логин
    // Генирируем пароль
    // Создаем запись в User, UserRole
    final String hashPassword =
        generatePasswordHash(AppEnv.passwordSuperAdmin, "");
    late final int userId;
    late final int userRoleId;
    try {
      await managedContext.transaction((transaction) async {
        final qFindRoleAdmin = Query<Role>(transaction)
          ..where((x) => x.title).equalTo(AppEnv.adminRole);

        Role? createAdmin = await qFindRoleAdmin.fetchOne();

        if (createAdmin == null) {
          final qCreateAdmin = Query<Role>(transaction)
            ..values.title = AppEnv.adminRole
            ..values.description = "admin - бог";

          createAdmin = await qCreateAdmin.insert();
        }

        final qCreateSuperAdmin = Query<User>(transaction)
          ..values.login = "superAdmin"
          ..values.firstName = "admin"
          ..values.hashPassword = hashPassword
          ..values.surName = "admin";
        final CreateSuperAdmin = await qCreateSuperAdmin.insert();
        userId = CreateSuperAdmin.asMap()["id"];

        final qCreateUserRole = Query<UserRole>(transaction)
          ..values.role = createAdmin
          ..values.user = CreateSuperAdmin;
        final createUserRole = await qCreateUserRole.insert();
        userRoleId = createUserRole.asMap()["id"];
      });

      final dataSuperAdmin =
          await managedContext.fetchObjectWithID<User>(userId);
      final dataUserRole =
          await managedContext.fetchObjectWithID<UserRole>(userRoleId);
      Map<String, dynamic> data1 = dataSuperAdmin!.asMap();
      Map<String, dynamic> data2 = dataUserRole!.asMap();
      data1.addEntries(data2.entries);
      return AppResponse.ok(
          body: data1, message: "Супер админ успешно добавлен!");
    } catch (e) {
      return AppResponse.serverError(e,
          message: "Ошибка создания супер-пользователя");
    }
  }
}
