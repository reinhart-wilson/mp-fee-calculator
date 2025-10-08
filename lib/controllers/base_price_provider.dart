
import 'package:flutter_riverpod/flutter_riverpod.dart';

final basePriceProvider =
    NotifierProvider<BasePriceNotifier, double>(BasePriceNotifier.new);

class BasePriceNotifier extends Notifier<double> {
  @override
  double build() => 0.0;

  void setBasePrice(double price) => state = price;

  void reset() => state = build();
}