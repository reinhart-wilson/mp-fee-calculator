import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CategorySelectionMode { searchable, cascading }

class CategorySelectionModeNotifier extends Notifier<CategorySelectionMode> {
  @override
  CategorySelectionMode build() => CategorySelectionMode.searchable;

  setMode(CategorySelectionMode mode) => state = mode;
}

final categorySelectionModeProvider =
    NotifierProvider<CategorySelectionModeNotifier, CategorySelectionMode>(
        CategorySelectionModeNotifier.new);
