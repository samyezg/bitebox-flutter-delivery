import 'package:bitebox_app/features/cart/domain/cart_line.dart';
import 'package:bitebox_app/features/checkout/domain/payment_method.dart';
import 'package:bitebox_app/features/orders/domain/order.dart';
import 'package:bitebox_app/features/orders/domain/order_repository.dart';

class InMemoryOrderRepository implements OrderRepository {
  final List<Order> _orders = [];
  int _sequence = 0;

  @override
  Future<List<Order>> listOrders() async => List.unmodifiable(_orders);

  @override
  Future<Order> placeOrder({
    required List<CartLine> items,
    required String addressText,
    required PaymentMethod paymentMethod,
  }) async {
    if (items.isEmpty) {
      throw StateError('Cannot place an order with an empty cart.');
    }

    _sequence += 1;
    final snapshot = [
      for (final line in items)
        CartLine(
          itemId: line.itemId,
          name: line.name,
          priceInCents: line.priceInCents,
          quantity: line.quantity,
          category: line.category,
          imageAssetPath: line.imageAssetPath,
        ),
    ];

    final totalCents =
        snapshot.fold<int>(0, (sum, line) => sum + line.lineTotalInCents);

    final order = Order(
      id: 'BB-${_sequence.toString().padLeft(4, '0')}',
      items: snapshot,
      totalCents: totalCents,
      status: OrderStatus.confirmed,
      createdAt: DateTime.now(),
      addressText: addressText,
      paymentMethod: paymentMethod,
    );

    _orders.insert(0, order);
    return order;
  }
}
