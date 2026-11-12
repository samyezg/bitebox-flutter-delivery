import 'package:bitebox_app/features/catalog/domain/food_category.dart';
import 'package:bitebox_app/features/catalog/domain/food_item.dart';

abstract class CatalogRepository {
  Future<List<FoodItem>> getItems({
    FoodCategory? category,
    String query = '',
  });

  Future<FoodItem?> getItemById(String id);
}
