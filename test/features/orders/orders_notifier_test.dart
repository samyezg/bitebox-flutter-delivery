import 'package:bitebox_app/features/cart/presentation/cart_notifier.dart';
import 'package:bitebox_app/features/catalog/data/mock_catalog_repository.dart';
import 'package:bitebox_app/features/checkout/domain/payment_method.dart';
import 'package:bitebox_app/features/orders/domain/order.dart';
import 'package:bitebox_app/features/orders/presentation/orders_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('placeOrder snapshots cart, clears it, newest first', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    const repo = MockCatalogRepository();
    final burger = (await repo.getItemById('classic-beef-burger'))!;
    final drink = (await repo.getItemById('cola'))!;

    container.read(cartProvider.notifier).addItem(burger, quantity: 2);
    container.read(cartProvider.notifier).addItem(drink, quantity: 1);

    final first = await container.read(ordersProvider.notifier).placeOrder(
          items: container.read(cartProvider).lines,
          paymentMethod: PaymentMethod.cardDemo,
        );

    expect(container.read(cartProvider).isEmpty, isTrue);
    expect(first.id, 'BB-0001');
    expect(first.totalCents, burger.priceInCents * 2 + drink.priceInCents);
    expect(first.status, OrderStatus.confirmed);

    container.read(cartProvider.notifier).addItem(burger, quantity: 1);
    final second = await container.read(ordersProvider.notifier).placeOrder(
          items: container.read(cartProvider).lines,
          paymentMethod: PaymentMethod.cashOnDelivery,
        );

    final orders = container.read(ordersProvider).requireValue;
    expect(orders.map((order) => order.id), ['BB-0002', 'BB-0001']);
    expect(second.paymentMethod, PaymentMethod.cashOnDelivery);
  });
}
