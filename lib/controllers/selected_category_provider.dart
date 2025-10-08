import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/models/category_node.dart';

class SelectedCategoryNotifier extends Notifier<CategoryNode?> {
  @override
  CategoryNode? build() => null;

  setCategory(CategoryNode? cat) {
    state = cat;
  }

  clear() {
    state = build();
  }
}

final selectedCategoryLv1NotifierProvider =
    NotifierProvider<SelectedCategoryNotifier, CategoryNode?>(
        SelectedCategoryNotifier.new);

final selectedCategoryLv2NotifierProvider =
    NotifierProvider<SelectedCategoryNotifier, CategoryNode?>(
        SelectedCategoryNotifier.new);

final selectedCategoryLv3NotifierProvider =
    NotifierProvider<SelectedCategoryNotifier, CategoryNode?>(
        SelectedCategoryNotifier.new);

final categoryLv2Provider = Provider<Map<String, CategoryNode>?>((ref) {
  final catLv1 = ref.watch(selectedCategoryLv1NotifierProvider);
  return catLv1?.children;
});

final categoryLv3Provider = Provider<Map<String, CategoryNode>?>((ref) {
  final catLv2 = ref.watch(selectedCategoryLv2NotifierProvider);
  return catLv2?.children;
});

