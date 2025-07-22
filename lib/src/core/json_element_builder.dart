import '../elements/data_structures/json_array.dart';
import '../elements/data_structures/json_boolean.dart';
import '../elements/data_structures/json_null.dart';
import '../elements/data_structures/json_number.dart';
import '../elements/data_structures/json_object.dart';
import '../elements/data_structures/json_string.dart';
import 'json_element.dart';

/// Helper function to convert a dynamic value (from jsonDecode) into a JSONElement.
JSONElement buildJsonElement(dynamic value) {
  if (value is Map<String, dynamic>) {
    return JSONObject.fromJson(value);
  } else if (value is List<dynamic>) {
    return JSONArray.fromJson(value);
  } else if (value is String) {
    return JSONString.fromJson(value);
  } else if (value is num) {
    return JSONNumber.fromJson(value);
  } else if (value is bool) {
    return JSONBoolean.fromJson(value);
  } else if (value == null) {
    return JSONNull.fromJson();
  } else {
    throw ArgumentError('Unsupported JSON type: ${value.runtimeType}');
  }
}
