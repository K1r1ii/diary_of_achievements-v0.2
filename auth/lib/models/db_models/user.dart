import 'package:auth/auth.dart';
import 'package:auth/models/db_models/help_models/user_role.dart';

class User extends ManagedObject<_User> implements _User {}

class _User {
  @primaryKey
  int? id;

  @Column(nullable: false)
  String? firstName;

  @Column(nullable: false)
  String? surName;

  String? patronymic;

  @Column(nullable: false)
  String? login;

  @Serialize(input:  true, output: false)
  @Column(nullable: false)
  String? hashPassword;

  @Column(nullable: true)
  String? successToken;

  @Column(nullable: true)
  String? refreshToken;

  ManagedSet<UserRole>? roleList;
}
