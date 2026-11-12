import 'package:bitebox_app/features/cart/domain/cart_line.dart';
import 'package:bitebox_app/features/catalog/domain/food_category.dart';
import 'package:bitebox_app/features/checkout/domain/payment_method.dart';
import 'package:bitebox_app/features/orders/domain/order.dart';
import 'package:bitebox_app/features/orders/domain/order_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseOrderRepository implements OrderRepository {
  SupabaseOrderRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Order>> listOrders() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return const [];

    final rows = await _client
        .from('orders')
        .select('*, order_items(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return rows.map(_mapOrder).toList(growable: false);
  }

  @override
  Future<Order> placeOrder({
    required List<CartLine> items,
    required String addressText,
    required PaymentMethod paymentMethod,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw StateError('Sign in required to place an order.');
    }
    if (items.isEmpty) {
      throw StateError('Cannot place an order with an empty cart.');
    }

    final totalCents =
        items.fold<int>(0, (sum, line) => sum + line.lineTotalInCents);

    final inserted = await _client
        .from('orders')
        .insert({
          'user_id': user.id,
          'total_cents': totalCents,
          'status': OrderStatus.confirmed.name,
          'address_text': addressText,
          'payment_method': paymentMethod.name,
        })
        .select()
        .single();

    final orderId = inserted['id'] as String;

    await _client.from('order_items').insert([
      for (final line in items)
        {
          'order_id': orderId,
          'item_id': line.itemId,
          'name': line.name,
          'price_in_cents': line.priceInCents,
          'quantity': line.quantity,
          'category': line.category.name,
        },
    ]);

    final full = await _client
        .from('orders')
        .select('*, order_items(*)')
        .eq('id', orderId)
        .single();

    return _mapOrder(full);
  }

  Order _mapOrder(Map<String, dynamic> row) {
    final orderNumber = row['order_number'];
    final displayId = orderNumber == null
        ? (row['id'] as String)
        : 'BB-${orderNumber.toString().padLeft(4, '0')}';

    final rawItems = (row['order_items'] as List<dynamic>? ?? const []);
    final items = [
      for (final raw in rawItems)
        CartLine(
          itemId: raw['item_id'] as String,
          name: raw['name'] as String,
          priceInCents: raw['price_in_cents'] as int,
          quantity: raw['quantity'] as int,
          category: FoodCategory.values.byName(raw['category'] as String),
        ),
    ];

    return Order(
      id: displayId,
      items: items,
      totalCents: row['total_cents'] as int,
      status: OrderStatus.values.byName(row['status'] as String),
      createdAt: DateTime.parse(row['created_at'] as String),
      addressText: row['address_text'] as String,
      paymentMethod: PaymentMethod.values.byName(row['payment_method'] as String),
    );
  }
}
