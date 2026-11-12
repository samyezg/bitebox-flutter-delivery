// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'BiteBox';

  @override
  String get kitchenTitle => 'BiteBox 厨房';

  @override
  String get kitchenSubtitle => '单店菜单 · 汉堡、披萨、饮品与甜品';

  @override
  String get navMenu => '菜单';

  @override
  String get navCart => '购物车';

  @override
  String get navOrders => '订单';

  @override
  String get signIn => '登录';

  @override
  String get signOut => '退出登录';

  @override
  String get signedOut => '已退出登录。';

  @override
  String signedInAs(String email) {
    return '已登录：$email';
  }

  @override
  String get language => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '中文';

  @override
  String get searchMenuHint => '搜索菜单';

  @override
  String get categoryAll => '全部';

  @override
  String get categoryBurgers => '汉堡';

  @override
  String get categoryPizza => '披萨';

  @override
  String get categoryDrinks => '饮品';

  @override
  String get categoryDesserts => '甜品';

  @override
  String get loading => '加载中…';

  @override
  String get loadingMenu => '正在加载菜单…';

  @override
  String get loadingOrders => '正在加载订单…';

  @override
  String get tryAgain => '重试';

  @override
  String get menuLoadError => '无法加载菜单，请检查网络连接。';

  @override
  String get menuEmpty => '没有符合筛选条件的菜品。';

  @override
  String get productTitle => '商品';

  @override
  String get productLoadError => '无法加载菜品。';

  @override
  String get productMissing => '该菜品已不在菜单中。';

  @override
  String ratingCategory(String rating, String category) {
    return '★ $rating · $category';
  }

  @override
  String get addToCart => '加入购物车';

  @override
  String addedToCart(int quantity, String name) {
    return '已添加 $quantity × $name';
  }

  @override
  String get viewCart => '查看购物车';

  @override
  String get cartTitle => '购物车';

  @override
  String get cartEmpty => '购物车是空的。\n去菜单挑点好吃的吧。';

  @override
  String get goToMenu => '去菜单';

  @override
  String get remove => '移除';

  @override
  String get subtotal => '小计';

  @override
  String get checkout => '去结算';

  @override
  String get checkoutEmpty => '购物车是空的。\n请先添加菜品再结算。';

  @override
  String get deliveryAddress => '配送地址';

  @override
  String get guestCheckout => '以游客身份结算';

  @override
  String get signInRequiredCheckout => '结算前请先登录';

  @override
  String get payment => '支付方式';

  @override
  String get paymentCardDemo => '银行卡';

  @override
  String get paymentCashOnDelivery => '货到付款';

  @override
  String get orderSummary => '订单摘要';

  @override
  String lineQuantityName(int quantity, String name) {
    return '$quantity × $name';
  }

  @override
  String get total => '合计';

  @override
  String get placeOrder => '提交订单';

  @override
  String get placingOrder => '正在下单…';

  @override
  String orderConfirmed(String id) {
    return '订单 $id 已确认';
  }

  @override
  String placeOrderFailed(String error) {
    return '下单失败：$error';
  }

  @override
  String get ordersTitle => '订单';

  @override
  String get ordersLoadError => '无法加载订单，请重新登录或重试。';

  @override
  String get ordersEmpty => '还没有订单。\n去结算页下一单吧。';

  @override
  String orderItemsPayment(int count, String payment) {
    return '$count 件 · $payment';
  }

  @override
  String get orderStatusPending => '待处理';

  @override
  String get orderStatusConfirmed => '已确认';

  @override
  String get orderStatusPreparing => '制作中';

  @override
  String get orderStatusCompleted => '已完成';

  @override
  String get signInTitle => '登录';

  @override
  String get welcomeTitle => '欢迎来到 BiteBox';

  @override
  String get email => '邮箱';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get password => '密码';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get forgotPasswordPlaceholder => '暂不支持找回密码。';

  @override
  String get signingIn => '正在登录…';

  @override
  String get createAccount => '创建账号';

  @override
  String get orContinueWith => '或使用以下方式';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get googleComingSoon => 'Google 登录即将推出。';

  @override
  String get appleComingSoon => 'Apple 登录即将推出。';

  @override
  String get continueAsGuest => '以游客继续';

  @override
  String get signUpTitle => '创建账号';

  @override
  String get joinTitle => '加入 BiteBox';

  @override
  String get passwordHelper => '至少 6 个字符';

  @override
  String get creatingAccount => '正在创建…';

  @override
  String get backToSignIn => '返回登录';

  @override
  String accountCreated(String email) {
    return '已为 $email 创建账号';
  }

  @override
  String get authEmailRequired => '请输入邮箱。';

  @override
  String get authEmailInvalid => '请输入有效的邮箱地址。';

  @override
  String get authPasswordRequired => '请输入密码。';

  @override
  String authPasswordTooShort(int min) {
    return '密码至少需要 $min 个字符。';
  }
}
