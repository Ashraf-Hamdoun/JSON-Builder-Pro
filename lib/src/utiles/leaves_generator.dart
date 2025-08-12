import 'package:json_builder_pro/src/constants/json_element_type.dart';
import 'package:json_builder_pro/src/core/json_leaf.dart';
import 'package:json_builder_pro/src/core/json_node.dart';
import 'package:json_builder_pro/src/elements/leaves/json_number_leaf.dart';
import 'package:json_builder_pro/src/elements/leaves/json_boolean_leaf.dart';
import 'package:json_builder_pro/src/elements/leaves/json_string_leaf.dart';
import 'package:json_builder_pro/src/elements/leaves/json_null_leaf.dart';
import 'package:json_builder_pro/src/utiles/ids_generator.dart';

/// A factory for creating JSON leaf elements.
///
/// This function is responsible for creating the correct type of leaf based on
/// the provided [JEType].
JSONLeaf leavesGenerator({
  required JSONNode parent,
  required JEType type,
  required String content,
}) {
  JSONLeaf leaf;
  switch (type) {
    case JEType.numberLeaf:
      leaf = JSONNumberLeaf(
        child: content,
        id: idsGenerator(JEType.numberLeaf, parent.id),
        parent: parent,
      );
      break;

    case JEType.stringLeaf:
      leaf = JSONStringLeaf(
        child: content,
        id: idsGenerator(JEType.stringLeaf, parent.id),
        parent: parent,
      );
      break;

    case JEType.booleanLeaf:
      leaf = JSONBooleanLeaf(
        child: content,
        id: idsGenerator(JEType.booleanLeaf, parent.id),
        parent: parent,
      );
      break;

    case JEType.nullLeaf:
      leaf = JSONNullLeaf(
        id: idsGenerator(JEType.nullLeaf, parent.id),
        parent: parent,
      );
      break;

    default:
      throw Exception('Unknown JSONLeaf type: $type');
  }
  return leaf;
}
