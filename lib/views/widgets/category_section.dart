import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/controllers/category_selection_provider.dart';
import 'package:mp_calculator/views/widgets/category_hierarchy_dropdowns.dart';
import 'package:mp_calculator/views/widgets/base_widgets/section_card.dart';
import 'package:mp_calculator/views/widgets/category_searchable_dropdowns.dart';

class CategorySection extends ConsumerWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(categorySelectionModeProvider);
    return SectionCard(
        title: "Select Category",
        leadingWidget: const CategoryModeSwitch(),
        child: mode == CategorySelectionMode.cascading
            ? const CategoryHierarchyDropdowns()
            : const CategorySearchableDropdowns());
  }
}

class CategoryModeSwitch extends ConsumerWidget {
  const CategoryModeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(categorySelectionModeProvider);
    final textTheme = Theme.of(context).textTheme;

    return SegmentedButton<CategorySelectionMode>(
      segments: [
        ButtonSegment(
          value: CategorySelectionMode.searchable,
          label: Text('Search', style: textTheme.labelMedium,),
          icon: const Icon(Icons.search),
        ),
        ButtonSegment(
          value: CategorySelectionMode.cascading,
          label: Text('Dropdowns',style: textTheme.labelMedium,),
          icon: const Icon(Icons.list),
        ),
      ],
      selected: {mode},
      onSelectionChanged: (newSelection) {
        ref
            .read(categorySelectionModeProvider.notifier)
            .setMode(newSelection.first);
      },
    );
  }
}
