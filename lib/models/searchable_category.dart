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

  factory SearchableCategory.fromJson(Map<String, dynamic> json) =>
      SearchableCategory(
        label: json['label'],
        catLv1: json['cat_lv1'],
        catLv2: json['cat_lv2'],
        catLv3: json['cat_lv3'],
        fees: Fee.fromJson(json['fees'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "cat_lv1": catLv1,
        "cat_lv2": catLv2,
        "cat_lv3": catLv3,
        "fees": fees.toJson(),
      };
}
