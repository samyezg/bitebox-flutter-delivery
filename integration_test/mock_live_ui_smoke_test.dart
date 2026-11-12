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

/// Device Mock smoke: menu → cart → guest checkout → orders (+ language).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('mock live: guest loop + zh chrome', (tester) async {
    SharedPreferences.setMockInitialValues({
      LocaleSettingsStore.prefsKey: 'en',
    });
    final prefs = await SharedPreferences.getInstance();

    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appEnvironmentProvider.overrideWithValue(AppEnvironment.mock),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const BiteBoxApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('BiteBox Kitchen'), findsOneWidget);
    expect(find.byKey(const ValueKey('classic-beef-burger')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('classic-beef-burger')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Add to cart'));
    await tester.tap(find.text('Add to cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Guest checkout'), findsOneWidget);
    await tester.ensureVisible(find.text('Place order'));
    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle();
    expect(find.text('BB-0001'), findsOneWidget);

    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('中文'));
    await tester.pumpAndSettle();
    expect(find.text('菜单'), findsOneWidget);
  });
}
