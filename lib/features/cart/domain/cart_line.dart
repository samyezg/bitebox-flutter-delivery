import 'package:bitebox_app/features/catalog/domain/food_category.dart';
import 'package:bitebox_app/features/catalog/domain/food_item.dart';

class CartLine {
  const CartLine({
    required this.itemId,
    required this.name,
    required this.priceInCents,
    required this.quantity,
    required this.category,
    this.imageAssetPath,
  });

  factory CartLine.fromFoodItem(FoodItem item, {int quantity = 1}) {
    return CartLine(
      itemId: item.id,
      name: item.name,
      priceInCents: item.priceInCents,
      quantity: quantity,
      category: item.category,
      imageAssetPath: item.imageAssetPath,
    );
  }

  final String itemId;
  final String name;
  final int priceInCents;
  final int quantity;
  final FoodCategory category;
  final String? imageAssetPath;

  int get lineTotalInCents => priceInCents * quantity;

  CartLine copyWith({int? quantity}) {
    return CartLine(
      itemId: itemId,
      name: name,
      priceInCents: priceInCents,
      quantity: quantity ?? this.quantity,
      category: category,
      imageAssetPath: imageAssetPath,
    );
  }
}
