import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/controllers/base_price_provider.dart';
import 'package:mp_calculator/controllers/selected_fees_provider.dart';
import 'package:mp_calculator/models/fee.dart';
import 'package:mp_calculator/models/fee_calculator.dart';

enum CalculationMode { netToGross, grossToNet }

final calculatedPriceProvider = Provider<double>((ref) {
  final basePrice = ref.watch(basePriceProvider);
  final selectedFees = ref.watch(selectedFeesProvider);
  final mode = ref.watch(calculationModeProvider);
  
  final calculator = FeeCalculator(
    multiplierFees: selectedFees.whereType<MultiplierFee>().toList(),
    flatFees: selectedFees.whereType<FlatFee>().toList(),
  );

  switch (mode) {
    case CalculationMode.grossToNet:
      return calculator.calculateNet(basePrice);
    case CalculationMode.netToGross:
      return calculator.calculateGross(basePrice);
    default:
      throw Exception('Unknown calculation mode');
  }
});

final calculationModeProvider =
    NotifierProvider<CalculationModeNotifier, CalculationMode>(
        CalculationModeNotifier.new);

class CalculationModeNotifier extends Notifier<CalculationMode> {
  @override
  CalculationMode build() => CalculationMode.netToGross;

  void setMode(CalculationMode mode) {
    state = mode;
  }
}
