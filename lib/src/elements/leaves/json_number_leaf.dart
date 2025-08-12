import 'package:json_builder_pro/src/constants/json_element_type.dart';
import 'package:json_builder_pro/src/core/json_leaf.dart';

/// A leaf that represents a number.
class JSONNumberLeaf extends JSONLeaf {
  final num numberValue;

  JSONNumberLeaf({
    required super.id,
    required super.parent,
    required super.child,
  })  : numberValue = num.parse(child);

  @override
  String get getType => JEType.numberLeaf.name;

  @override
  String computeJSONString() {
    if (numberValue == numberValue.toInt()) {
      return numberValue.toInt().toString();
    } else {
      return numberValue.toString();
    }
  }
}
