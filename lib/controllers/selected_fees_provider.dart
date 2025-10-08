import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/controllers/available_fees_provider.dart';
import 'package:mp_calculator/controllers/selected_fee_names_provider.dart';
import 'package:mp_calculator/models/fee.dart';

final selectedFeesProvider = Provider<List<Fee>>((ref) {
  final availableFees = ref.watch(availableFeesProvider);
  final selectedNames = ref.watch(selectedFeeNamesProvider);

  final selectedFees =
      availableFees.where((fee) => selectedNames.contains(fee.name)).toList();
  return selectedFees;
});
