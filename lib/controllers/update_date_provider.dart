import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mp_calculator/models/update_model.dart';
import 'package:mp_calculator/services/json_service.dart';
import 'package:collection/collection.dart';

final updateDataProvider = FutureProvider<List<UpdateModel>>((ref) async {
  final updates = await loadUpdates();
  return updates.sortedBy((update) => update.date);
});
