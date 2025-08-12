import 'dart:convert';
import 'package:json_builder_pro/src/constants/json_element_type.dart';
import 'package:json_builder_pro/src/core/json_leaf.dart';

/// A leaf that represents a plain text string within a mathematical expression.
/// It wraps the text in a JSON `"..."`.
class JSONStringLeaf extends JSONLeaf {
  JSONStringLeaf({
    required super.id,
    required super.parent,
    required super.child,
  });

  @override
  String get getType => JEType.stringLeaf.name;

  @override
  String computeJSONString() {
    // The child string represents the text content.
    // We use json.encode to properly escape the string for JSON.
    return json.encode(child);
  }
}
