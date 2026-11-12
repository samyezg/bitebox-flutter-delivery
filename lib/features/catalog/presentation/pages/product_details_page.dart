import 'package:bitebox_app/app/router/app_routes.dart';
import 'package:bitebox_app/app/theme/app_colors.dart';
import 'package:bitebox_app/app/theme/app_tokens.dart';
import 'package:bitebox_app/core/widgets/app_button.dart';
import 'package:bitebox_app/core/widgets/price_text.dart';
import 'package:bitebox_app/core/widgets/qty_stepper.dart';
import 'package:bitebox_app/features/cart/presentation/cart_notifier.dart';
import 'package:bitebox_app/features/catalog/presentation/catalog_providers.dart';
import 'package:bitebox_app/features/catalog/presentation/widgets/food_category_avatar.dart';
import 'package:bitebox_app/l10n/l10n_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  const ProductDetailsPage({
    required this.productId,
    super.key,
  });

  final String productId;

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final itemAsync = ref.watch(foodItemProvider(widget.productId));

    return itemAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.productTitle)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.productTitle)),
        body: Center(child: Text('${l10n.productLoadError}\n$error')),
      ),
      data: (item) {
        if (item == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.productTitle)),
            body: Center(child: Text(l10n.productMissing)),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(item.name)),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: FoodCategoryAvatar(
                  category: item.category,
                  size: AppSizes.productHero,
                  iconSize: 72,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                item.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.ratingCategory(
                  item.rating.toStringAsFixed(1),
                  l10n.foodCategoryLabel(item.category),
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.secondaryText,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                item.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.secondaryText,
                      height: 1.45,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              PriceText(priceInCents: item.priceInCents),
              const SizedBox(height: AppSpacing.lg),
              QtyStepper(
                quantity: _quantity,
                onChanged: (value) => setState(() => _quantity = value),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: l10n.addToCart,
                onPressed: () {
                  ref
                      .read(cartProvider.notifier)
                      .addItem(item, quantity: _quantity);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.addedToCart(_quantity, item.name),
                      ),
                      action: SnackBarAction(
                        label: l10n.viewCart,
                        onPressed: () => context.go(AppRoutes.cart),
                      ),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
