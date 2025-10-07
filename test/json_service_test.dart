import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:mp_calculator/models/marketplaces_enum.dart';
import 'package:mp_calculator/services/json_service.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Category loading', () {
    test('loadCategoryTree parses categories_tree correctly', () async {
      final catTree = await loadCategoryTree(Marketplaces.tokopedia);

      // Check tree exists
      expect(catTree, isNotEmpty);
    });

    test('loadSearchableCategories parses searchable_categories correctly', () async {
      final categories = await loadSearchableCategories(Marketplaces.tokopedia);

      // Should not be empty
      expect(categories, isNotEmpty);
    });

    test('loadFixedFees parses Fee correctly', () async {
      final fees = await loadFixedFees(Marketplaces.tokopedia);

      // Should not be empty
      expect(fees, isNotEmpty);
    });
  });
}
