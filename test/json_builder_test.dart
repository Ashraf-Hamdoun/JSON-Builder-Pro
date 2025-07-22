import 'package:test/test.dart';
import 'package:json_builder_pro/json_builder_pro.dart';

void main() {
  test('JSONTree can be created and converted to a string', () {
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
    expect(tree.toJsonString(), expectedJson);
  });
}
