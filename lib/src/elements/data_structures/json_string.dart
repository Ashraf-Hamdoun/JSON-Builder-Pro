import '../../constants/json_element_types.dart';
import '../../core/json_element.dart';

/// Represents a JSON string value.
class JSONString extends JSONElement {
  final String value;

  JSONString(this.value);

  /// Creates a [JSONString] from a raw Dart [String].
  factory JSONString.fromJson(String value) {
    return JSONString(value);
  }

  @override
  String get getType => JETypes.string.name;

  @override
  String toJson() {
    // Escape special characters within the string for valid JSON.
    final escapedValue = value
        .replaceAll('\\', '\\') // Escape backslashes
        .replaceAll('"', '"') // Escape double quotes
        .replaceAll('\n', '\n') // Escape newlines
        .replaceAll('\r', '\r') // Escape carriage returns
        .replaceAll('\t', '\t'); // Escape tabs
    return '"$escapedValue"';
  }
}
