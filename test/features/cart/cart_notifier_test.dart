import 'package:bitebox_app/features/cart/presentation/cart_notifier.dart';
import 'package:bitebox_app/features/catalog/data/mock_catalog_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds, merges, updates, and removes cart lines', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    const repo = MockCatalogRepository();
    final burger = (await repo.getItemById('classic-beef-burger'))!;
    final pizza = (await repo.getItemById('margherita-pizza'))!;
    final cart = container.read(cartProvider.notifier);

    cart.addItem(burger, quantity: 1);
    cart.addItem(burger, quantity: 2);
    cart.addItem(pizza, quantity: 1);

    var state = container.read(cartProvider);
    expect(state.lines, hasLength(2));
    expect(state.lineFor(burger.id)!.quantity, 3);
    expect(state.totalItemCount, 4);
    expect(state.subtotalInCents, burger.priceInCents * 3 + pizza.priceInCents);

    cart.setQuantity(burger.id, 1);
    state = container.read(cartProvider);
    expect(state.lineFor(burger.id)!.quantity, 1);

    cart.setQuantity(burger.id, 0);
    state = container.read(cartProvider);
    expect(state.lineFor(burger.id), isNull);
    expect(state.lines, hasLength(1));

    cart.clear();
    expect(container.read(cartProvider).isEmpty, isTrue);
  });
}
