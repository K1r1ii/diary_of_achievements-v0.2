import 'package:auth/auth.dart';
import 'package:auth/models/db_models/role.dart';
import 'package:auth/utils/app_response.dart';

class AppRoleController extends ResourceController {
  AppRoleController(this.managedContext);
  final ManagedContext managedContext;

  @Operation.put()
  Future<Response> createRole(
    @Bind.body() Role role
  ) async {
    // final String title = "admin";
    // final String discription = "admin - бог";
    late final int roleId;
    try {
      await managedContext.transaction((transaction) async {
        final qCreateRole = Query<Role>(transaction)
          ..values.title = role.title
          ..values.description = role.description;

        final createRole = await qCreateRole.insert();
        roleId = createRole.asMap()["id"];
      });
      final dataCreateRole = await managedContext.fetchObjectWithID(roleId);
      final data = dataCreateRole!.asMap();
      return AppResponse.ok(body: data, message: "Роль успешно добавлена");
    } catch (e) {
      return AppResponse.badRequest(message: "Роль не была добавлена");
    }
  }
}
