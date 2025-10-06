import 'package:mp_calculator/models/fee.dart';
import 'package:mp_calculator/models/fee_calculator.dart';
import 'package:test/test.dart';

void main() {
  group('Fee Calculator Test', () {
    test('Calculates final price correctly', () {
      final multFees = [
        MultiplierFee('Mult1', true, 0.1),
        MultiplierFee('Mult2', false, 0.2, limit: 20),
      ];

      final flatFees = [FlatFee('Flat1', true, 5)];

      final calc = FeeCalculator(multiplierFees: multFees, flatFees: flatFees);
      const gross = 1000.0;
      expect(calc.calculateNet(gross), closeTo(875, 0.01));
    });

    test('Calculates gross price correctly (limit cap)', () {
      final multFees = [
        MultiplierFee('Mult1', true, 0.1),
        MultiplierFee('Mult2', false, 0.1, limit: 20),
      ];

      final flatFees = [FlatFee('Flat1', true, 5)];

      final calc = FeeCalculator(multiplierFees: multFees, flatFees: flatFees);
      const net = 875.0;
      expect(calc.calculateGross(net), closeTo(1000, 0.01));
    });

    test('Calculates gross price correctly (limit not met)', () {
      final multFees = [
        MultiplierFee('Mult1', true, 0.1),
        MultiplierFee('Mult2', false, 0.15, limit: 200),
        MultiplierFee('Mult3', false, 0.02, limit: 200),
      ];

      final flatFees = [FlatFee('Flat1', true, 5)];

      final calc = FeeCalculator(multiplierFees: multFees, flatFees: flatFees);
      const net = 725.0;
      expect(calc.calculateGross(net), closeTo(1000, 0.01));
    });
  });
}
