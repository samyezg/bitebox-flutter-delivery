// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BiteBox';

  @override
  String get kitchenTitle => 'BiteBox Kitchen';

  @override
  String get kitchenSubtitle =>
      'Single-store menu · burgers, pizza, drinks & desserts';

  @override
  String get navMenu => 'Menu';

  @override
  String get navCart => 'Cart';

  @override
  String get navOrders => 'Orders';

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String get signedOut => 'Signed out.';

  @override
  String signedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '中文';

  @override
  String get searchMenuHint => 'Search the menu';

  @override
  String get categoryAll => 'All';

  @override
  String get categoryBurgers => 'Burgers';

  @override
  String get categoryPizza => 'Pizza';

  @override
  String get categoryDrinks => 'Drinks';

  @override
  String get categoryDesserts => 'Desserts';

  @override
  String get loading => 'Loading…';

  @override
  String get loadingMenu => 'Loading menu…';

  @override
  String get loadingOrders => 'Loading orders…';

  @override
  String get tryAgain => 'Try again';

  @override
  String get menuLoadError => 'Could not load the menu. Check your connection.';

  @override
  String get menuEmpty => 'No dishes match your filters.';

  @override
  String get productTitle => 'Product';

  @override
  String get productLoadError => 'Could not load dish.';

  @override
  String get productMissing => 'This dish is no longer on the menu.';

  @override
  String ratingCategory(String rating, String category) {
    return '★ $rating · $category';
  }

  @override
  String get addToCart => 'Add to cart';

  @override
  String addedToCart(int quantity, String name) {
    return 'Added $quantity × $name';
  }

  @override
  String get viewCart => 'View cart';

  @override
  String get cartTitle => 'Cart';

  @override
  String get cartEmpty =>
      'Your cart is empty.\nAdd something tasty from the menu.';

  @override
  String get goToMenu => 'Go to menu';

  @override
  String get remove => 'Remove';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get checkout => 'Checkout';

  @override
  String get checkoutEmpty =>
      'Your cart is empty.\nAdd dishes before checkout.';

  @override
  String get deliveryAddress => 'Delivery address';

  @override
  String get guestCheckout => 'Checking out as guest';

  @override
  String get signInRequiredCheckout => 'Sign in to continue checkout';

  @override
  String get payment => 'Payment';

  @override
  String get paymentCardDemo => 'Card';

  @override
  String get paymentCashOnDelivery => 'Cash on delivery';

  @override
  String get orderSummary => 'Order summary';

  @override
  String lineQuantityName(int quantity, String name) {
    return '$quantity × $name';
  }

  @override
  String get total => 'Total';

  @override
  String get placeOrder => 'Place order';

  @override
  String get placingOrder => 'Placing order…';

  @override
  String orderConfirmed(String id) {
    return 'Order $id confirmed';
  }

  @override
  String placeOrderFailed(String error) {
    return 'Could not place order: $error';
  }

  @override
  String get ordersTitle => 'Orders';

  @override
  String get ordersLoadError =>
      'Could not load orders. Sign in again or retry.';

  @override
  String get ordersEmpty => 'No orders yet.\nPlace an order from checkout.';

  @override
  String orderItemsPayment(int count, String payment) {
    return '$count items · $payment';
  }

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusConfirmed => 'Confirmed';

  @override
  String get orderStatusPreparing => 'Preparing';

  @override
  String get orderStatusCompleted => 'Completed';

  @override
  String get signInTitle => 'Sign in';

  @override
  String get welcomeTitle => 'Welcome to BiteBox';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get forgotPasswordPlaceholder =>
      'Password recovery is unavailable in this demo.';

  @override
  String get signingIn => 'Signing in…';

  @override
  String get createAccount => 'Create account';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get googleComingSoon => 'Google sign-in coming soon.';

  @override
  String get appleComingSoon => 'Apple sign-in coming soon.';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get signUpTitle => 'Create account';

  @override
  String get joinTitle => 'Join BiteBox';

  @override
  String get passwordHelper => 'At least 6 characters';

  @override
  String get creatingAccount => 'Creating account…';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String accountCreated(String email) {
    return 'Account created for $email';
  }

  @override
  String get authEmailRequired => 'Enter your email.';

  @override
  String get authEmailInvalid => 'Enter a valid email address.';

  @override
  String get authPasswordRequired => 'Enter your password.';

  @override
  String authPasswordTooShort(int min) {
    return 'Password must be at least $min characters.';
  }
}
