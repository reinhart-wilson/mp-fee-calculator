import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/services/shared_preferences_service.dart';

final selectedFeeNamesProvider =
    NotifierProvider<SelectedFeeNamesNotifier, Set<String>>(() {
  return SelectedFeeNamesNotifier();
});

class SelectedFeeNamesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    // Ambil data saat aplikasi pertama kali dijalankan (init)
    final savedFees = SharedPreferencesService.instance.getSelectedFeeNames();
    return savedFees?.toSet() ?? {};
  }

  void toggle(String feeName) {
    final newState = Set<String>.from(state);
    if (!newState.remove(feeName)) newState.add(feeName);
    state = newState;
    SharedPreferencesService.instance.setSelectedFees(state.toList());
  }

  void clear() => state = {};

  void setSelected(Iterable<String> feeNames) {
    state = feeNames.toSet();
  }
}
