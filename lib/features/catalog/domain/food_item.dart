import 'package:bitebox_app/features/catalog/domain/food_category.dart';

class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.priceInCents,
    required this.rating,
    this.imageAssetPath,
    this.available = true,
  });

  final String id;
  final String name;
  final String description;
  final FoodCategory category;
  final int priceInCents;
  final double rating;
  final String? imageAssetPath;
  final bool available;
}
