import 'dart:math';

abstract class Fee {
  final String _name;
  final bool _isMandatory;

  Fee(this._name, this._isMandatory);

  double calculate(double gross);

  String get name => _name;
  bool get isMandatory => _isMandatory;

  Map<String, dynamic> toMap();

  static Fee fromJsonEntry(MapEntry<String, dynamic> entry) {
    final data = entry.value as Map<String, dynamic>;
    final isFlat = data['is_flat'] ?? false;

    return isFlat
        ? FlatFee.fromJsonEntry(entry)
        : MultiplierFee.fromJsonEntry(entry);
  }

  static List<Fee> fromJson(Map<String, Map<String, dynamic>> json) {
    return json.entries.map(Fee.fromJsonEntry).toList();
  }
}

class MultiplierFee extends Fee {
  final double _multiplier; // e.g. 0.1 for 10%
  final double _limit; // max fee after being multipled with price

  MultiplierFee(super._name, super._isMandatory, this._multiplier,
      {double limit = double.maxFinite})
      : _limit = limit;

  double get limit => _limit;

  @override
  double calculate(double gross) {
    final fee = min(_multiplier * gross, _limit);
    return fee;
  }

  static Fee fromJsonEntry(MapEntry<String, dynamic> feeEntry) {
    final data = feeEntry.value as Map<String, dynamic>;
    final amount = (data['amount'] as num).toDouble();

    if (data.containsKey('limit')) {
      return MultiplierFee(feeEntry.key, data['is_mandatory'], amount,
          limit: data['limit']);
    } else {
      return MultiplierFee(feeEntry.key, data['is_mandatory'], amount);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    final map = {
      "is_mandatory": super._isMandatory,
      "amount": _multiplier,
      "is_flat": false,
    };

    if (_limit != double.maxFinite) {
      map["limit"] = _limit;
    }

    return {super._name: map};
  }
}

class FlatFee extends Fee {
  final double _amount;

  FlatFee(super._name, super._isMandatory, this._amount);

  @override
  double calculate(double gross) {
    return _amount;
  }

  static Fee fromJsonEntry(MapEntry<String, dynamic> feeEntry) {
    final data = feeEntry.value as Map<String, dynamic>;
    return FlatFee(
      feeEntry.key,
      data['is_mandatory'],
      (data['amount'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        super._name: {
          'is_mandatory': _isMandatory,
          'amount': _amount,
          'is_flat': true
        }
      };
}

extension FeeListExtension on List<Fee> {
  double totalFee(double gross) =>
      fold(0.0, (sum, fee) => sum + fee.calculate(gross));

  Map<String, dynamic> toJson() {
    return {for (final fee in this) ...fee.toMap()};
  }
}
