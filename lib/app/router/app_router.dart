import 'package:bitebox_app/app/router/app_routes.dart';
import 'package:bitebox_app/app/shell/main_shell.dart';
import 'package:bitebox_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:bitebox_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:bitebox_app/features/cart/presentation/pages/cart_page.dart';
import 'package:bitebox_app/features/catalog/presentation/pages/home_page.dart';
import 'package:bitebox_app/features/catalog/presentation/pages/product_details_page.dart';
import 'package:bitebox_app/features/checkout/presentation/pages/checkout_page.dart';
import 'package:bitebox_app/features/orders/presentation/pages/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter({
  required Listenable refreshListenable,
  required bool Function() isSignedIn,
  required bool Function() requireAuthForProtectedRoutes,
}) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      if (!requireAuthForProtectedRoutes()) return null;

      final location = state.matchedLocation;
      final onAuth = location == AppRoutes.signIn || location == AppRoutes.signUp;
      final protected =
          location == AppRoutes.checkout || location == AppRoutes.orders;

      if (protected && !isSignedIn()) {
        final from = Uri.encodeComponent(location);
        return '${AppRoutes.signIn}?from=$from';
      }

      if (onAuth && isSignedIn()) {
        final from = state.uri.queryParameters['from'];
        if (from != null && from.isNotEmpty) {
          return Uri.decodeComponent(from);
        }
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cart,
                name: 'cart',
                builder: (context, state) => const CartPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.orders,
                name: 'orders',
                builder: (context, state) => const OrdersPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.productDetails,
        name: 'productDetails',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'unknown';
          return ProductDetailsPage(productId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.checkout,
        name: 'checkout',
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        name: 'signIn',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        name: 'signUp',
        builder: (context, state) => const SignUpPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: Center(child: Text(state.error?.toString() ?? 'Page not found')),
    ),
  );
}
