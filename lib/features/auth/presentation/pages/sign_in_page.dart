import 'package:bitebox_app/app/router/app_routes.dart';
import 'package:bitebox_app/app/theme/app_colors.dart';
import 'package:bitebox_app/app/theme/app_tokens.dart';
import 'package:bitebox_app/core/widgets/app_button.dart';
import 'package:bitebox_app/features/auth/domain/auth_exception.dart';
import 'package:bitebox_app/features/auth/domain/auth_validators.dart';
import 'package:bitebox_app/features/auth/presentation/auth_notifier.dart';
import 'package:bitebox_app/l10n/l10n_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  String? _formError;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    final emailError = AuthValidators.emailError(_emailController.text, l10n);
    final passwordError =
        AuthValidators.passwordError(_passwordController.text, l10n);
    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
      _formError = null;
    });
    if (emailError != null || passwordError != null) return;

    setState(() => _submitting = true);
    try {
      final user = await ref.read(authProvider.notifier).signIn(
            email: _emailController.text,
            password: _passwordController.text,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.signedInAs(user.email))),
      );
      final from = GoRouterState.of(context).uri.queryParameters['from'];
      context.go(
        (from != null && from.isNotEmpty)
            ? Uri.decodeComponent(from)
            : AppRoutes.home,
      );
    } on AuthException catch (error) {
      setState(() => _formError = error.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.signInTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            l10n.welcomeTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(
              labelText: l10n.email,
              hintText: l10n.emailHint,
              errorText: _emailError,
            ),
            onChanged: (_) {
              if (_emailError != null) setState(() => _emailError = null);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _passwordController,
            obscureText: true,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              labelText: l10n.password,
              errorText: _passwordError,
            ),
            onChanged: (_) {
              if (_passwordError != null) setState(() => _passwordError = null);
            },
            onSubmitted: (_) => _submit(),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.forgotPasswordPlaceholder)),
                );
              },
              child: Text(l10n.forgotPassword),
            ),
          ),
          if (_formError != null) ...[
            Text(
              _formError!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.error,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          AppButton(
            label: _submitting ? l10n.signingIn : l10n.signIn,
            onPressed: _submitting ? null : _submit,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => context.push(AppRoutes.signUp),
            child: Text(l10n.createAccount),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text(
                  l10n.orContinueWith,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.secondaryText,
                      ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.googleComingSoon)),
              );
            },
            child: Text(l10n.google),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.appleComingSoon)),
              );
            },
            child: Text(l10n.apple),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => context.go(AppRoutes.home),
            child: Text(l10n.continueAsGuest),
          ),
        ],
      ),
    );
  }
}
