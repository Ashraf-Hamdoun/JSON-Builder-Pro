import '../../constants/json_element_types.dart';
import '../../core/json_element.dart';

/// Represents a JSON null value.
class JSONNull extends JSONElement {
  JSONNull();

  /// Creates a [JSONNull] instance.
  factory JSONNull.fromJson() {
    return JSONNull();
  }

  @override
  String get getType => JETypes.nullType.name;

  @override
  String toJson() {
    return 'null';
  }
}
