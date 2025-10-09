import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/controllers/category_data_providers.dart';
import 'package:mp_calculator/controllers/selected_category_provider.dart';
import 'package:mp_calculator/models/searchable_category.dart';

class CategorySearchableDropdowns extends ConsumerWidget {
  const CategorySearchableDropdowns({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchableCategoryAsync = ref.watch(searchableCategoryProvider);
    final selectedSearchableCategory = ref.watch(selectedSearchableCategoryProvider);

    return searchableCategoryAsync.when(
      data: (categories) => DropdownSearch<SearchableCategory>(
        selectedItem: selectedSearchableCategory,
        compareFn: (a, b) => a.label == b.label,
        popupProps: const PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              labelText: 'Cari kategori...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        itemAsString: (item) => item.label,
        items: (f, cs) => categories,
        decoratorProps: const DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: 'Searchable Category',
            border: OutlineInputBorder(),
          ),
        ),
        onChanged: (selected) {
          ref.read(selectedSearchableCategoryProvider.notifier).setCategory(selected);
        },
      ),
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, _) => Text('Error: $err'),
    );
  }
}