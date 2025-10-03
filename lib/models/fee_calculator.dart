import 'package:mp_calculator/models/fee.dart';

class FeeCalculator {
  final List<MultiplierFee> multiplierFees;
  final List<FlatFee> flatFees;

  FeeCalculator({
    this.multiplierFees = const [],
    this.flatFees = const [],
  });

  double calculateNet(double gross) {
    final calculatedSum = multiplierFees.totalFee(gross);
    final flatSum = flatFees.totalFee(gross);
    return gross - calculatedSum - flatSum;
  }

  /// Use binary search to guess gross price between reasonable bounds:
  /// minGross = net + flatFee. This is a known minimum possible value
  /// maxGross = some large number, in this case 2 * net
  double calculateGross(double net) {
    final flatFee = flatFees.totalFee(0); // 0 is a placeholder since flat fees do not depend on gross price

    double minGross = net + flatFee;
    double maxGross = 2 * net;
    double midGross = 0;
    const epsilon = 0.0001;

    while ((maxGross - minGross) > epsilon) {
      midGross = (minGross + maxGross) / 2;

      double totalFees = 0;
      for (final fee in multiplierFees) {
        final feeAmount = (fee.calculate(midGross)).clamp(0, fee.limit);
        totalFees += feeAmount;
      }

      final calculatedNet = midGross - totalFees - flatFee;

      if (calculatedNet > net) {
        // Guess is too high, decrease gross
        maxGross = midGross;
      } else {
        // Guess is too low, increase gross
        minGross = midGross;
      }
    }

    return midGross;
  }
}
