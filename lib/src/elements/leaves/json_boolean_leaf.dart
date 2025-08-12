import 'package:json_builder_pro/src/constants/json_element_type.dart';
import 'package:json_builder_pro/src/core/json_leaf.dart';

/// A leaf that represents an boolean.
class JSONBooleanLeaf extends JSONLeaf {
  JSONBooleanLeaf({
    required super.id,
    required super.parent,
    required super.child,
  });

  @override
  String get getType => JEType.booleanLeaf.name;
}
