import 'package:bitebox_app/app/theme/app_colors.dart';
import 'package:bitebox_app/app/theme/app_tokens.dart';
import 'package:bitebox_app/core/widgets/price_text.dart';
import 'package:bitebox_app/features/catalog/domain/food_category.dart';
import 'package:bitebox_app/features/catalog/presentation/widgets/food_category_avatar.dart';
import 'package:flutter/material.dart';

class FoodListTile extends StatelessWidget {
  const FoodListTile({
    required this.name,
    required this.priceInCents,
    required this.category,
    required this.onTap,
    super.key,
    this.subtitle,
    this.rating,
  });

  final String name;
  final String? subtitle;
  final int priceInCents;
  final FoodCategory category;
  final double? rating;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: FoodCategoryAvatar(category: category),
      title: Text(
        name,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              subtitle!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
            ),
          ],
          if (rating != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              '★ ${rating!.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.secondaryText,
                  ),
            ),
          ],
        ],
      ),
      trailing: PriceText(priceInCents: priceInCents),
    );
  }
}
