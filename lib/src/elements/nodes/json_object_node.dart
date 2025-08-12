import 'package:json_builder_pro/src/constants/json_element_type.dart';
import 'package:json_builder_pro/src/core/json_element.dart';
import 'package:json_builder_pro/src/core/json_node.dart';

/// A node that represents an object.
class JSONObjectNode extends JSONNode {
  final Map<String, JSONElement> _members = {};

  JSONObjectNode({
    required super.id,
    required super.parent,
    required super.updateParent,
  });

  /// Returns an unmodifiable map of the node's members.
  Map<String, JSONElement> get members => Map.unmodifiable(_members);

  @override
  String get getType => JEType.objectNode.name;

  @override
  String computeJSONString() {
    if (_members.isEmpty) {
      return "{}";
    } else {
      final List<String> parts = [];
      _members.forEach((key, value) {
        parts.add('"$key":${value.toJsonString()}');
      });
      return '{${parts.join(',')}}';
    }
  }

  /// Sets a key-value pair in the object.
  void set(String key, JSONElement value) {
    _members[key] = value;
    setDirty();
    updateParent(id, toJsonString());
  }

  /// Gets a value by key from the object.
  JSONElement? get(String key) {
    return _members[key];
  }

  @override
  void clear() {
    _members.clear();
    setDirty();
    updateParent(id, toJsonString());
  }

  @override
  JSONNode? deleteActiveChild() {
    // For objects, deleting means removing the last added key-value pair.
    // This is a simplification. A more robust solution would involve a cursor
    // or explicit key deletion.
    if (_members.isNotEmpty) {
      final lastKey = _members.keys.last;
      _members.remove(lastKey);
      setDirty();
      updateParent(id, toJsonString());
      return this;
    } else {
      if (parent != null) {
        return parent!.deleteActiveChild();
      } else {
        return null;
      }
    }
  }
}
