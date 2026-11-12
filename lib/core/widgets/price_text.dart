import 'package:bitebox_app/app/theme/app_colors.dart';
import 'package:bitebox_app/core/utils/price_formatter.dart';
import 'package:flutter/material.dart';

class PriceText extends StatelessWidget {
  const PriceText({
    required this.priceInCents,
    super.key,
    this.style,
  });

  final int priceInCents;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatPriceInCents(priceInCents),
      style: style ??
          Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
    );
  }
}
