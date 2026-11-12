import 'package:bitebox_app/app/router/app_routes.dart';
import 'package:bitebox_app/app/theme/app_colors.dart';
import 'package:bitebox_app/app/theme/app_tokens.dart';
import 'package:bitebox_app/core/widgets/app_status_views.dart';
import 'package:bitebox_app/core/widgets/food_list_tile.dart';
import 'package:bitebox_app/features/auth/presentation/auth_notifier.dart';
import 'package:bitebox_app/features/catalog/domain/food_category.dart';
import 'package:bitebox_app/features/catalog/presentation/catalog_providers.dart';
import 'package:bitebox_app/features/settings/presentation/locale_notifier.dart';
import 'package:bitebox_app/l10n/l10n_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  FoodCategory? _category;
  String _query = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final itemsAsync = ref.watch(
      catalogItemsProvider(
        CatalogQuery(category: _category, query: _query),
      ),
    );
    final user = ref.watch(authProvider);
    final localePreference = ref.watch(localePreferenceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          PopupMenuButton<String>(
            tooltip: l10n.language,
            icon: const Icon(Icons.language),
            initialValue: localePreference,
            onSelected: (value) {
              ref.read(localePreferenceProvider.notifier).setPreference(value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: '', child: Text(l10n.languageSystem)),
              PopupMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
              PopupMenuItem(value: 'zh', child: Text(l10n.languageChinese)),
            ],
          ),
          if (user == null)
            TextButton(
              onPressed: () => context.push(AppRoutes.signIn),
              child: Text(l10n.signIn),
            )
          else
            PopupMenuButton<String>(
              tooltip: user.email,
              onSelected: (value) async {
                if (value == 'signOut') {
                  await ref.read(authProvider.notifier).signOut();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.signedOut)),
                  );
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  child: Text(user.email),
                ),
                PopupMenuItem(
                  value: 'signOut',
                  child: Text(l10n.signOut),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Center(
                  child: Text(
                    user.email.split('@').first,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Text(
              l10n.kitchenTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              l10n.kitchenSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondaryText,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.searchMenuHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                      ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: const BorderSide(color: AppColors.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: const BorderSide(color: AppColors.outline),
                ),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: FilterChip(
                    label: Text(l10n.categoryAll),
                    selected: _category == null,
                    onSelected: (_) => setState(() => _category = null),
                  ),
                ),
                ...FoodCategory.values.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: FilterChip(
                      label: Text(l10n.foodCategoryLabel(category)),
                      selected: _category == category,
                      onSelected: (_) => setState(() => _category = category),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: itemsAsync.when(
              loading: () => AppLoadingView(message: l10n.loadingMenu),
              error: (error, _) => AppErrorView(
                message: l10n.menuLoadError,
                onRetry: () => ref.invalidate(
                  catalogItemsProvider(
                    CatalogQuery(category: _category, query: _query),
                  ),
                ),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return AppEmptyView(message: l10n.menuEmpty);
                }
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return FoodListTile(
                      key: ValueKey(item.id),
                      name: item.name,
                      subtitle: item.description,
                      priceInCents: item.priceInCents,
                      category: item.category,
                      rating: item.rating,
                      onTap: () => context.push(
                        AppRoutes.productDetailsPath(item.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
