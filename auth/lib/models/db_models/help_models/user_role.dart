import 'package:auth/auth.dart';
import 'package:auth/models/db_models/role.dart';
import 'package:auth/models/db_models/user.dart';

class UserRole extends ManagedObject<_UserRole> implements _UserRole {}

class _UserRole {
  @primaryKey
  int? id;
  @Relate(#roleList, isRequired: true, onDelete: DeleteRule.cascade)
  User? user;
  @Relate(#userList, isRequired: true, onDelete: DeleteRule.cascade)
  Role? role;
}
