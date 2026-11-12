import 'package:bitebox_app/features/catalog/data/mock_catalog.dart';
import 'package:bitebox_app/features/catalog/domain/catalog_repository.dart';
import 'package:bitebox_app/features/catalog/domain/food_category.dart';
import 'package:bitebox_app/features/catalog/domain/food_item.dart';

class MockCatalogRepository implements CatalogRepository {
  const MockCatalogRepository({this.items = kMockFoodItems});

  final List<FoodItem> items;

  @override
  Future<List<FoodItem>> getItems({
    FoodCategory? category,
    String query = '',
  }) async {
    final normalized = query.trim().toLowerCase();
    return items.where((item) {
      if (!item.available) return false;
      if (category != null && item.category != category) return false;
      if (normalized.isEmpty) return true;
      return item.name.toLowerCase().contains(normalized) ||
          item.description.toLowerCase().contains(normalized);
    }).toList(growable: false);
  }

  @override
  Future<FoodItem?> getItemById(String id) async {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }
}
