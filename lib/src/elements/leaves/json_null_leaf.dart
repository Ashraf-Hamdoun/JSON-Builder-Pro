import 'package:json_builder_pro/src/constants/json_element_type.dart';
import 'package:json_builder_pro/src/core/json_leaf.dart';

/// A leaf that represents a JSON null value.
class JSONNullLeaf extends JSONLeaf {
  JSONNullLeaf({
    required super.id,
    required super.parent,
  }) : super(child: 'null');

  @override
  String get getType => JEType.nullLeaf.name;

  @override
  String computeJSONString() {
    return 'null';
  }
}
