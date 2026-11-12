import 'package:bitebox_app/app/bitebox_app.dart';
import 'package:bitebox_app/app/config/app_environment.dart';
import 'package:bitebox_app/app/config/app_environment_provider.dart';
import 'package:bitebox_app/features/settings/data/locale_settings_store.dart';
import 'package:bitebox_app/features/settings/presentation/locale_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Live UI smoke: requires `--dart-define-from-file=.vscode/supabase.local.json`
/// and a project with migration applied + Confirm email OFF.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('supabase live: menu → sign up → order → orders list', (
    tester,
  ) async {
    final env = AppEnvironment.fromDefines();
    expect(
      env.useSupabase && env.hasSupabaseCredentials,
      isTrue,
      reason: 'Pass --dart-define-from-file=.vscode/supabase.local.json',
    );

    SharedPreferences.setMockInitialValues({
      LocaleSettingsStore.prefsKey: 'en',
    });
    final prefs = await SharedPreferences.getInstance();

    await Supabase.initialize(
      url: env.supabaseUrl!,
      publishableKey: env.supabaseAnonKey!,
    );

    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appEnvironmentProvider.overrideWithValue(env),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const BiteBoxApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Menu loaded from remote seed (12 items).
    expect(find.text('BiteBox Kitchen'), findsOneWidget);
    expect(find.byKey(const ValueKey('classic-beef-burger')), findsOneWidget);
    expect(find.byKey(const ValueKey('tiramisu')), findsOneWidget);

    // Auth guard: Orders requires sign-in.
    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to BiteBox'), findsOneWidget);

    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    final stamp = DateTime.now().millisecondsSinceEpoch;
    final email = 'bitebox.ui.$stamp@example.com';
    const password = 'Secret1!';

    await tester.enterText(find.byType(TextField).at(0), email);
    await tester.enterText(find.byType(TextField).at(1), password);
    await tester.tap(find.byKey(const ValueKey('sign-up-submit')));
    await tester.pumpAndSettle(const Duration(seconds: 8));

    // After sign-up, from=/orders should land on Orders (empty).
    expect(find.text('Orders'), findsWidgets);

    // Browse → add → checkout → place order.
    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('classic-beef-burger')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Add to cart'));
    await tester.tap(find.text('Add to cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Signed in as'), findsOneWidget);
    await tester.ensureVisible(find.text('Place order'));
    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle(const Duration(seconds: 8));

    expect(find.textContaining('BB-'), findsOneWidget);
    expect(find.textContaining('Classic Beef Burger'), findsOneWidget);
  });
}
