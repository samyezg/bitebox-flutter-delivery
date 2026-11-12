import 'package:bitebox_app/features/cart/domain/cart_line.dart';
import 'package:bitebox_app/features/cart/domain/cart_state.dart';
import 'package:bitebox_app/features/catalog/domain/food_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() => const CartState();

  void addItem(FoodItem item, {int quantity = 1}) {
    if (quantity <= 0) return;

    final lines = [...state.lines];
    final index = lines.indexWhere((line) => line.itemId == item.id);

    if (index >= 0) {
      final existing = lines[index];
      lines[index] = existing.copyWith(quantity: existing.quantity + quantity);
    } else {
      lines.add(CartLine.fromFoodItem(item, quantity: quantity));
    }

    state = CartState(lines: List.unmodifiable(lines));
  }

  void setQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    final lines = [
      for (final line in state.lines)
        if (line.itemId == itemId) line.copyWith(quantity: quantity) else line,
    ];
    state = CartState(lines: List.unmodifiable(lines));
  }

  void removeItem(String itemId) {
    final lines = state.lines
        .where((line) => line.itemId != itemId)
        .toList(growable: false);
    state = CartState(lines: lines);
  }

  void clear() {
    state = const CartState();
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(CartNotifier.new);

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).totalItemCount;
});

final cartSubtotalProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).subtotalInCents;
});
