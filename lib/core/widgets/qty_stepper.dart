import 'package:bitebox_app/app/theme/app_colors.dart';
import 'package:bitebox_app/app/theme/app_tokens.dart';
import 'package:flutter/material.dart';

class QtyStepper extends StatelessWidget {
  const QtyStepper({
    required this.quantity,
    required this.onChanged,
    super.key,
    this.min = 1,
    this.max = 99,
  });

  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RoundIconButton(
          icon: Icons.remove,
          onPressed: quantity > min ? () => onChanged(quantity - 1) : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            '$quantity',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        _RoundIconButton(
          icon: Icons.add,
          onPressed: quantity < max ? () => onChanged(quantity + 1) : null,
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.touchTarget,
      height: AppSizes.touchTarget,
      child: IconButton.filledTonal(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.surfaceVariant,
          foregroundColor: AppColors.primaryText,
          disabledBackgroundColor: AppColors.divider,
        ),
        icon: Icon(icon, size: AppSizes.iconMd),
      ),
    );
  }
}
