import 'package:json_builder_pro/src/core/json_node.dart';
import '../constants/json_element_type.dart';
import 'json_element.dart';

/// The base class for all JSON leaf elements.
///
/// Leaf elements are the terminal nodes of the JSON tree and hold the actual
/// content, such as string, number and boolean. They do not have children.
///
/// The [child] property holds the string value of the leaf, which is used to
/// generate the JSON string.
abstract class JSONLeaf extends JSONElement {
  /// The content of the leaf, such as a number or an operator.
  final String child;

  JSONLeaf({required super.id, required super.parent, required this.child});

  /// Creates a placeholder leaf, which is used to represent an empty space in the tree.
  factory JSONLeaf.placeHolder({required JSONNode parent}) {
    return _JSONPlaceholderLeaf(
      id: "${parent.id}-pholder",
      parent: parent,
      child: '',
    );
  }

  @override
  String get getType => JEType.leaf.name;

  /// Returns the LaTeX string for the leaf, which is just its content.
  @override
  String computeJSONString() {
    return child;
  }
}

/// A concrete implementation of a placeholder leaf.
class _JSONPlaceholderLeaf extends JSONLeaf {
  _JSONPlaceholderLeaf({
    required super.id,
    required super.parent,
    required super.child,
  });

  @override
  String get getType => JEType.placeHolderLeaf.name;
}
