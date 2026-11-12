import 'package:bitebox_app/app/router/app_routes.dart';
import 'package:bitebox_app/app/theme/app_tokens.dart';
import 'package:bitebox_app/core/widgets/app_button.dart';
import 'package:bitebox_app/core/widgets/app_status_views.dart';
import 'package:bitebox_app/core/widgets/price_text.dart';
import 'package:bitebox_app/core/widgets/qty_stepper.dart';
import 'package:bitebox_app/features/cart/presentation/cart_notifier.dart';
import 'package:bitebox_app/features/catalog/presentation/widgets/food_category_avatar.dart';
import 'package:bitebox_app/l10n/l10n_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  void initState() {
    super.initState();
    // Drop leftover "added to cart" bars so Checkout stays tappable.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cartTitle)),
      body: cart.isEmpty
          ? AppEmptyView(
              message: l10n.cartEmpty,
              actionLabel: l10n.goToMenu,
              onAction: () => context.go(AppRoutes.home),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    itemCount: cart.lines.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final line = cart.lines[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FoodCategoryAvatar(
                              category: line.category,
                              size: 72,
                              iconSize: 28,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    line.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: AppSpacing.xxs),
                                  PriceText(priceInCents: line.priceInCents),
                                  const SizedBox(height: AppSpacing.sm),
                                  Row(
                                    children: [
                                      QtyStepper(
                                        quantity: line.quantity,
                                        onChanged: (value) {
                                          ref
                                              .read(cartProvider.notifier)
                                              .setQuantity(line.itemId, value);
                                        },
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        tooltip: l10n.remove,
                                        onPressed: () {
                                          ref
                                              .read(cartProvider.notifier)
                                              .removeItem(line.itemId);
                                        },
                                        icon: const Icon(Icons.delete_outline),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            l10n.subtotal,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          PriceText(priceInCents: cart.subtotalInCents),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        label: l10n.checkout,
                        onPressed: () => context.push(AppRoutes.checkout),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
