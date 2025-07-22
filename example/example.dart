import 'package:json_builder/json_builder.dart';

void main() {
  // Create a JSON Tree with a root object
  final tree = JSONTree(initialType: JETypes.object);
  final rootObject =
      tree.root as JSONObject; // Cast to JSONObject to use its methods

  // Add some elements
  rootObject.set('name', JSONString('Alice'));
  rootObject.set('age', JSONNumber(30));

  final hobbies = JSONArray();
  hobbies.add(JSONString('reading'));
  hobbies.add(JSONString('coding'));
  rootObject.set('hobbies', hobbies); // Add array to object

  final contact = JSONObject();
  contact.set('email', JSONString('alice@example.com'));
  contact.set('phone', JSONString('123-456-7890'));
  rootObject.set('contact', contact); // Add object to object

  print('Initial Tree: ${tree.toJsonString()}');
  // Expected: {"name":"Alice","age":30,"hobbies":["reading","coding"],"contact":{"email":"alice@example.com","phone":"123-456-7890"}}

  // Get references to specific elements
  final ageElement = rootObject.get('age');
  final codingElement =
      (hobbies.elements[1] as JSONString); // Get "coding" from hobbies array
  final emailElement =
      (contact.get('email') as JSONString); // Get "email" from contact object

  print('\n--- Testing removeMySelf ---');

  // Test 1: Remove "age" from the root object
  print(
    'Removing age (from parent): ${ageElement?.removeMySelf()}',
  ); // Should be true
  print('Tree after removing age: ${tree.toJsonString()}');
  // Expected: {"name":"Alice","hobbies":["reading","coding"],"contact":{"email":"alice@example.com","phone":"123-456-7890"}}

  // Test 2: Remove "coding" from the hobbies array
  print(
    'Removing coding (from parent): ${codingElement.removeMySelf()}',
  ); // Should be true
  print('Tree after removing coding: ${tree.toJsonString()}');
  // Expected: {"name":"Alice","hobbies":["reading"],"contact":{"email":"alice@example.com","phone":"123-456-7890"}}

  // Test 3: Remove "email" from the contact object
  print(
    'Removing email (from parent): ${emailElement.removeMySelf()}',
  ); // Should be true
  print('Tree after removing email: ${tree.toJsonString()}');
  // Expected: {"name":"Alice","hobbies":["reading"],"contact":{"phone":"123-456-7890"}}

  // Test 4: Try to remove "name" (already removed, or no longer attached as "age" was)
  // Note: if you remove "age", and try to remove "name" through its original parent, it will still work
  // because the parent still holds the map reference. This is where complexity arises.
  // The beauty of removeMySelf is that the child itself knows how to reach its parent.
  final nameElement = rootObject.get('name'); // Get fresh reference
  print(
    'Removing name (from parent): ${nameElement?.removeMySelf()}',
  ); // Should be true
  print('Tree after removing name: ${tree.toJsonString()}');
  // Expected: {"hobbies":["reading"],"contact":{"phone":"123-456-7890"}}

  // Test 5: Try to remove the root element itself (should fail as it has no parent)
  print(
    'Removing root (from parent): ${rootObject.removeMySelf()}',
  ); // Should be false
  print('Tree after trying to remove root: ${tree.toJsonString()}');
}