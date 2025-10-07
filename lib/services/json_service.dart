import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mp_calculator/models/category_node.dart';
import 'package:mp_calculator/models/fee.dart';
import 'package:mp_calculator/models/marketplaces_enum.dart';
import 'package:mp_calculator/models/searchable_category.dart';

Future<Map<String, CategoryNode>> loadCategoryTree(Marketplaces mp) async {
  final jsonString = await rootBundle.loadString('assets/data/${mp.name}.json');
  final decoded = jsonDecode(jsonString);

  final catTree = <String, CategoryNode>{};
  final treeJson = decoded['categories_tree'] as Map<String, dynamic>;

  treeJson.forEach((key, value) {
    if (value is Map<String, dynamic>) {
      catTree[key] = CategoryNode.fromJson(key, value);
    }
  });

  return catTree;
}

Future<List<SearchableCategory>> loadSearchableCategories(
    Marketplaces mp) async {
  final jsonString = await rootBundle.loadString('assets/data/${mp.name}.json');
  final decoded = jsonDecode(jsonString);

  final listJson = decoded['searchable_categories'] as List;

  List<SearchableCategory> categoriesList = listJson
      .map((item) => SearchableCategory.fromJson(item as Map<String, dynamic>))
      .whereType<SearchableCategory>() // filters out nulls
      .toList();

  return categoriesList;
}

Future<List<Fee>> loadFixedFees(Marketplaces mp) async {
  final jsonString = await rootBundle.loadString('assets/data/fixed_fees.json');
  final decoded = jsonDecode(jsonString) as Map<String, dynamic>;

  final rawMap = decoded[mp.name] as Map<String, dynamic>;
  final mpFeesMap = rawMap.map((key, value) => MapEntry(
        key,
        value as Map<String, dynamic>,
      ));

  return Fee.fromJson(mpFeesMap);
}
