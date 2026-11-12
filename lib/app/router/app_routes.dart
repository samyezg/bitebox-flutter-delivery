abstract final class AppRoutes {
  static const String home = '/home';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String productDetails = '/product/:id';
  static const String checkout = '/checkout';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';

  static String productDetailsPath(String id) => '/product/$id';
}
