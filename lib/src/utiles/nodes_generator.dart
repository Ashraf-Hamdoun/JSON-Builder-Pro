import 'package:json_builder_pro/src/constants/json_element_type.dart';
import 'package:json_builder_pro/src/core/json_node.dart';
import 'package:json_builder_pro/src/elements/nodes/json_object_node.dart';
import 'package:json_builder_pro/src/utiles/ids_generator.dart';
import 'package:json_builder_pro/src/elements/nodes/json_array_node.dart';

/// A factory for creating LaTeX node elements.
///
/// This function is responsible for creating the correct type of node based on
/// the provided [JEType].
JSONNode nodesGenerator({
  required JSONNode parent,
  required JEType type,
  required String content,
}) {
  JSONNode node;
  switch (type) {
    case JEType.arrayNode:
      node = JSONArrayNode(
        id: idsGenerator(type, parent.id),
        parent: parent,
        updateParent: (childId, childValue) =>
            parent.onUpdateChildren(childId, childValue),
      );
      break;

    case JEType.objectNode:
      node = JSONObjectNode(
        id: idsGenerator(type, parent.id),
        parent: parent,
        updateParent: (childId, childValue) =>
            parent.onUpdateChildren(childId, childValue),
      );
      break;

    default:
      throw Exception('Unknown JSONNode type: $type');
  }
  return node;
}
