import 'dart:convert';

import 'package:mp_calculator/models/fee.dart';
import 'package:mp_calculator/models/marketplaces_enum.dart';
import 'package:mp_calculator/models/searchable_category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Instance statis yang bisa diakses di mana saja
  static late final SharedPreferencesService instance;

  final SharedPreferences _prefs;

  // Private constructor
  SharedPreferencesService._(this._prefs);

  // Inisialisasi satu kali di main()
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    instance = SharedPreferencesService._(prefs);
  }

  static const _kFees = 'selected_fees';
  static const _kSCategory = 'selected_s_cat';
  static const _kCategoryNode = 'selected_cat_node';
  static const _kMarketplace = 'selected_marketplace';

  Future<void> setSelectedCategory(SearchableCategory? category) {
    if (category == null) return _prefs.remove(_kSCategory);
    final categoryJson = jsonEncode(category.toJson());
    return _prefs.setString(_kSCategory, categoryJson);
  }

  SearchableCategory? getSelectedCategory() {
    final categoryJson = _prefs.getString(_kSCategory);
    if (categoryJson == null) return null;
    try {
      final categoryMap = jsonDecode(categoryJson) as Map<String, dynamic>;
      return SearchableCategory.fromJson(categoryMap);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> setSelectedFees(List<String> feeNames) {
    return _prefs.setStringList(_kFees, feeNames);
  }

  List<String>? getSelectedFeeNames() {
    return _prefs.getStringList(_kFees);
  }

  Future<void> setSelectedMarketplace(Marketplaces? mp) {
    print(mp);
    if (mp == null) return _prefs.remove(_kMarketplace);
    final mpStr = mp.displayName;
    return _prefs.setString(_kMarketplace, mpStr);
  }

  Marketplaces getSelectedMarketplace() {
    return Marketplaces.fromString(_prefs.getString(_kMarketplace));
  }
}
