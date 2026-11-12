import 'package:bitebox_app/app/theme/app_tokens.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: onPressed,
      child: Text(label),
    );

    if (!expanded) {
      return button;
    }

    return SizedBox(
      width: double.infinity,
      height: AppSizes.touchTarget,
      child: button,
    );
  }
}
