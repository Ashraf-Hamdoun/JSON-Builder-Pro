import 'package:json_builder_pro/src/constants/json_element_type.dart';

int idsCounter = 0;

/// Generates a unique ID for a JSON element.
///
/// The ID is based on the element's type and its parent's ID to ensure that it
/// is unique within the tree.
String idsGenerator(JEType type, String parentId) {
  String idPrefix;

  switch (type) {
    case JEType.trunk:
      idPrefix = "t";
      break;
    case JEType.node:
      idPrefix = "$parentId-n-norm";
      break;
    case JEType.arrayNode:
      idPrefix = "$parentId-n-arr";
      break;
    case JEType.objectNode:
      idPrefix = "$parentId-n-obj";
      break;
    case JEType.numberLeaf:
      idPrefix = "$parentId-l-num";
      break;
    case JEType.stringLeaf:
      idPrefix = "$parentId-l-str";
      break;
    case JEType.booleanLeaf:
      idPrefix = "$parentId-l-bool";
      break;

    default:
      idPrefix = "$parentId-unk";
  }

  idsCounter++;
  return "$idPrefix-$idsCounter";
}
