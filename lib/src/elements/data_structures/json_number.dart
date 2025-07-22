import '../../constants/json_element_types.dart';
import '../../core/json_element.dart';

/// Represents a JSON number value.
class JSONNumber extends JSONElement {
  final num value; // Can be int or double

  JSONNumber(this.value);

  /// Creates a [JSONNumber] from a raw Dart [num].
  factory JSONNumber.fromJson(num value) {
    return JSONNumber(value);
  }

  @override
  String get getType => JETypes.number.name;

  @override
  String toJson() {
    return value.toString();
  }
}
