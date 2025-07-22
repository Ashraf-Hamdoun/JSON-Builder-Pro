import '../../constants/json_element_types.dart';
import '../../core/json_element.dart';

/// Represents a JSON number value.
class JSONNumber extends JSONElement {
  final num value; // Can be int or double

  JSONNumber(this.value);

  @override
  String get getType => JETypes.number.name;

  @override
  String toJsonString() {
    return value.toString();
  }
}
