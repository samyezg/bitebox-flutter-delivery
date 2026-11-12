import 'package:bitebox_app/app/config/app_environment_provider.dart';
import 'package:bitebox_app/app/router/app_routes.dart';
import 'package:bitebox_app/app/theme/app_colors.dart';
import 'package:bitebox_app/app/theme/app_tokens.dart';
import 'package:bitebox_app/core/widgets/app_button.dart';
import 'package:bitebox_app/core/widgets/price_text.dart';
import 'package:bitebox_app/features/auth/presentation/auth_notifier.dart';
import 'package:bitebox_app/features/cart/presentation/cart_notifier.dart';
import 'package:bitebox_app/features/checkout/domain/checkout_constants.dart';
import 'package:bitebox_app/features/checkout/domain/payment_method.dart';
import 'package:bitebox_app/features/orders/presentation/orders_notifier.dart';
import 'package:bitebox_app/l10n/l10n_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  PaymentMethod _paymentMethod = PaymentMethod.cardDemo;
  bool _placing = false;

  Future<void> _placeOrder() async {
    final cart = ref.read(cartProvider);
    if (cart.isEmpty || _placing) return;

    setState(() => _placing = true);
    try {
      final order = await ref.read(ordersProvider.notifier).placeOrder(
            items: cart.lines,
            paymentMethod: _paymentMethod,
          );

      if (!mounted) return;
      final l10n = context.l10n;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.orderConfirmed(order.id))),
      );
      context.go(AppRoutes.orders);
    } catch (error) {
      if (!mounted) return;
      final l10n = context.l10n;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.placeOrderFailed('$error'))),
      );
    } finally {
      if (mounted) {
        setState(() => _placing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cart = ref.watch(cartProvider);
    final user = ref.watch(authProvider);
    final requireAuth = ref.watch(requireAuthForProtectedRoutesProvider);

    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.checkout)),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    l10n.checkoutEmpty,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                  ),
                ),
              ),
              AppButton(
                label: l10n.goToMenu,
                onPressed: () => context.go(AppRoutes.home),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkout)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            l10n.deliveryAddress,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            CheckoutConstants.demoAddress,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            user == null
                ? (requireAuth
                    ? l10n.signInRequiredCheckout
                    : l10n.guestCheckout)
                : l10n.signedInAs(user.email),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.hint,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.payment,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...PaymentMethod.values.map((method) {
            final selected = _paymentMethod == method;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.paymentMethodLabel(method)),
              leading: Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: selected ? AppColors.primary : AppColors.secondaryText,
              ),
              onTap: () => setState(() => _paymentMethod = method),
            );
          }),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.orderSummary,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...cart.lines.map((line) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.lineQuantityName(line.quantity, line.name),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  PriceText(
                    priceInCents: line.lineTotalInCents,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: AppSpacing.lg),
          Row(
            children: [
              Text(
                l10n.total,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Spacer(),
              PriceText(priceInCents: cart.subtotalInCents),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: _placing ? l10n.placingOrder : l10n.placeOrder,
            onPressed: _placing ? null : _placeOrder,
          ),
        ],
      ),
    );
  }
}
