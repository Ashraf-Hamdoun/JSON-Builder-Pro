import '../../constants/json_element_types.dart';
import '../../core/json_element.dart';
import '../../core/json_element_builder.dart';

/// Represents a JSON array.
class JSONArray extends JSONElement {
  final List<JSONElement> _elements;

  // Constructor now takes an optional parentRemover and passes it up.
  // It also ensures initial elements are aware of THIS JSONArray as their parent.
  JSONArray([
    List<JSONElement>? initialElements,
    ParentRemover? parentRemover,
  ])  : _elements = [], // Initialize _elements first
        super(parentRemover) {
    if (initialElements != null) {
      for (var element in initialElements) {
        add(element); // Use the add method to set parent links
      }
    }
  }

  /// Creates a [JSONArray] from a raw Dart [List].
  /// This is a factory constructor to allow for recursive creation of JSON elements.
  factory JSONArray.fromJson(List<dynamic> jsonList) {
    final array = JSONArray();
    for (var element in jsonList) {
      array.add(buildJsonElement(element));
    }
    return array;
  }

  List<JSONElement> get elements => _elements;

  @override
  String get getType => JETypes.array.name;

  @override
  String toJson() {
    final buffer = StringBuffer('[');
    for (int i = 0; i < _elements.length; i++) {
      buffer.write(_elements[i].toJson());
      if (i < _elements.length - 1) {
        buffer.write(',');
      }
    }
    buffer.write(']');
    return buffer.toString();
  }

  /// Adds a new [element] to the end of the JSON array.
  /// Sets the element's parent remover callback.
  void add(JSONElement element) {
    _elements.add(element);
    // When a child is added, give it the callback to remove itself from THIS array.
    element.setParentRemover(_removeChild);
  }

  /// Adds all [newElements] from an iterable to the end of the JSON array.
  void addAll(Iterable<JSONElement> newElements) {
    for (var element in newElements) {
      add(element); // Use the add method to ensure parent links are set
    }
  }

  /// Inserts a [newElement] at the specified [index] in the JSON array.
  /// Throws a [RangeError] if [index] is out of bounds.
  /// Sets the element's parent remover callback.
  void insert(int index, JSONElement newElement) {
    _elements.insert(index, newElement);
    newElement.setParentRemover(_removeChild);
  }

  /// Removes the first occurrence of [element] from the JSON array.
  /// Returns `true` if [element] was found and removed, `false` otherwise.
  /// If removed, clears the removed element's parent remover.
  bool remove(JSONElement element) {
    final wasRemoved = _elements.remove(element);
    if (wasRemoved) {
      element.setParentRemover(null); // Clear parent link for the removed child
    }
    return wasRemoved;
  }

  /// Removes the element at the specified [index] from the JSON array.
  /// Returns the removed element.
  /// Throws a [RangeError] if [index] is out of bounds.
  /// If removed, clears the removed element's parent remover.
  JSONElement removeAt(int index) {
    final removedElement = _elements.removeAt(index);
    removedElement.setParentRemover(
      null,
    ); // Clear parent link for the removed child
    return removedElement;
  }

  /// Removes all elements from the array and clears their parent removers.
  void clear() {
    for (var element in _elements) {
      element.setParentRemover(null);
    }
    _elements.clear();
  }

  /// The internal callback function for children to remove themselves from THIS array.
  bool _removeChild(JSONElement childToRemove) {
    return remove(childToRemove); // Use the public remove method
  }

  int get length => _elements.length;
  bool get isEmpty => _elements.isEmpty;
  bool get isNotEmpty => _elements.isNotEmpty;

  JSONElement operator [](int index) {
    return _elements[index];
  }

  void operator []=(int index, JSONElement value) {
    // If replacing an existing element, clear its parent link.
    _elements[index].setParentRemover(null);
    _elements[index] = value;
    // Set the new element's parent link.
    value.setParentRemover(_removeChild);
  }
}
