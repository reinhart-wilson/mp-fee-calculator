import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/controllers/marketplace_filter_provider.dart';
import 'package:mp_calculator/models/marketplaces_enum.dart';
import 'package:mp_calculator/views/widgets/base_widgets/section_card.dart';

class MarketplaceSelectorSection extends ConsumerWidget {
  const MarketplaceSelectorSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketplace = ref.watch(marketplaceFilterProvider);
    return SectionCard(
      title: 'Marketplace',
      child: DropdownButtonFormField<Marketplaces>(
        value: marketplace,
        decoration: const InputDecoration(
          labelText: 'Select Marketplace',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
        ),
        onChanged: (newValue) {
          if (newValue != null) {
            ref.read(marketplaceFilterProvider.notifier).setMarketplace(newValue);
          }
        },
        items: Marketplaces.values
            .map((m) => DropdownMenuItem(value: m, child: Text(m.name)))
            .toList(),
      ),
    );
  }
}
