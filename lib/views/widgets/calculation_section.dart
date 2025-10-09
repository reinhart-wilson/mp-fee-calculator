import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/controllers/base_price_provider.dart';
import 'package:mp_calculator/controllers/calculated_price_provider.dart';
import 'package:mp_calculator/themes/app_sizes.dart';
import 'package:mp_calculator/utils/formatter.dart';
import 'package:mp_calculator/views/utils/currency_input_formatter.dart';
import 'package:mp_calculator/views/widgets/applicable_fees_selector.dart';
import 'package:mp_calculator/views/widgets/base_widgets/section_card.dart';

class CalculationSection extends ConsumerWidget {
  const CalculationSection({
    super.key,
  });

  // Helper for getting text labels
  String _getPriceLabel(CalculationMode mode, {required bool isInput}) {
    final isGrossToNet = mode == CalculationMode.grossToNet;
    return isInput
        ? (isGrossToNet ? 'Gross' : 'Net')
        : (isGrossToNet ? 'Net' : 'Gross');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Riverpod in action
    final calculationMode = ref.watch(calculationModeProvider);
    final inputPriceLabel = _getPriceLabel(calculationMode, isInput: true);
    final calculatedPriceLabel =
        _getPriceLabel(calculationMode, isInput: false);
    final calculatedPrice = ref.watch(calculatedPriceProvider);

    final textTheme = Theme.of(context).textTheme;

    return SectionCard(
      title: 'Calculation',
      leadingWidget: SegmentedButton<CalculationMode>(
        segments: [
          ButtonSegment(
              value: CalculationMode.netToGross,
              label: Text(
                'Net → Gross',
                softWrap: false,
                style: textTheme.labelMedium,
              )),
          ButtonSegment(
              value: CalculationMode.grossToNet,
              label: Text(
                'Gross → Net',
                softWrap: false,
                style: textTheme.labelMedium,
              )),
        ],
        selected: {calculationMode},
        onSelectionChanged: (Set<CalculationMode> newSelection) {
          final selected = newSelection.first;
          if (selected != calculationMode) {
            ref.read(calculationModeProvider.notifier).setMode(selected);
          }
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            inputFormatters: [CurrencyInputFormatter()],
            decoration: InputDecoration(
                labelText: '$inputPriceLabel Price',
                prefix: const Text(
                  'Rp. ',
                )),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final numeric = value.replaceAll('.', '');
              final price = double.tryParse(numeric) ?? 0.0;
              ref.read(basePriceProvider.notifier).setBasePrice(price);
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '$calculatedPriceLabel Price: ${formatCurrency(calculatedPrice < 0 ? 0 : calculatedPrice)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copy to clipboard',
                onPressed: () {
                  final rounded = calculatedPrice.toStringAsFixed(0);
                  Clipboard.setData(ClipboardData(text: rounded));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Copied: $rounded')),
                  );
                },
              ),
            ],
          ),
          // const SizedBox(height: AppSizes.paddingSmall),
          // Text(
          //   'Applicable Fees',
          //   style: textTheme.titleSmall,
          // ),
          const SizedBox(height: AppSizes.paddingSmall),
          const ApplicableFeesSelector(),
        ],
      ),
    );
  }
}
