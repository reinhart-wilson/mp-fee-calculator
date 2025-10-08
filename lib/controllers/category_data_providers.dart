import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/controllers/marketplace_filter_provider.dart';
import 'package:mp_calculator/models/category_node.dart';
import 'package:mp_calculator/models/fee.dart';
import 'package:mp_calculator/models/searchable_category.dart';
import 'package:mp_calculator/services/json_service.dart';

final searchableCategoryProvider =
    FutureProvider<List<SearchableCategory>>((ref) async {
  final filter = ref.watch(marketplaceFilterProvider);
  return loadSearchableCategories(filter);
});

final categoryTreeProvider =
    FutureProvider<Map<String, CategoryNode>>((ref) async {
  final filter = ref.watch(marketplaceFilterProvider);
  return loadCategoryTree(filter);
});

final fixedFeesProvider = FutureProvider<List<Fee>>((ref) async {
  final filter = ref.watch(marketplaceFilterProvider);
  return loadFixedFees(filter);
});

