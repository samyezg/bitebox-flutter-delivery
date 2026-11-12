import 'package:bitebox_app/app/config/app_environment_provider.dart';
import 'package:bitebox_app/app/router/app_router.dart';
import 'package:bitebox_app/app/router/router_refresh.dart';
import 'package:bitebox_app/app/theme/app_theme.dart';
import 'package:bitebox_app/features/auth/presentation/auth_notifier.dart';
import 'package:bitebox_app/features/settings/presentation/locale_notifier.dart';
import 'package:bitebox_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BiteBoxApp extends ConsumerStatefulWidget {
  const BiteBoxApp({super.key});

  @override
  ConsumerState<BiteBoxApp> createState() => _BiteBoxAppState();
}

class _BiteBoxAppState extends ConsumerState<BiteBoxApp> {
  final _routerRefresh = RouterRefresh();
  late final GoRouter _router;

  bool _isSignedIn = false;
  bool _requireAuth = false;

  static const _supported = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(
      refreshListenable: _routerRefresh,
      isSignedIn: () => _isSignedIn,
      requireAuthForProtectedRoutes: () => _requireAuth,
    );
  }

  @override
  Widget build(BuildContext context) {
    _isSignedIn = ref.watch(isSignedInProvider);
    _requireAuth = ref.watch(requireAuthForProtectedRoutesProvider);
    final localePreference = ref.watch(localePreferenceProvider);
    final materialLocale = localePreference.trim().isEmpty
        ? null
        : Locale(localePreference.trim());

    ref.listen(authProvider, (_, _) {
      _routerRefresh.ping();
    });

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: _router,
      locale: materialLocale,
      supportedLocales: _supported,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeResolutionCallback: (locale, supported) {
        if (locale == null) return const Locale('en');
        for (final item in supported) {
          if (item.languageCode == locale.languageCode) return item;
        }
        if (locale.languageCode.toLowerCase().startsWith('zh')) {
          return const Locale('zh');
        }
        return const Locale('en');
      },
    );
  }
}
