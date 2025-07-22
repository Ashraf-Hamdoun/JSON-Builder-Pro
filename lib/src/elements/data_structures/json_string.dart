import '../../constants/json_element_types.dart';
import '../../core/json_element.dart';

/// Represents a JSON string value.
class JSONString extends JSONElement {
  final String value;

  JSONString(this.value);

  @override
  String get getType => JETypes.string.name;

  @override
  String toJsonString() {
    // Escape special characters within the string for valid JSON.
    return '"${value.replaceAll('\\', '\\\\').replaceAll('"', '\\"').replaceAll('\n', '\\n').replaceAll('\r', '\\r').replaceAll('\t', '\\t')}"';
  }
}
