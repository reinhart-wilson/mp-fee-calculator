import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/controllers/category_data_providers.dart';
import 'package:mp_calculator/models/category_node.dart';
import 'package:mp_calculator/models/searchable_category.dart';

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

class SelectedSearchableCategoryNotifier extends Notifier<SearchableCategory?> {
  @override
  SearchableCategory? build() => null;

  setCategory(SearchableCategory? cat) {
    state = cat;
  }

  clear() {
    state = build();
  }
}

final selectedSearchableCategoryProvider =
    NotifierProvider<SelectedSearchableCategoryNotifier, SearchableCategory?>(
        SelectedSearchableCategoryNotifier.new);

final categorySyncProvider = Provider<void>((ref) {
  ref.listen<SearchableCategory?>(
    selectedSearchableCategoryProvider,
    (prev, next) async {
      if (next == null) {
        ref.read(selectedCategoryLv1NotifierProvider.notifier).clear();
        ref.read(selectedCategoryLv2NotifierProvider.notifier).clear();
        ref.read(selectedCategoryLv3NotifierProvider.notifier).clear();
        return;
      }

      final tree = await ref.read(categoryTreeProvider.future);
      final lv1 = tree[next.catLv1];
      final lv2 = lv1?.children[next.catLv2];
      final lv3 = lv2?.children[next.catLv3];

      ref.read(selectedCategoryLv1NotifierProvider.notifier).setCategory(lv1);
      ref.read(selectedCategoryLv2NotifierProvider.notifier).setCategory(lv2);
      ref.read(selectedCategoryLv3NotifierProvider.notifier).setCategory(lv3);
    },
  );
});
