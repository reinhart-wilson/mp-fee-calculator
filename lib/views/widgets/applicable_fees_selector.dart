import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/controllers/available_fees_provider.dart';
import 'package:mp_calculator/controllers/selected_fee_names_provider.dart';

class ApplicableFeesSelector extends ConsumerWidget {
  const ApplicableFeesSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableFees = ref.watch(availableFeesProvider);
    final selectedFeesNameState = ref.watch(selectedFeeNamesProvider);

    return availableFees.isEmpty
        ? const Text('No applicable fees for this category.')
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4,
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
              const SizedBox(height: 12),
              Text(
                '*Mandatory fees',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          );
  }
}
