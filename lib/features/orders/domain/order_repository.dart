import 'package:bitebox_app/features/cart/domain/cart_line.dart';
import 'package:bitebox_app/features/checkout/domain/payment_method.dart';
import 'package:bitebox_app/features/orders/domain/order.dart';

abstract class OrderRepository {
  Future<List<Order>> listOrders();

  Future<Order> placeOrder({
    required List<CartLine> items,
    required String addressText,
    required PaymentMethod paymentMethod,
  });
}
