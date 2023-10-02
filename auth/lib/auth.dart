import 'package:auth/auth.dart';
import 'package:auth/controllers/app_role_controller.dart';
import 'package:auth/utils/app_env.dart';
import 'package:conduit_postgresql/conduit_postgresql.dart';

/// auth
///
/// A conduit web server.
//library auth;

export 'dart:async';
export 'dart:io';

export 'package:conduit_core/conduit_core.dart';

class AuthService extends ApplicationChannel {
  late final ManagedContext managedContext;

  @override
  Future prepare() {
    final persistentStore = _initDataBase();
    managedContext = ManagedContext(
        ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);
    return super.prepare();
  }

  @override
  Controller get entryPoint => Router()
    ..route("role")
      .link(() => AppRoleController(managedContext));

  PostgreSQLPersistentStore _initDataBase() {
    return PostgreSQLPersistentStore(
      AppEnv.dbUsername,
      AppEnv.dbPassword,
      AppEnv.dbHost,
      int.parse(AppEnv.dbPort),
      AppEnv.dbDatabaseName,
    );
  }
}
