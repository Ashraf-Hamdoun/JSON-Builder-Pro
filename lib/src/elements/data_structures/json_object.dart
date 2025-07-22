import '../../constants/json_element_types.dart';
import '../../core/json_element.dart';
import '../../core/json_element_builder.dart';

/// Represents a JSON object.
class JSONObject extends JSONElement {
  final Map<String, JSONElement> _members;

  // Constructor now takes an optional parentRemover and passes it up.
  // It also ensures initial members are aware of THIS JSONObject as their parent.
  JSONObject([
    Map<String, JSONElement>? initialMembers,
    ParentRemover? parentRemover,
  ])  : _members = {}, // Initialize _members first
        super(parentRemover) {
    if (initialMembers != null) {
      initialMembers.forEach((key, value) {
        set(key, value); // Use the set method to set parent links
      });
    }
  }

  /// Creates a [JSONObject] from a raw Dart [Map].
  /// This is a factory constructor to allow for recursive creation of JSON elements.
  factory JSONObject.fromJson(Map<String, dynamic> jsonMap) {
    final object = JSONObject();
    jsonMap.forEach((key, value) {
      object.set(key, buildJsonElement(value));
    });
    return object;
  }

  Map<String, JSONElement> get members => _members;

  @override
  String get getType => JETypes.object.name;

  @override
  String toJson() {
    final buffer = StringBuffer('{');
    int i = 0;
    _members.forEach((key, value) {
      buffer.write('"${key.replaceAll('"', '"')}"');
      buffer.write(':');
      buffer.write(value.toJson());
      if (i < _members.length - 1) {
        buffer.write(',');
      }
      i++;
    });
    buffer.write('}');
    return buffer.toString();
  }

  /// Adds a new key-value pair to the JSON object, or updates the value if the key already exists.
  /// The [key] must be a non-null string. The [value] must be a [JSONElement].
  /// Sets the element's parent remover callback.
  void set(String key, JSONElement value) {
    // If overwriting an existing value, clear its parent remover first.
    final existingValue = _members[key];
    existingValue?.setParentRemover(null);

    _members[key] = value;
    // Set the new value's parent remover to point back to THIS object.
    value.setParentRemover(_removeMember);
  }

  /// Retrieves the [JSONElement] associated with the given [key].
  /// Returns `null` if the key is not found.
  JSONElement? get(String key) {
    return _members[key];
  }

  /// Removes the key-value pair associated with the given [key] from the JSON object.
  /// Returns the removed [JSONElement] if the key was found, otherwise returns `null`.
  /// If removed, clears the removed element's parent remover.
  JSONElement? remove(String key) {
    final removedElement = _members.remove(key);
    if (removedElement != null) {
      removedElement.setParentRemover(
        null,
      ); // Clear parent link for the removed child
    }
    return removedElement;
  }

  /// Checks if the JSON object contains the given [key].
  bool containsKey(String key) {
    return _members.containsKey(key);
  }

  /// Removes all key-value pairs from the JSON object and clears their parent removers.
  void clear() {
    for (var value in _members.values) {
      value.setParentRemover(null);
    }
    _members.clear();
  }

  /// The internal callback function for children (values) to remove themselves from THIS object.
  /// Note: Children of an object don't know their key, so this is trickier.
  /// We need to iterate to find the key associated with the child.
  bool _removeMember(JSONElement childToRemove) {
    String? keyToRemove;
    _members.forEach((key, value) {
      if (value == childToRemove) {
        keyToRemove = key;
        return; // Break iteration
      }
    });

    if (keyToRemove != null) {
      remove(keyToRemove!); // Use the public remove method
      return true;
    }
    return false;
  }

  int get length => _members.length;
  bool get isEmpty => _members.isEmpty;
  bool get isNotEmpty => _members.isNotEmpty;

  JSONElement? operator [](String key) {
    return _members[key];
  }

  void operator []=(String key, JSONElement value) {
    set(key, value); // Use the set method to handle parent link updates
  }
}
