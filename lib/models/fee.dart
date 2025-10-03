import 'dart:math';

abstract class Fee {
  final String _name;

  Fee(this._name);

  double calculate(double gross);

  String get name => _name;

  Map<String, dynamic> toMap();

  static Fee fromJsonEntry(MapEntry<String, dynamic> entry) {
    final data = entry.value as Map<String, dynamic>;
    final isFlat = data['is_flat'] ?? false;

    return isFlat
        ? FlatFee.fromJsonEntry(entry)
        : MultiplierFee.fromJsonEntry(entry);
  }

  static List<Fee> fromJson(Map<String, dynamic> json) {
    return json.entries.map(Fee.fromJsonEntry).toList();
  }
}

class MultiplierFee extends Fee {
  final double _multiplier; // e.g. 0.1 for 10%
  final double _limit; // max fee after being multipled with price

  MultiplierFee(super._name, this._multiplier,
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
    return MultiplierFee(feeEntry.key, data['amount'],
        limit: data.containsKey('limit') ? data['limit'] : null);
  }

  @override
  Map<String, dynamic> toMap() {
    final map = {
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

  FlatFee(super._name, this._amount);

  @override
  double calculate(double gross) {
    return _amount;
  }

  static Fee fromJsonEntry(MapEntry<String, dynamic> feeEntry) {
    final data = feeEntry.value as Map<String, dynamic>;
    return FlatFee(
      feeEntry.key,
      data['amount'],
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        super._name: {'amount': _amount, 'is_flat': true}
      };
}

extension FeeListExtension on List<Fee> {
  double totalFee(double gross) =>
      fold(0.0, (sum, fee) => sum + fee.calculate(gross));

  Map<String, dynamic> toJson() {
    return {for (final fee in this) ...fee.toMap()};
  }
}
