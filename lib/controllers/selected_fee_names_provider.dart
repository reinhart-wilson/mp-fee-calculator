import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedFeeNamesProvider =
    NotifierProvider<SelectedFeeNamesNotifier, Set<String>>(() {
  return SelectedFeeNamesNotifier();
});

class SelectedFeeNamesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String feeName) {
    final newState = Set<String>.from(state);
    if (!newState.remove(feeName)) newState.add(feeName);
    state = newState;
  }

  void clear() => state = {};
}
