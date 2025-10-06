import 'package:mp_calculator/models/fee.dart';
import 'package:test/test.dart';

void main() {
  group('MultiplierFee', () {
    test('Calculates uncapped fee correctly', () {
      final fee = MultiplierFee('Test Fee', true, 0.1); // 10%
      final gross = 1000.0;
      final net = fee.calculate(gross);
      expect(net, closeTo(100.0, 0.0001));
    });

    test('applies capped fee correctly', () {
      final fee = MultiplierFee('Test Fee', true, 0.1, limit: 10); // 10%
      final gross = 1000.0;
      final net = fee.calculate(gross);
      expect(net, closeTo(10.0, 0.0001));
    });

    test('loads from json correctly', () {
      final feesMap = {
        "test_fee1": {
          "amount": 0.02,
          "limit": 20000.0,
          "is_flat": false,
          "is_mandatory": false
        },
        "test_fee2": {"amount": 0.1, "is_flat": false, "is_mandatory": true}
      };

      final List<Fee> fees = feesMap.entries
          .map((entry) => MultiplierFee.fromJsonEntry(entry))
          .toList();
      expect(fees.length, 2);
    });

    test('returns correct map', () {
      final fee1 = MultiplierFee('test_fee', true, 0.1, limit: 100.0);
      final fee2 = MultiplierFee('test_fee', true, 0.1);

      final expected1 = {
        'test_fee': {
          'is_mandatory': true,
          'amount': 0.1,
          'is_flat': false,
          'limit': 100.0,
        }
      };
      final expected2 = {
        'test_fee': {
          'is_mandatory': true,
          'amount': 0.1,
          'is_flat': false,
        }
      };

      expect(fee1.toMap(), equals(expected1));
      expect(fee2.toMap(), equals(expected2));
    });
  });

  group('FlatFee', () {
    test('applies flat fee correctly', () {
      final fee = FlatFee("test_fee", true, 30.0);
      final gross = 500.0;
      final net = fee.calculate(gross);
      expect(net, closeTo(30.00, 0.0001));
    });

    test('loads from json correctly', () {
      final feesMap = {
        "test_fee1": {"amount": 10.0, "is_flat": true, "is_mandatory": false},
        "test_fee2": {"amount": 20.0, "is_flat": true, "is_mandatory": true}
      };

      final List<Fee> fees =
          feesMap.entries.map((entry) => FlatFee.fromJsonEntry(entry)).toList();
      expect(fees.length, 2);
    });

    test('returns correct map', () {
      final fee1 = FlatFee('test_fee', true, 0.1);
      final fee2 = FlatFee('test_fee', false, 0.1);

      final expected1 = {
        'test_fee': {
          'is_mandatory': true,
          'amount': 0.1,
          'is_flat': true,
        }
      };
      final expected2 = {
        'test_fee': {
          'is_mandatory': false,
          'amount': 0.1,
          'is_flat': true,
        }
      };

      expect(fee1.toMap(), equals(expected1));
      expect(fee2.toMap(), equals(expected2));
    });
  });

  group('Fee', () {
    test('converts from json entry correctly', () {
      final feesMap = {
        'multiplierfee': {
          'is_mandatory': true,
          'amount': 0.1,
          'is_flat': false,
        },
        'flatfee': {
          'is_mandatory': false,
          'amount': 0.1,
          'is_flat': true,
        }
      };
      final List<Fee> feesList =
          feesMap.entries.map((e) => Fee.fromJsonEntry(e)).toList();
      expect(feesList[0], isA<MultiplierFee>());
      expect(feesList[1], isA<FlatFee>());
    });

    test('converts from json correctly', () {
      final feesMap = {
        'multiplierfee': {
          'is_mandatory': true,
          'amount': 0.1,
          'is_flat': false,
        },
        'flatfee': {
          'is_mandatory': false,
          'amount': 0.1,
          'is_flat': true,
        }
      };
      final List<Fee> feesList = Fee.fromJson(feesMap);
      expect(feesList[0], isA<MultiplierFee>());
      expect(feesList[1], isA<FlatFee>());
    });
  });

  group('List of Fees', () {
    test('Calculates total fee correctly', () {
      final fees = [
        MultiplierFee('Mult1', true, 0.1),
        MultiplierFee('Mult2', false, 0.2, limit: 20),
        FlatFee('Flat1', true, 5)
      ];
      const gross = 1000.0;
      expect(fees.totalFee(gross), 125);
    });

    test('Converts to json map correctly', () {
      final fees = [
        MultiplierFee('Mult1', true, 0.1),
        MultiplierFee('Mult2', false, 0.2, limit: 20),
        FlatFee('Flat1', true, 5)
      ];

      final feesMap = {
        'Mult1': {'is_mandatory': true, 'amount': 0.1, 'is_flat': false},
        'Mult2': {
          'is_mandatory': false,
          'amount': 0.2,
          'is_flat': false,
          'limit': 20
        },
        'Flat1': {'is_mandatory': true, 'amount': 5, 'is_flat': true}
      };
      expect(fees.toJson(), equals(feesMap));
    });
  });
}
