import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/controllers/category_data_providers.dart';
import 'package:mp_calculator/controllers/selected_category_provider.dart';
import 'package:mp_calculator/models/fee.dart';

final availableFeesProvider = Provider<List<Fee>>((ref) {
  final fixedFeesAsync = ref.watch(fixedFeesProvider);
  final selectedCategoryLv2 = ref.watch(selectedCategoryLv2NotifierProvider);
  final selectedCategoryLv3 = ref.watch(selectedCategoryLv3NotifierProvider);

  // If fixed fees aren't loaded yet, return empty to prevent null errors
  final fixedFees = fixedFeesAsync.asData?.value ?? [];

  // If category selected, include its fees
  final fees = selectedCategoryLv3?.fees ?? selectedCategoryLv2?.fees;
  final categoryFees = fees ?? [];

  // Combine both
  return [...fixedFees, ...categoryFees];
});