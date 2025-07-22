import '../constants/json_element_types.dart';
import '../core/json_element.dart';
import 'data_structures/json_array.dart';
import 'data_structures/json_object.dart';

/// Represents a complete JSON document, with its root being either an object or an array.
class JSONTree {
  final JETypes initialType;
  late JSONElement _root;

  // Root element does not have a parent, so its _parentRemover remains null.
  JSONElement get root => _root;

  JSONTree({required this.initialType}) {
    if (initialType == JETypes.object) {
      _root = JSONObject({}); // No parentRemover for the root
    } else if (initialType == JETypes.array) {
      _root = JSONArray([]); // No parentRemover for the root
    } else {
      throw ArgumentError(
        'Initial JSONTree type must be an object or an array.',
      );
    }
  }

  /// Converts the entire JSON tree to its JSON string representation.
  String toJsonString() {
    return _root.toJsonString();
  }

  // Example of a method to set a new root for the tree (less common but possible)
  void setRoot(JSONElement newRoot) {
    // If the old root was an array/object, clear its children's parent removers if they still point to it.
    // This is complex for a generic JSONElement and often handled by recreating the tree.
    // For simplicity here, we assume if you're setting a new root, the old one is discarded.
    // The new root itself should not have a parentRemover.
    newRoot.setParentRemover(
      null,
    ); // Ensure new root doesn't have an old parent link
    _root = newRoot;
  }
}
