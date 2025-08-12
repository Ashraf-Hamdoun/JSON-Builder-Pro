import 'dart:convert';
import 'package:json_builder_pro/src/constants/json_element_type.dart';
import 'package:json_builder_pro/src/core/json_element.dart';
import 'package:json_builder_pro/src/core/json_node.dart';
import 'package:json_builder_pro/src/elements/json_trunk.dart';
import 'package:json_builder_pro/src/elements/nodes/json_array_node.dart';
import 'package:json_builder_pro/src/elements/nodes/json_object_node.dart';
import 'package:json_builder_pro/src/utiles/leaves_generator.dart';
import 'package:json_builder_pro/src/utiles/nodes_generator.dart';

/// The main class for building and manipulating mathematical expressions.
///
/// `JSONTree` provides a user-friendly interface for constructing complex
/// json expressions programmatically. It abstracts the underlying tree structure,
/// managing the cursor and active node automatically.
///
/// Use this class to add, remove, and navigate through elements of an expression.
class JSONTree {
  final JSONTrunk _trunk = JSONTrunk(id: 't-0');
  late JSONNode _activeParent;

  JSONNode get activeParent => _activeParent;

  /// Creates a new, empty math expression tree.
  JSONTree() {
    _trunk.clear();
    _activeParent = _trunk;
    _trunk.enterNode();
  }

  factory JSONTree.fromJson(String jsonString) {
    final JSONTree tree = JSONTree();
    final decodedJson = json.decode(jsonString);

    if (decodedJson is Map<String, dynamic>) {
      final objectNode = nodesGenerator(
          parent: tree._trunk, type: JEType.objectNode, content: '');
      tree._trunk.addChildNode(objectNode);
      tree._buildFromJson(decodedJson, objectNode);
    } else if (decodedJson is List<dynamic>) {
      final arrayNode = nodesGenerator(
          parent: tree._trunk, type: JEType.arrayNode, content: '');
      tree._trunk.addChildNode(arrayNode);
      tree._buildFromJson(decodedJson, arrayNode);
    } else {
      throw Exception('Unsupported JSON type for root element.');
    }

    return tree;
  }

  void _buildFromJson(dynamic jsonValue, JSONNode parent) {
    if (jsonValue is Map<String, dynamic>) {
      for (var entry in jsonValue.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is Map<String, dynamic>) {
          final objectNode = nodesGenerator(
              parent: parent, type: JEType.objectNode, content: '');
          (parent as JSONObjectNode).set(key, objectNode);
          _buildFromJson(value, objectNode);
        } else if (value is List<dynamic>) {
          final arrayNode = nodesGenerator(
              parent: parent, type: JEType.arrayNode, content: '');
          (parent as JSONObjectNode).set(key, arrayNode);
          _buildFromJson(value, arrayNode);
        } else if (value is String) {
          final stringLeaf = leavesGenerator(
              parent: parent, type: JEType.stringLeaf, content: value);
          (parent as JSONObjectNode).set(key, stringLeaf);
        } else if (value is num) {
          final numberLeaf = leavesGenerator(
              parent: parent,
              type: JEType.numberLeaf,
              content: value.toString());
          (parent as JSONObjectNode).set(key, numberLeaf);
        } else if (value is bool) {
          final booleanLeaf = leavesGenerator(
              parent: parent,
              type: JEType.booleanLeaf,
              content: value.toString());
          (parent as JSONObjectNode).set(key, booleanLeaf);
        } else if (value == null) {
          final nullLeaf = leavesGenerator(
              parent: parent, type: JEType.nullLeaf, content: '');
          (parent as JSONObjectNode).set(key, nullLeaf);
        } else {
          throw Exception('Unsupported JSON value type: ${value.runtimeType}');
        }
      }
    } else if (jsonValue is List<dynamic>) {
      for (var item in jsonValue) {
        if (item is Map<String, dynamic>) {
          final objectNode = nodesGenerator(
              parent: parent, type: JEType.objectNode, content: '');
          (parent as JSONArrayNode).addChildNode(objectNode);
          _buildFromJson(item, objectNode);
        } else if (item is List<dynamic>) {
          final arrayNode = nodesGenerator(
              parent: parent, type: JEType.arrayNode, content: '');
          (parent as JSONArrayNode).addChildNode(arrayNode);
          _buildFromJson(item, arrayNode);
        } else if (item is String) {
          final stringLeaf = leavesGenerator(
              parent: parent, type: JEType.stringLeaf, content: item);
          (parent as JSONArrayNode).addChildLeaf(stringLeaf);
        } else if (item is num) {
          final numberLeaf = leavesGenerator(
              parent: parent,
              type: JEType.numberLeaf,
              content: item.toString());
          (parent as JSONArrayNode).addChildLeaf(numberLeaf);
        } else if (item is bool) {
          final booleanLeaf = leavesGenerator(
              parent: parent,
              type: JEType.booleanLeaf,
              content: item.toString());
          (parent as JSONArrayNode).addChildLeaf(booleanLeaf);
        } else if (item == null) {
          final nullLeaf = leavesGenerator(
              parent: parent, type: JEType.nullLeaf, content: '');
          (parent as JSONArrayNode).addChildLeaf(nullLeaf);
        } else {
          throw Exception('Unsupported JSON value type: ${item.runtimeType}');
        }
      }
    }
  }

  /// Returns the full JSON string representation of the expression.
  ///
  /// This string is suitable for rendering with any JSON engine.
  /// The '|' character indicates the current cursor position.
  String toJsonString() => _trunk.toJsonString();

  /// Adds a leaf element (e.g., number, boolean) to the expression at the
  /// current position.
  ///
  /// [type] specifies the type of leaf, and [content] is its value.
  void addChildLeaf(JEType type, String content) {
    if (_activeParent is JSONArrayNode || _activeParent is JSONTrunk) {
      final leaf = leavesGenerator(
        parent: _activeParent,
        type: type,
        content: content,
      );
      (_activeParent as dynamic).addChildLeaf(leaf);
    } else {
      throw Exception('Cannot add a leaf directly to a non-array/trunk node.');
    }
  }

  /// Adds a structural node (e.g., array, object) to the expression at the
  /// current position.
  void addChildNode(JEType type, {String content = ''}) {
    if (_activeParent is JSONArrayNode || _activeParent is JSONTrunk) {
      final node = nodesGenerator(
        parent: _activeParent,
        type: type,
        content: content,
      );

      (_activeParent as dynamic).addChildNode(node);
      _activeParent.leaveNode();
      _activeParent = node;
      _activeParent.enterNode();
    } else {
      throw Exception('Cannot add a node directly to a non-array/trunk node.');
    }
  }

  /// Adds a key-value pair to the current object node.
  /// Throws an exception if the active parent is not an object node.
  void addKeyValuePair(String key, JSONElement value) {
    if (_activeParent is JSONObjectNode) {
      (_activeParent as JSONObjectNode).set(key, value);
    } else {
      throw Exception('Cannot add key-value pair to a non-object node.');
    }
  }

  /// Selects a child node by its key (for objects) or index (for arrays).
  /// Sets the selected node as the new active parent.
  void select(dynamic identifier) {
    if (identifier is String && _activeParent is JSONObjectNode) {
      final node = (_activeParent as JSONObjectNode).get(identifier);
      if (node is JSONNode) {
        _activeParent.leaveNode();
        _activeParent = node;
        _activeParent.enterNode();
      } else {
        throw Exception('Selected element is not a node.');
      }
    } else if (identifier is int && _activeParent is JSONArrayNode) {
      final node = (_activeParent as JSONArrayNode).children[identifier];
      if (node is JSONNode) {
        _activeParent.leaveNode();
        _activeParent = node;
        _activeParent.enterNode();
      } else {
        throw Exception('Selected element is not a node.');
      }
    } else {
      throw Exception('Invalid identifier or active parent type.');
    }
  }

  /// Exits the current node and returns to its parent.
  void up() {
    if (_activeParent.parent != null) {
      _activeParent.leaveNode();
      _activeParent = _activeParent.parent as JSONNode;
      _activeParent.enterNode();
    } else {
      throw Exception('Cannot go up from root node.');
    }
  }

  /// Clears the entire expression tree, resetting it to an empty state.
  bool clear() {
    final oldJson = toJsonString();
    _activeParent.leaveNode();
    _trunk.clear();
    _activeParent = _trunk;
    _activeParent.enterNode();
    return oldJson != toJsonString();
  }

  /// Deletes the element immediately to the left of the cursor.
  ///
  /// If the cursor is at the beginning of a node, this may delete the node
  /// itself if it's empty, or move the cursor out of the node.
  bool delete() {
    final oldJson = toJsonString();
    final node = _activeParent.deleteActiveChild();
    if (node != null) {
      // The active parent might change after a deletion.
      _activeParent.leaveNode();
      _activeParent = node;
      _activeParent.enterNode();
    }
    return oldJson != toJsonString();
  }
}
