import '../../constants/json_element_types.dart';
import '../../core/json_element.dart';

/// Represents a JSON null value.
class JSONNull extends JSONElement {
  JSONNull();

  @override
  String get getType => JETypes.nullType.name;

  @override
  String toJsonString() {
    return 'null';
  }
}
