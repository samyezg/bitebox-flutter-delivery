import 'package:bitebox_app/app/bitebox_app.dart';
import 'package:bitebox_app/app/config/app_environment.dart';
import 'package:bitebox_app/app/config/app_environment_provider.dart';
import 'package:bitebox_app/features/settings/data/locale_settings_store.dart';
import 'package:bitebox_app/features/settings/presentation/locale_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<void> pumpApp(
    WidgetTester tester, {
    bool requireAuth = false,
    String localePreference = 'en',
  }) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({
      LocaleSettingsStore.prefsKey: localePreference,
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appEnvironmentProvider.overrideWithValue(AppEnvironment.mock),
          sharedPreferencesProvider.overrideWithValue(prefs),
          if (requireAuth)
            requireAuthForProtectedRoutesProvider.overrideWithValue(true),
        ],
        child: const BiteBoxApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('guest mock loop still works without auth', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byKey(const ValueKey('classic-beef-burger')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Add to cart'));
    await tester.tap(find.text('Add to cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Checking out as guest'), findsOneWidget);
    await tester.ensureVisible(find.text('Place order'));
    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle();
    expect(find.text('BB-0001'), findsOneWidget);
  });

  testWidgets('protected mode redirects checkout to sign in', (tester) async {
    await pumpApp(tester, requireAuth: true);

    await tester.tap(find.byKey(const ValueKey('classic-beef-burger')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Add to cart'));
    await tester.tap(find.text('Add to cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to BiteBox'), findsOneWidget);
    expect(find.text('Sign in'), findsWidgets);
  });

  testWidgets('sign up then home shows account menu', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField).at(0),
      'guest@bitebox.dev',
    );
    await tester.enterText(find.byType(TextField).at(1), 'secret1');
    await tester.tap(find.byKey(const ValueKey('sign-up-submit')));
    await tester.pumpAndSettle();

    expect(find.text('Account created for guest@bitebox.dev'), findsOneWidget);
    expect(find.text('guest'), findsOneWidget);
    expect(find.text('Sign in'), findsNothing);
  });

  testWidgets('manual zh locale switches chrome strings', (tester) async {
    await pumpApp(tester, localePreference: 'zh');

    expect(find.text('菜单'), findsOneWidget);
    expect(find.text('搜索菜单'), findsOneWidget);

    await tester.tap(find.byTooltip('语言'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();

    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('Search the menu'), findsOneWidget);
  });
}
