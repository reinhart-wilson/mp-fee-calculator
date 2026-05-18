import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/models/marketplaces_enum.dart';
import 'package:mp_calculator/services/shared_preferences_service.dart';

final marketplaceFilterProvider =
    NotifierProvider<MarketplaceFilterNotifier, Marketplaces>(
        MarketplaceFilterNotifier.new);

class MarketplaceFilterNotifier extends Notifier<Marketplaces> {
  @override
  Marketplaces build() =>
      SharedPreferencesService.instance.getSelectedMarketplace();

  void setMarketplace(Marketplaces mp) {
    SharedPreferencesService.instance.setSelectedMarketplace(mp);
    state = mp;
  }
}
