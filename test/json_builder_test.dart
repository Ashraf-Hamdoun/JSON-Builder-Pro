import 'package:test/test.dart';
import 'package:json_builder_pro/json_builder_pro.dart';

void main() {
  group('JSONTree - toJson', () {
    test('can be created and converted to a string', () {
      final tree = JSONTree(initialType: JETypes.object);
      final rootObject = tree.root as JSONObject;

      rootObject.set('name', JSONString('Alice'));
      rootObject.set('age', JSONNumber(30));

      final hobbies = JSONArray();
      hobbies.add(JSONString('reading'));
      hobbies.add(JSONString('coding'));
      rootObject.set('hobbies', hobbies);

      final contact = JSONObject();
      contact.set('email', JSONString('alice@example.com'));
      contact.set('phone', JSONString('123-456-7890'));
      rootObject.set('contact', contact);

      const expectedJson =
          '{"name":"Alice","age":30,"hobbies":["reading","coding"],"contact":{"email":"alice@example.com","phone":"123-456-7890"}}';
      expect(tree.toJson(), expectedJson);
    });

    test('handles empty object', () {
      final tree = JSONTree(initialType: JETypes.object);
      expect(tree.toJson(), '{}');
    });

    test('handles empty array', () {
      final tree = JSONTree(initialType: JETypes.array);
      expect(tree.toJson(), '[]');
    });

    test('handles null value', () {
      final tree = JSONTree(initialType: JETypes.object);
      (tree.root as JSONObject).set('key', JSONNull());
      expect(tree.toJson(), '{"key":null}');
    });

    test('handles boolean value', () {
      final tree = JSONTree(initialType: JETypes.object);
      (tree.root as JSONObject).set('key', JSONBoolean(true));
      expect(tree.toJson(), '{"key":true}');
    });

    test('handles number value', () {
      final tree = JSONTree(initialType: JETypes.object);
      (tree.root as JSONObject).set('key', JSONNumber(123.45));
      expect(tree.toJson(), '{"key":123.45}');
    });

    test('handles string with special characters', () {
      final tree = JSONTree(initialType: JETypes.object);
      (tree.root as JSONObject).set('key', JSONString('Hello "World"\nTab\tBack\\slash'));
      expect(tree.toJson(), "{\"key\":\"Hello \"World\"\nTab\tBack\\slash\"}");
    });
  });

  group('JSONTree - fromJson', () {
    test('parses a simple object string', () {
      const jsonString = '{"name":"Alice","age":30}';
      final tree = JSONTree.fromJson(jsonString);
      final rootObject = tree.root as JSONObject;

      expect(rootObject.get('name')?.toJson(), '"Alice"');
      expect(rootObject.get('age')?.toJson(), '30');
    });

    test('parses a simple array string', () {
      const jsonString = '["apple","banana",123,true,null]';
      final tree = JSONTree.fromJson(jsonString);
      final rootArray = tree.root as JSONArray;

      expect(rootArray.elements.length, 5);
      expect(rootArray.elements[0].toJson(), '"apple"');
      expect(rootArray.elements[2].toJson(), '123');
      expect(rootArray.elements[3].toJson(), 'true');
      expect(rootArray.elements[4].toJson(), 'null');
    });

    test('parses nested objects and arrays', () {
      const jsonString =
          '{"user":{"id":1,"name":"Bob","roles":["admin","editor"]},"active":true}';
      final tree = JSONTree.fromJson(jsonString);
      final rootObject = tree.root as JSONObject;

      final userObject = rootObject.get('user') as JSONObject;
      expect(userObject.get('id')?.toJson(), '1');
      expect(userObject.get('name')?.toJson(), '"Bob"');

      final rolesArray = userObject.get('roles') as JSONArray;
      expect(rolesArray.elements.length, 2);
      expect(rolesArray.elements[0].toJson(), '"admin"');
      expect(rolesArray.elements[1].toJson(), '"editor"');

      expect(rootObject.get('active')?.toJson(), 'true');
    });

    test('throws FormatException for invalid JSON', () {
      const invalidJson = '{"key":"value"'; // Missing closing brace
      expect(() => JSONTree.fromJson(invalidJson), throwsA(isA<FormatException>()));
    });

    test('throws ArgumentError for unsupported root type', () {
      const invalidJson = '123'; // Root is a number, not object or array
      expect(() => JSONTree.fromJson(invalidJson), throwsA(isA<FormatException>()));
    });
  });

  group('removeMySelf', () {
    test('removes element from JSONObject', () {
      final tree = JSONTree(initialType: JETypes.object);
      final rootObject = tree.root as JSONObject;
      rootObject.set('name', JSONString('Alice'));
      rootObject.set('age', JSONNumber(30));

      final ageElement = rootObject.get('age');
      expect(ageElement?.removeMySelf(), isTrue);
      expect(rootObject.containsKey('age'), isFalse);
      expect(tree.toJson(), '{"name":"Alice"}');
    });

    test('removes element from JSONArray', () {
      final tree = JSONTree(initialType: JETypes.array);
      final rootArray = tree.root as JSONArray;
      rootArray.add(JSONString('apple'));
      rootArray.add(JSONString('banana'));

      final bananaElement = rootArray.elements[1];
      expect(bananaElement.removeMySelf(), isTrue);
      expect(rootArray.elements.length, 1);
      expect(rootArray.elements[0].toJson(), '"apple"');
      expect(tree.toJson(), '["apple"]');
    });

    test('returns false if element has no parent', () {
      final element = JSONString('standalone');
      expect(element.removeMySelf(), isFalse);
    });

    test('removes nested element', () {
      final tree = JSONTree(initialType: JETypes.object);
      final rootObject = tree.root as JSONObject;
      final nestedObject = JSONObject();
      nestedObject.set('innerKey', JSONString('innerValue'));
      rootObject.set('outerKey', nestedObject);

      final innerElement = nestedObject.get('innerKey');
      expect(innerElement?.removeMySelf(), isTrue);
      expect(nestedObject.containsKey('innerKey'), isFalse);
      expect(tree.toJson(), '{"outerKey":{}}');
    });
  });
}