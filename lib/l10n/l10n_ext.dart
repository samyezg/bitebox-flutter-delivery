import 'package:bitebox_app/features/catalog/domain/food_category.dart';
import 'package:bitebox_app/features/checkout/domain/payment_method.dart';
import 'package:bitebox_app/features/orders/domain/order.dart';
import 'package:bitebox_app/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

export 'package:bitebox_app/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension BiteBoxLocalizations on AppLocalizations {
  String foodCategoryLabel(FoodCategory category) => switch (category) {
        FoodCategory.burger => categoryBurgers,
        FoodCategory.pizza => categoryPizza,
        FoodCategory.drink => categoryDrinks,
        FoodCategory.dessert => categoryDesserts,
      };

  String orderStatusLabel(OrderStatus status) => switch (status) {
        OrderStatus.pending => orderStatusPending,
        OrderStatus.confirmed => orderStatusConfirmed,
        OrderStatus.preparing => orderStatusPreparing,
        OrderStatus.completed => orderStatusCompleted,
      };

  String paymentMethodLabel(PaymentMethod method) => switch (method) {
        PaymentMethod.cardDemo => paymentCardDemo,
        PaymentMethod.cashOnDelivery => paymentCashOnDelivery,
      };
}
