import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/models/marketplaces_enum.dart';

final marketplaceFilterProvider =
    NotifierProvider<MarketplaceFilterNotifier, Marketplaces>(
        MarketplaceFilterNotifier.new);

class MarketplaceFilterNotifier extends Notifier<Marketplaces> {
  @override
  Marketplaces build() => Marketplaces.tokopedia;

  void setMarketplace(Marketplaces mp) {
    state = mp;
  }
}
