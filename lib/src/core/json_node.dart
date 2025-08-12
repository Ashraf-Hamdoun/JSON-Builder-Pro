import '../constants/json_element_type.dart';
import 'json_element.dart';
import 'json_leaf.dart';

/// The base class for all JSON nodes.
///
/// Nodes are the building blocks of the JSON tree and can have children.
abstract class JSONNode extends JSONElement {
  /// A callback function that is called when the node is updated.
  final Function(String childId, String childValue) updateParent;

  JSONNode({
    required super.id,
    required super.parent,
    required this.updateParent,
  });

  @override
  String get getType => JEType.node.name;

  @override
  String computeJSONString();

  /// Called by children to notify the node of an update.
  void onUpdateChildren(String childID, String childValue) {
    setDirty();
    updateParent(id, toJsonString());
  }

  /// Marks the node as active and notifies the parent of the change.
  void enterNode() {
    setDirty();
    updateParent(id, toJsonString());
  }

  /// Marks the node as inactive and notifies the parent of the change.
  void leaveNode() {
    setDirty();
    updateParent(id, toJsonString());
  }

  void clear();

  JSONNode? deleteActiveChild();
}
