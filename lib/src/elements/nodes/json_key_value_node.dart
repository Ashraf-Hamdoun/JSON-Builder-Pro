import 'package:json_builder_pro/src/core/json_element.dart';

/// A class that represents a key/value pair for JSON objects.
class JSONKeyValue {
  String key;
  JSONElement value;

  JSONKeyValue({
    required this.key,
    required this.value,
  });

  String toJsonString() {
    return '"$key": ${value.toJsonString()}';
  }
}
