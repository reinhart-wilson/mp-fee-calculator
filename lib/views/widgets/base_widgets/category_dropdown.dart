import 'package:flutter/material.dart';
import 'package:mp_calculator/models/category_node.dart';

class CategoryDropdown extends StatelessWidget {
  final String label;
  final CategoryNode? selected;
  final Map<String, CategoryNode>? options;
  final void Function(CategoryNode?) onChanged;

  const CategoryDropdown({
    super.key,
    required this.label,
    required this.selected,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (options == null || options!.isEmpty) return const SizedBox.shrink();

    return DropdownButtonFormField<CategoryNode>(
      value: selected,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: options!.values
          .map((node) => DropdownMenuItem(
                value: node,
                child: Text(node.name),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
