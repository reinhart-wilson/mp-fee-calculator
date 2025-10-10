import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/controllers/selected_category_provider.dart';
import 'package:mp_calculator/themes/app_sizes.dart';
import 'package:mp_calculator/views/widgets/calculation_section.dart';
import 'package:mp_calculator/views/widgets/category_section.dart';
import 'package:mp_calculator/views/widgets/marketplace_selector_section.dart';

class CalculatorFormScreen extends ConsumerWidget {
  const CalculatorFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(categorySyncProvider);
    ref.watch(marketplaceSyncProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Marketplace Calculator',
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarketplaceSelectorSection(),
                  SizedBox(height: AppSizes.paddingSmall),
                  CategorySection(),
                  SizedBox(height: AppSizes.paddingSmall),
                  CalculationSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
