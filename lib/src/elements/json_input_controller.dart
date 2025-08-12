import 'package:json_builder_pro/json_builder_pro.dart';
import 'package:json_builder_pro/src/utiles/leaves_generator.dart';
import 'package:json_builder_pro/src/utiles/nodes_generator.dart';

/// A controller to simplify adding common mathematical inputs to a [JSONTree].
///
/// This class provides an intuitive, "Builder" like interface for building
/// expressions, abstracting away the underlying `JEType` and content details.
/// It is ideal for creating UIs like on-screen json creators.
///
/// It also includes a listener pattern to notify consumers of changes to the
/// expression tree.
class JSONInputController {
  final JSONTree _jsonTree;
  final List<void Function()> _listeners = [];

  /// Creates a controller that modifies the given [jsonTree].
  JSONInputController(this._jsonTree);

  /// Adds a [listener] that will be called whenever the expression changes.
  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  /// Removes a previously added [listener].
  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  /// Notifies all registered listeners of a change.
  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  /// Adds a number leaf to the expression.
  void addNumber(double number) {
    _jsonTree.addChildLeaf(JEType.numberLeaf, number.toString());
    _notifyListeners();
  }

  /// Adds a string leaf to the expression.
  void addString(String string) {
    _jsonTree.addChildLeaf(JEType.stringLeaf, string);
    _notifyListeners();
  }

  /// Adds a boolean leaf to the expression.
  void addBoolean(bool boolean) {
    _jsonTree.addChildLeaf(JEType.booleanLeaf, boolean.toString());
    _notifyListeners();
  }

  /// Adds an array node to the expression.
  void addArray() {
    _jsonTree.addChildNode(JEType.arrayNode);
    _notifyListeners();
  }

  /// Adds an object node to the expression.
  void addObject() {
    _jsonTree.addChildNode(JEType.objectNode);
    _notifyListeners();
  }

  /// Adds a string property to the current object node.
  void addStringProperty(String key, String value) {
    final leaf = leavesGenerator(
        parent: _jsonTree.activeParent, type: JEType.stringLeaf, content: value);
    _jsonTree.addKeyValuePair(key, leaf);
    _notifyListeners();
  }

  /// Adds a number property to the current object node.
  void addNumberProperty(String key, double value) {
    final leaf = leavesGenerator(
        parent: _jsonTree.activeParent, type: JEType.numberLeaf, content: value.toString());
    _jsonTree.addKeyValuePair(key, leaf);
    _notifyListeners();
  }

  /// Adds a boolean property to the current object node.
  void addBooleanProperty(String key, bool value) {
    final leaf = leavesGenerator(
        parent: _jsonTree.activeParent, type: JEType.booleanLeaf, content: value.toString());
    _jsonTree.addKeyValuePair(key, leaf);
    _notifyListeners();
  }

  /// Adds an array property to the current object node.
  void addArrayProperty(String key) {
    final node = nodesGenerator(
        parent: _jsonTree.activeParent, type: JEType.arrayNode, content: '');
    _jsonTree.addKeyValuePair(key, node);
    _notifyListeners();
  }

  /// Adds an object property to the current object node.
  void addObjectProperty(String key) {
    final node = nodesGenerator(
        parent: _jsonTree.activeParent, type: JEType.objectNode, content: '');
    _jsonTree.addKeyValuePair(key, node);
    _notifyListeners();
  }

  /// Selects a child node by its key (for objects) or index (for arrays).
  void select(dynamic identifier) {
    _jsonTree.select(identifier);
    _notifyListeners();
  }

  /// Moves up to the parent node.
  void up() {
    _jsonTree.up();
    _notifyListeners();
  }

  /// Deletes the element at the current cursor position.
  void pressDelete() {
    if (_jsonTree.delete()) {
      _notifyListeners();
    }
  }

  /// Clears the entire expression tree.
  void pressClear() {
    if (_jsonTree.clear()) {
      _notifyListeners();
    }
  }
}
