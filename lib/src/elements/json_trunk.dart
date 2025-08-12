import 'package:json_builder_pro/src/constants/json_element_type.dart';
import 'package:json_builder_pro/src/core/json_element.dart';
import 'package:json_builder_pro/src/core/json_leaf.dart';
import 'package:json_builder_pro/src/core/json_node.dart';

/// The root of the JSON tree.
///
/// This class represents the main container for the JSON expression and is
/// responsible for initiating the JSON string generation.
class JSONTrunk extends JSONNode {
  final List<JSONElement> _children = [];
  final List<String> _childrenIDs = [];

  /// The position of the cursor, used for inserting new children.
  int position = 0;

  JSONTrunk({
    required super.id,
    super.parent,
    super.updateParent = _defaultUpdateParent,
  }) {
    JSONLeaf placeHolderLeaf = JSONLeaf.placeHolder(parent: this);
    _children.add(placeHolderLeaf);
    _childrenIDs.add(placeHolderLeaf.id);
  }

  /// Returns an unmodifiable list of the node's children.
  List<JSONElement> get children => List.unmodifiable(_children);

  /// Returns an unmodifiable list of the IDs of the node's children.
  List<String> get childrenIDs => List.unmodifiable(_childrenIDs);

  @override
  String get getType => JEType.trunk.name;

  @override
  String computeJSONString() {
    if (_children.length == 1) {
      return "";
    } else {
      // If only one actual child (plus placeholder), return its string directly.
      return _children[1].toJsonString();
    }
  }

  /// Adds a child to the node at the current position.
  void addChildLeaf(JSONLeaf leaf) {
    if (_children.length > 1) {
      throw Exception('JSONTrunk can only have one root element.');
    }
    _children.insert(position + 1, leaf);
    _childrenIDs.insert(position + 1, leaf.id);

    position += 1;
    setDirty();
    updateParent(id, toJsonString());
  }

  void addChildNode(JSONNode node) {
    if (_children.length > 1) {
      throw Exception('JSONTrunk can only have one root element.');
    }
    _children.insert(position + 1, node);
    _childrenIDs.insert(position + 1, node.id);

    position += 1;
    setDirty();
    updateParent(id, toJsonString());
  }

  @override
  void clear() {
    position = 0;
    _children.clear();
    _childrenIDs.clear();

    JSONLeaf placeHolderLeaf = JSONLeaf.placeHolder(parent: this);
    _children.add(placeHolderLeaf);
    _childrenIDs.add(placeHolderLeaf.id);
  }

  @override
  JSONNode? deleteActiveChild() {
    if (position > 0 && children.length > 1) {
      JSONElement activeChild = children[position];
      // Delete the active child
      _children.remove(activeChild);
      _childrenIDs.remove(activeChild.id);
      position--;

      setDirty();
      updateParent(id, toJsonString());
      return this;
    } else {
      if (children.length > 1) {
        // At the beginning of the node and other children are after you.
        return null;
      } else {
        // No active child to delete.
        if (parent != null) {
          // Parent is not null, i will ask parent to delete me.
          return parent!.deleteActiveChild();
        } else {
          // Parent is null, i can not delete myself.
          return null;
        }
      }
    }
  }

  /// The default callback for child updates.
  static void _defaultUpdateParent(String childId, String childValue) {}
}
