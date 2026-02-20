import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/controllers/update_date_provider.dart';
import 'package:mp_calculator/utils/formatter.dart';

class FooterSection extends ConsumerWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateDataAsync = ref.watch(updateDataProvider);

    return Center(
        child: updateDataAsync.when(
            data: (updates) => Builder(builder: (context) {
                  if (updates.isEmpty) return const Text('No update data recorded.');

                  final lastestUpdate = updates.last;
                  debugPrint('debug latestUpdate ${lastestUpdate.date}');
                  return Text(
                      'Last Update: ${dateTimeToString(lastestUpdate.date)}');
                }),
            error: (error, stackTrace) => const Text(''),
            loading: () => const CircularProgressIndicator()));
  }
}
