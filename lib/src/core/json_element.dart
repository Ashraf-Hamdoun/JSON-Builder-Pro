// Define the type for the parent removal callback
// This function takes a JSONElement (the child to remove) as an argument
// and returns true if successful, false otherwise.
typedef ParentRemover = bool Function(JSONElement childToRemove);

/// Abstract base class for all JSON elements.
/// Provides a common interface for getting the type, converting to a JSON string,
/// and allowing an element to request removal from its parent.
abstract class JSONElement {
  /// The callback function provided by the parent to allow this element to remove itself.
  /// This will be null for the root element of a JSONTree or if not attached to a parent.
  ParentRemover? _parentRemover;

  /// Private constructor to accept the parent remover.
  /// Subclasses will call super(parentRemover) to pass it up.
  JSONElement([this._parentRemover]);

  /// Returns the string representation of the JSON element's type.
  String get getType;

  /// Converts the JSON element to its JSON string representation.
  String toJson();

  /// Attempts to remove this element from its parent.
  /// Returns `true` if the removal was successful, `false` otherwise (e.g., no parent, or parent couldn't remove it).
  bool removeMySelf() {
    if (_parentRemover != null) {
      return _parentRemover!(
        this,
      ); // Call the parent's removal function, passing 'this' element
    }
    return false; // No parent remover means it cannot remove itself
  }

  /// Sets the parent remover for this element. This is primarily for internal use
  /// by parent elements when adding children.
  void setParentRemover(ParentRemover? remover) {
    _parentRemover = remover;
  }
}
