import 'package:bitebox_app/app/config/app_environment_provider.dart';
import 'package:bitebox_app/features/auth/presentation/auth_notifier.dart';
import 'package:bitebox_app/features/cart/domain/cart_line.dart';
import 'package:bitebox_app/features/cart/presentation/cart_notifier.dart';
import 'package:bitebox_app/features/checkout/domain/checkout_constants.dart';
import 'package:bitebox_app/features/checkout/domain/payment_method.dart';
import 'package:bitebox_app/features/orders/data/in_memory_order_repository.dart';
import 'package:bitebox_app/features/orders/data/supabase_order_repository.dart';
import 'package:bitebox_app/features/orders/domain/order.dart';
import 'package:bitebox_app/features/orders/domain/order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final env = ref.watch(appEnvironmentProvider);
  if (env.useSupabase) {
    return SupabaseOrderRepository(Supabase.instance.client);
  }
  return InMemoryOrderRepository();
});

class OrdersNotifier extends AsyncNotifier<List<Order>> {
  @override
  Future<List<Order>> build() {
    // Rebuild when auth changes (e.g. after sign-in on Supabase).
    ref.watch(authProvider);
    return ref.read(orderRepositoryProvider).listOrders();
  }

  Future<Order> placeOrder({
    required List<CartLine> items,
    required PaymentMethod paymentMethod,
    String addressText = CheckoutConstants.demoAddress,
  }) async {
    final order = await ref.read(orderRepositoryProvider).placeOrder(
          items: items,
          addressText: addressText,
          paymentMethod: paymentMethod,
        );
    ref.read(cartProvider.notifier).clear();
    state = AsyncData(await ref.read(orderRepositoryProvider).listOrders());
    return order;
  }
}

final ordersProvider =
    AsyncNotifierProvider<OrdersNotifier, List<Order>>(OrdersNotifier.new);
