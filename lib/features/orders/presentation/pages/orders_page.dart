import 'package:bitebox_app/app/router/app_routes.dart';
import 'package:bitebox_app/app/theme/app_colors.dart';
import 'package:bitebox_app/app/theme/app_tokens.dart';
import 'package:bitebox_app/core/utils/price_formatter.dart';
import 'package:bitebox_app/core/widgets/app_status_views.dart';
import 'package:bitebox_app/core/widgets/price_text.dart';
import 'package:bitebox_app/features/orders/domain/order.dart';
import 'package:bitebox_app/features/orders/presentation/orders_notifier.dart';
import 'package:bitebox_app/l10n/l10n_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ordersTitle)),
      body: ordersAsync.when(
        loading: () => AppLoadingView(message: l10n.loadingOrders),
        error: (error, _) => AppErrorView(
          message: l10n.ordersLoadError,
          onRetry: () => ref.invalidate(ordersProvider),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return AppEmptyView(
              message: l10n.ordersEmpty,
              actionLabel: l10n.goToMenu,
              onAction: () => context.go(AppRoutes.home),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            itemCount: orders.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _OrderTile(order: orders[index]);
            },
          );
        },
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final timeLabel =
        DateFormat('MMM d · HH:mm').format(order.createdAt.toLocal());
    final status = l10n.orderStatusLabel(order.status);
    final payment = l10n.paymentMethodLabel(order.paymentMethod);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      title: Text(
        order.id,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xxs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$timeLabel · $status',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              l10n.orderItemsPayment(order.itemCount, payment),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              order.addressText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.hint,
                  ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              order.items
                  .map((line) => '${line.quantity}× ${line.name}')
                  .join(', '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      trailing: PriceText(
        priceInCents: order.totalCents,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
      ),
      isThreeLine: true,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${order.id}: ${formatPriceInCents(order.totalCents)} · $status',
            ),
          ),
        );
      },
    );
  }
}
