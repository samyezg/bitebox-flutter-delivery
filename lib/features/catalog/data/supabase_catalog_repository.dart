import 'package:bitebox_app/features/catalog/domain/catalog_repository.dart';
import 'package:bitebox_app/features/catalog/domain/food_category.dart';
import 'package:bitebox_app/features/catalog/domain/food_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseCatalogRepository implements CatalogRepository {
  SupabaseCatalogRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<FoodItem>> getItems({
    FoodCategory? category,
    String query = '',
  }) async {
    var filter = _client.from('menu_items').select().eq('available', true);
    if (category != null) {
      filter = filter.eq('category', category.name);
    }

    final rows = await filter.order('sort_order');
    final normalized = query.trim().toLowerCase();
    final items = rows.map(_mapRow).where((item) {
      if (normalized.isEmpty) return true;
      return item.name.toLowerCase().contains(normalized) ||
          item.description.toLowerCase().contains(normalized);
    });
    return items.toList(growable: false);
  }

  @override
  Future<FoodItem?> getItemById(String id) async {
    final rows =
        await _client.from('menu_items').select().eq('id', id).limit(1);
    if (rows.isEmpty) return null;
    return _mapRow(rows.first);
  }

  FoodItem _mapRow(Map<String, dynamic> row) {
    return FoodItem(
      id: row['id'] as String,
      name: row['name'] as String,
      description: row['description'] as String,
      category: FoodCategory.values.byName(row['category'] as String),
      priceInCents: row['price_in_cents'] as int,
      rating: (row['rating'] as num).toDouble(),
      imageAssetPath: row['image_asset_path'] as String?,
      available: row['available'] as bool? ?? true,
    );
  }
}
