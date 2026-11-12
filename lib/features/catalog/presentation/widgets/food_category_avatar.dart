import 'package:bitebox_app/app/theme/app_colors.dart';
import 'package:bitebox_app/app/theme/app_tokens.dart';
import 'package:bitebox_app/features/catalog/domain/food_category.dart';
import 'package:flutter/material.dart';

class FoodCategoryAvatar extends StatelessWidget {
  const FoodCategoryAvatar({
    required this.category,
    super.key,
    this.size = AppSizes.menuThumbnail,
    this.iconSize = 32,
  });

  final FoodCategory category;
  final double size;
  final double iconSize;

  String get _imagePath => switch (category) {
        FoodCategory.burger => 'assets/images/food/burger.png',
        FoodCategory.pizza => 'assets/images/food/pizza.png',
        FoodCategory.drink => 'assets/images/food/drink.png',
        FoodCategory.dessert => 'assets/images/food/dessert.png',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Image.asset(
          _imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.restaurant,
              size: iconSize,
              color: AppColors.primary,
            );
          },
        ),
      ),
    );
  }
}
