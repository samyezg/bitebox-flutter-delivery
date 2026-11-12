import 'package:bitebox_app/features/cart/domain/cart_line.dart';
import 'package:bitebox_app/features/checkout/domain/payment_method.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  completed;
}

class Order {
  const Order({
    required this.id,
    required this.items,
    required this.totalCents,
    required this.status,
    required this.createdAt,
    required this.addressText,
    required this.paymentMethod,
  });

  final String id;
  final List<CartLine> items;
  final int totalCents;
  final OrderStatus status;
  final DateTime createdAt;
  final String addressText;
  final PaymentMethod paymentMethod;

  int get itemCount => items.fold(0, (sum, line) => sum + line.quantity);
}
