import 'package:mp_calculator/models/fee.dart';

class CategoryNode {
  final String name;
  final Map<String, CategoryNode> children;
  final List<Fee>? fees; // only present at leaf

  CategoryNode({
    required this.name,
    required this.children,
    this.fees,
  });

  factory CategoryNode.fromJson(String name, Map<String, dynamic> json) {
    // Parse fee object if exists
    final feesJson = json['fees'];
    final fees = feesJson != null
        ? Fee.fromJson(
            (feesJson as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                value as Map<String, dynamic>,
              ),
            ),
          )
        : null;

    // Parse children (everything except "fees")
    final children = <String, CategoryNode>{};

    json.forEach((key, value) {
      if (key == 'fees') return;
      if (value is Map<String, dynamic>) {
        // safe recursive call
        children[key] = CategoryNode.fromJson(key, value);
      }
    });

    return CategoryNode(
      name: name,
      children: children,
      fees: fees,
    );
  }
}
