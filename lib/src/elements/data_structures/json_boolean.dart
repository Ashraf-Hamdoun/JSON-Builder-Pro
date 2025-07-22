import '../../constants/json_element_types.dart';
import '../../core/json_element.dart';

/// Represents a JSON boolean value.
class JSONBoolean extends JSONElement {
  final bool value;

  JSONBoolean(this.value);

  @override
  String get getType => JETypes.boolean.name;

  @override
  String toJsonString() {
    return value.toString();
  }
}
