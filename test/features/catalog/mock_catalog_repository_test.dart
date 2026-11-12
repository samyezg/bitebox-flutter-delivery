import 'package:bitebox_app/features/catalog/data/mock_catalog.dart';
import 'package:bitebox_app/features/catalog/data/mock_catalog_repository.dart';
import 'package:bitebox_app/features/catalog/domain/food_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const repo = MockCatalogRepository();

  test('mock catalog has 12 available items', () async {
    expect(kMockFoodItems, hasLength(12));
    expect(await repo.getItems(), hasLength(12));
  });

  test('filters by category', () async {
    expect(await repo.getItems(category: FoodCategory.burger), hasLength(3));
    expect(await repo.getItems(category: FoodCategory.pizza), hasLength(3));
    expect(await repo.getItems(category: FoodCategory.drink), hasLength(3));
    expect(await repo.getItems(category: FoodCategory.dessert), hasLength(3));
  });

  test('searches by name', () async {
    final results = await repo.getItems(query: 'pizza');
    expect(results, isNotEmpty);
    expect(
      results.every((item) => item.name.toLowerCase().contains('pizza')),
      isTrue,
    );
  });

  test('getItemById returns cents price', () async {
    final burger = await repo.getItemById('classic-beef-burger');
    expect(burger, isNotNull);
    expect(burger!.priceInCents, 899);
    expect(burger.category, FoodCategory.burger);
  });

  test('unknown id returns null', () async {
    expect(await repo.getItemById('missing'), isNull);
  });
}
