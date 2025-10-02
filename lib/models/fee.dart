import 'dart:math';

abstract class Fee {
  final String _name;

  Fee(this._name);

  double calculate(double gross);

  String get name => _name;
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

}

class FlatFee extends Fee {
  final double _amount;

  FlatFee(super._name, this._amount);

  @override
  double calculate(double gross) {
    return _amount;
  }
}

extension FeeListExtension on List<Fee> {
  double totalFee(double gross) =>
      fold(0.0, (sum, fee) => sum + fee.calculate(gross));
}

extension JsonFeeConversion on Fee {}
