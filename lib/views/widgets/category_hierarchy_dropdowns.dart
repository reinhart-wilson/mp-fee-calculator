import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/controllers/category_data_providers.dart';
import 'package:mp_calculator/controllers/selected_category_provider.dart';
import 'package:mp_calculator/views/widgets/base_widgets/category_dropdown.dart';

class CategoryHierarchyDropdowns extends ConsumerWidget {
  const CategoryHierarchyDropdowns({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(categorySyncProvider);

    final categoryTreeAsync = ref.watch(categoryTreeProvider);
    final categoryLv2 = ref.watch(categoryLv2Provider);
    final categoryLv3 = ref.watch(categoryLv3Provider);
    final selectedCategoryLv1 = ref.watch(selectedCategoryLv1NotifierProvider);
    final selectedCategoryLv2 = ref.watch(selectedCategoryLv2NotifierProvider);
    final selectedCategoryLv3 = ref.watch(selectedCategoryLv3NotifierProvider);

    return Column(
      children: [
        categoryTreeAsync.when(
          data: (tree) => CategoryDropdown(
            label: "Category Level 1",
            selected: selectedCategoryLv1,
            options: tree,
            onChanged: (newLv1) {
              ref
                  .read(selectedCategoryLv1NotifierProvider.notifier)
                  .setCategory(newLv1);
              ref.read(selectedCategoryLv2NotifierProvider.notifier).clear();
              ref.read(selectedCategoryLv3NotifierProvider.notifier).clear();
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Text('Error loading categories: $err'),
        ),
        const SizedBox(height: 12),
        if (categoryLv2 != null && categoryLv2.isNotEmpty)
          CategoryDropdown(
            label: "Category Level 2",
            selected: selectedCategoryLv2,
            options: categoryLv2,
            onChanged: (node) {
              ref
                  .read(selectedCategoryLv2NotifierProvider.notifier)
                  .setCategory(node);
              ref.read(selectedCategoryLv3NotifierProvider.notifier).clear();
            },
          ),
        const SizedBox(height: 12),
        if (categoryLv3 != null && categoryLv3.isNotEmpty)
          CategoryDropdown(
            label: "Category Level 3",
            selected: selectedCategoryLv3,
            options: categoryLv3,
            onChanged: (node) {
              ref
                  .read(selectedCategoryLv3NotifierProvider.notifier)
                  .setCategory(node);
            },
          ),
      ],
    );
  }
}
