import 'package:bitebox_app/app/config/app_environment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appEnvironmentProvider = Provider<AppEnvironment>((ref) {
  return AppEnvironment.fromDefines();
});

final requireAuthForProtectedRoutesProvider = Provider<bool>((ref) {
  return ref.watch(appEnvironmentProvider).requireAuthForProtectedRoutes;
});
