import 'package:auth/auth.dart';

Future main() async {
  final int port = int.parse(Platform.environment["PORT"] ?? "8080");
  final app = Application<AuthService>()
    ..options.configurationFilePath = "config.yaml"
    ..options.port = port;

  await app.start(numberOfInstances: 3, consoleLogging: true);

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}
