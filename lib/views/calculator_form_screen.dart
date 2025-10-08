import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/controllers/available_fees_provider.dart';
import 'package:mp_calculator/controllers/base_price_provider.dart';
import 'package:mp_calculator/controllers/calculated_price_provider.dart';
import 'package:mp_calculator/controllers/category_data_providers.dart';
import 'package:mp_calculator/controllers/marketplace_filter_provider.dart';
import 'package:mp_calculator/controllers/selected_category_provider.dart';
import 'package:mp_calculator/controllers/selected_fee_names_provider.dart';
import 'package:mp_calculator/models/marketplaces_enum.dart';
import 'package:mp_calculator/models/category_node.dart';

class CalculatorFormScreen extends ConsumerWidget {
  const CalculatorFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketplace = ref.watch(marketplaceFilterProvider);
    final categoryTreeAsync = ref.watch(categoryTreeProvider);
    final categoryLv2 = ref.watch(categoryLv2Provider);
    final categoryLv3 = ref.watch(categoryLv3Provider);
    final selectedCategoryLv1 = ref.watch(selectedCategoryLv1NotifierProvider);
    final selectedCategoryLv2 = ref.watch(selectedCategoryLv2NotifierProvider);
    final selectedCategoryLv3 = ref.watch(selectedCategoryLv3NotifierProvider);
    final availableFees = ref.watch(availableFeesProvider);
    final selectedFeesNameState = ref.watch(selectedFeeNamesProvider);
    final calculationMode = ref.watch(calculationModeProvider);
    final calculatedPrice = ref.watch(calculatedPriceProvider);
    final calculatedPriceLabel =
        calculationMode == CalculationMode.grossToNet ? 'Net' : 'Gross';
    final inputPriceLabel =
        calculationMode == CalculationMode.grossToNet ? 'Gross' : 'Net';

    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Marketplace Dropdown
            DropdownButton<Marketplaces>(
              value: marketplace,
              onChanged: (newValue) {
                if (newValue != null) {
                  ref
                      .read(marketplaceFilterProvider.notifier)
                      .setMarketplace(newValue);
                }
              },
              items: Marketplaces.values.map((market) {
                return DropdownMenuItem(
                  value: market,
                  child: Text(market.name),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Category Lv1 Dropdown
            categoryTreeAsync.when(
                data: (tree) {
                  return CategoryDropdown(
                      label: "Cat Lv1",
                      selected: selectedCategoryLv1,
                      options: tree,
                      onChanged: (newLv1) {
                        ref
                            .read(selectedCategoryLv1NotifierProvider.notifier)
                            .setCategory(newLv1);
                        ref
                            .read(selectedCategoryLv2NotifierProvider.notifier)
                            .clear();
                        ref
                            .read(selectedCategoryLv3NotifierProvider.notifier)
                            .clear();
                      });
                },
                loading: () => const CircularProgressIndicator(),
                error: (err, _) => Text('Error loading categories: $err')),

            CategoryDropdown(
                label: "Cat Lv2",
                selected: selectedCategoryLv2,
                options: categoryLv2,
                onChanged: (node) {
                  ref
                      .read(selectedCategoryLv2NotifierProvider.notifier)
                      .setCategory(node);
                  ref
                      .read(selectedCategoryLv3NotifierProvider.notifier)
                      .clear();
                }),

            CategoryDropdown(
                label: "Cat Lv3",
                selected: selectedCategoryLv3,
                options: categoryLv3,
                onChanged: (node) {
                  ref
                      .read(selectedCategoryLv3NotifierProvider.notifier)
                      .setCategory(node);
                }),

            const SizedBox(height: 16),

            // Fee Checkboxes (from selected category)
            if (selectedCategoryLv1 != null)
              Wrap(
                spacing: 8,
                children: availableFees.map((fee) {
                  return FilterChip(
                    label: Text(fee.formattedName),
                    selected: selectedFeesNameState.contains(fee.name),
                    onSelected: (selected) {
                      ref
                          .read(selectedFeeNamesProvider.notifier)
                          .toggle(fee.name);
                    },
                  );
                }).toList(),
              ),

            const SizedBox(height: 16),

            // Base Price Input
            TextField(
              decoration: InputDecoration(labelText: '$inputPriceLabel Price'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final price = double.tryParse(value) ?? 0.0;
                ref.read(basePriceProvider.notifier).setBasePrice(price);
              },
            ),

            const SizedBox(height: 16),

            // Net Price
            Text(
              '$calculatedPriceLabel Price: ${calculatedPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            // Toggle calculation mode
            SegmentedButton<CalculationMode>(
              segments: const <ButtonSegment<CalculationMode>>[
                ButtonSegment(
                    value: CalculationMode.netToGross,
                    label: Text('Net → Gross')),
                ButtonSegment(
                    value: CalculationMode.grossToNet,
                    label: Text('Gross → Net')),
              ],
              selected: <CalculationMode>{calculationMode},
              onSelectionChanged: (Set<CalculationMode> newSelection) {
                final selected = newSelection.first;
                if (selected != calculationMode) {
                  ref.read(calculationModeProvider.notifier).setMode(selected);
                }
              },
            ),

            // Fee Breakdown
            // Text('Applied Fees:'),
            // ...selectedFees.map((fee) => Text(
            //     '${fee.name}: ${fee.calculate(basePrice).toStringAsFixed(2)}')),

            // const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class CategoryDropdown extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    if (options == null || options!.isEmpty) {
      return const SizedBox.shrink();
    }

    return DropdownButton<CategoryNode>(
      value: selected,
      hint: Text(label),
      items: options!.values.map((node) {
        return DropdownMenuItem(
          value: node,
          child: Text(node.name),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
