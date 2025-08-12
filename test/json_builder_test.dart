import 'package:test/test.dart';
import 'package:json_builder_pro/json_builder_pro.dart';

void main() {
  group('JSONTree - toJson', () {
    test('can build a complex JSON object', () {
      final JSONTree jsonTree = JSONTree();
      final JSONInputController controller = JSONInputController(jsonTree);

      controller.addObject(); // Start with an object

      controller.addStringProperty('name', 'John Doe');
      controller.addNumberProperty('age', 30);
      controller.addBooleanProperty('isStudent', false);

      controller.addArrayProperty('courses');
      controller.select('courses'); // Select the 'courses' array
      controller.addString('Math');
      controller.addString('Science');
      controller.up(); // Exit 'courses' array

      controller.addObjectProperty('address');
      controller.select('address'); // Select the 'address' object
      controller.addStringProperty('street', '123 Main St');
      controller.addStringProperty('city', 'Anytown');
      controller.addStringProperty('zip', '12345');
      controller.up(); // Exit 'address' object

      final expectedJson =
          '{"name":"John Doe","age":30,"isStudent":false,"courses":["Math","Science"],"address":{"street":"123 Main St","city":"Anytown","zip":"12345"}}';
      print('Generated JSON: ${jsonTree.toJsonString()}');
      expect(jsonTree.toJsonString(), expectedJson);
    });

    test('should throw exception if trying to add a second root element', () {
      final JSONTree jsonTree = JSONTree();
      final JSONInputController controller = JSONInputController(jsonTree);

      controller.addObject();
      expect(() => controller.addObject(), throwsA(isA<Exception>()));
    });
  });

  group('JSONTree - fromJson', () {
    test('can parse a simple JSON object', () {
      final jsonString =
          '{"name":"Test","value":123,"active":true,"data":null}';
      final jsonTree = JSONTree.fromJson(jsonString);
      expect(jsonTree.toJsonString(), jsonString);
    });

    test('can parse a simple JSON array', () {
      final jsonString = '["apple",123,true,null]';
      final jsonTree = JSONTree.fromJson(jsonString);
      expect(jsonTree.toJsonString(), jsonString);
    });

    test('can parse nested JSON objects and arrays', () {
      final jsonString =
          '{"user":{"name":"Alice","age":30,"hobbies":["reading","hiking",null]},"products":[{"id":1,"name":"Laptop"},{"id":2,"name":"Mouse"}]}';
      final jsonTree = JSONTree.fromJson(jsonString);
      expect(jsonTree.toJsonString(), jsonString);
    });

    test('should handle null values correctly', () {
      final jsonString = '{"key":null,"array":[1,null,3]}';
      final jsonTree = JSONTree.fromJson(jsonString);
      expect(jsonTree.toJsonString(), jsonString);
    });
  });
}
