import '../../constants/json_element_types.dart';
import '../../core/json_element.dart';

/// Represents a JSON boolean value.
class JSONBoolean extends JSONElement {
  final bool value;

  JSONBoolean(this.value);

  /// Creates a [JSONBoolean] from a raw Dart [bool].
  factory JSONBoolean.fromJson(bool value) {
    return JSONBoolean(value);
  }

  @override
  String get getType => JETypes.boolean.name;

  @override
  String toJson() {
    return value.toString();
  }
}
