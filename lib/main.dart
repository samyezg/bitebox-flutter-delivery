import 'package:bitebox_app/app/bitebox_app.dart';
import 'package:bitebox_app/app/config/app_environment.dart';
import 'package:bitebox_app/app/config/app_environment_provider.dart';
import 'package:bitebox_app/features/settings/presentation/locale_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final env = AppEnvironment.fromDefines();
  if (env.useSupabase) {
    if (!env.hasSupabaseCredentials) {
      throw StateError(
        'BACKEND_MODE=supabase requires SUPABASE_URL and SUPABASE_ANON_KEY.',
      );
    }
    await Supabase.initialize(
      url: env.supabaseUrl!,
      publishableKey: env.supabaseAnonKey!,
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        appEnvironmentProvider.overrideWithValue(env),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const BiteBoxApp(),
    ),
  );
}
