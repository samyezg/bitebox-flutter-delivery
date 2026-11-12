import 'package:bitebox_app/app/config/app_environment_provider.dart';
import 'package:bitebox_app/features/catalog/data/mock_catalog_repository.dart';
import 'package:bitebox_app/features/catalog/data/supabase_catalog_repository.dart';
import 'package:bitebox_app/features/catalog/domain/catalog_repository.dart';
import 'package:bitebox_app/features/catalog/domain/food_category.dart';
import 'package:bitebox_app/features/catalog/domain/food_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final env = ref.watch(appEnvironmentProvider);
  if (env.useSupabase) {
    return SupabaseCatalogRepository(Supabase.instance.client);
  }
  return const MockCatalogRepository();
});

class CatalogQuery {
  const CatalogQuery({this.category, this.query = ''});

  final FoodCategory? category;
  final String query;

  @override
  bool operator ==(Object other) {
    return other is CatalogQuery &&
        other.category == category &&
        other.query == query;
  }

  @override
  int get hashCode => Object.hash(category, query);
}

final catalogItemsProvider =
    FutureProvider.family<List<FoodItem>, CatalogQuery>((ref, query) {
  return ref.watch(catalogRepositoryProvider).getItems(
        category: query.category,
        query: query.query,
      );
});

final foodItemProvider = FutureProvider.family<FoodItem?, String>((ref, id) {
  return ref.watch(catalogRepositoryProvider).getItemById(id);
});
