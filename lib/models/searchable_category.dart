import 'package:mp_calculator/models/fee.dart';

class SearchableCategory {
  final String label;
  final String catLv1;
  final String? catLv2;
  final String? catLv3;
  final List<Fee> fees;

  SearchableCategory({
    required this.label,
    required this.catLv1,
    this.catLv2,
    this.catLv3,
    required this.fees,
  });

  factory SearchableCategory.fromJson(Map<String, dynamic> json) {
    final feesJson = json['fees'];
    final fees = Fee.fromJson(
      (feesJson as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          value as Map<String, dynamic>,
        ),
      ),
    );

    return SearchableCategory(
      label: json['label'],
      catLv1: json['cat_lv1'],
      catLv2: json['cat_lv2'],
      catLv3: json['cat_lv3'],
      fees: fees,
    );
  }

  Map<String, dynamic> toJson() => {
        "label": label,
        "cat_lv1": catLv1,
        "cat_lv2": catLv2,
        "cat_lv3": catLv3,
        "fees": fees.toJson(),
      };
}
