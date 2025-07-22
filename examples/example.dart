import 'package:json_builder_pro/json_builder_pro.dart';

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

  print('Initial Tree: ${tree.toJson()}');
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
  print('Tree after removing age: ${tree.toJson()}');
  // Expected: {"name":"Alice","hobbies":["reading","coding"],"contact":{"email":"alice@example.com","phone":"123-456-7890"}}

  // Test 2: Remove "coding" from the hobbies array
  print(
    'Removing coding (from parent): ${codingElement.removeMySelf()}',
  ); // Should be true
  print('Tree after removing coding: ${tree.toJson()}');
  // Expected: {"name":"Alice","hobbies":["reading"],"contact":{"email":"alice@example.com","phone":"123-456-7890"}}

  // Test 3: Remove "email" from the contact object
  print(
    'Removing email (from parent): ${emailElement.removeMySelf()}',
  ); // Should be true
  print('Tree after removing email: ${tree.toJson()}');
  // Expected: {"name":"Alice","hobbies":["reading"],"contact":{"phone":"123-456-7890"}}

  // Test 4: Try to remove "name" (already removed, or no longer attached as "age" was)
  // Note: if you remove "age", and try to remove "name" through its original parent, it will still work
  // because the parent still holds the map reference. This is where complexity arises.
  // The beauty of removeMySelf is that the child itself knows how to reach its parent.
  final nameElement = rootObject.get('name'); // Get fresh reference
  print(
    'Removing name (from parent): ${nameElement?.removeMySelf()}',
  ); // Should be true
  print('Tree after removing name: ${tree.toJson()}');
  // Expected: {"hobbies":["reading"],"contact":{"phone":"123-456-7890"}}

  // Test 5: Try to remove the root element itself (should fail as it has no parent)
  print(
    'Removing root (from parent): ${rootObject.removeMySelf()}',
  ); // Should be false
  print('Tree after trying to remove root: ${tree.toJson()}');

  print('\n--- Testing fromJson ---');

  // Example 1: From a JSON object string
  const jsonObjectString =
      '{"product":"Laptop","price":1200.00,"features":["SSD","8GB RAM"],"available":true}';
  final productTree = JSONTree.fromJson(jsonObjectString);
  print('Product Tree from JSON: ${productTree.toJson()}');
  // Expected: {"product":"Laptop","price":1200.00,"features":["SSD","8GB RAM"],"available":true}

  // Accessing elements from the parsed tree
  final productObject = productTree.root as JSONObject;
  print('Product Name: ${(productObject.get('product') as JSONString).value}');
  print('Price: ${(productObject.get('price') as JSONNumber).value}');
  print('First Feature: ${((productObject.get('features') as JSONArray).elements[0] as JSONString).value}');

  // Example 2: From a JSON array string
  const jsonArrayString = '["apple", "banana", "orange", null, 123]';
  final fruitTree = JSONTree.fromJson(jsonArrayString);
  print('Fruit Tree from JSON: ${fruitTree.toJson()}');
  // Expected: ["apple", "banana", "orange", null, 123]

  // Accessing elements from the parsed array tree
  final fruitArray = fruitTree.root as JSONArray;
  print('First Fruit: ${(fruitArray.elements[0] as JSONString).value}');
  print('Null element type: ${fruitArray.elements[3].getType}');
  print('Number element value: ${(fruitArray.elements[4] as JSONNumber).value}');

  print('\n--- More Advanced Examples ---');

  // Example 3: Complex Nested Structure (toJson/fromJson)
  const complexJsonString = '''
{
  "store": {
    "name": "Tech Gadgets",
    "location": {
      "address": "123 Main St",
      "city": "Anytown",
      "zip": "12345"
    },
    "products": [
      {
        "id": "A1",
        "name": "Wireless Mouse",
        "price": 25.99,
        "inStock": true,
        "tags": ["electronics", "peripherals"]
      },
      {
        "id": "B2",
        "name": "Mechanical Keyboard",
        "price": 75.00,
        "inStock": false,
        "tags": ["gaming", "peripherals"]
      }
    ],
    "manager": null
  }
}
''';
  final storeTree = JSONTree.fromJson(complexJsonString);
  print('Complex Store Tree from JSON: ${storeTree.toJson()}');

  // Accessing deeply nested elements
  final storeObject = storeTree.root as JSONObject;
  final locationObject = storeObject.get('store') as JSONObject;
  final productsArray = locationObject.get('products') as JSONArray;
  final firstProduct = productsArray.elements[0] as JSONObject;
  final firstProductTags = firstProduct.get('tags') as JSONArray;

  print('Store Name: ${(locationObject.get('name') as JSONString).value}');
  print('First Product Name: ${(firstProduct.get('name') as JSONString).value}');
  print('First Product Tag: ${(firstProductTags.elements[0] as JSONString).value}');

  // Example 4: Updating Elements
  print('\n--- Updating Elements ---');
  firstProduct.set('price', JSONNumber(22.50)); // Update the price
  print('Updated First Product Price: \${firstProduct.toJson()}');

  firstProduct.set('inStock', JSONBoolean(false)); // Update stock status
  print('Updated First Product Stock: ${firstProduct.toJson()}');

  // Example 5: Adding/Removing Elements Dynamically
  print('\n--- Adding/Removing Elements ---');

  // Add a new product
  final newProduct = JSONObject();
  newProduct.set('id', JSONString('C3'));
  newProduct.set('name', JSONString('Webcam'));
  newProduct.set('price', JSONNumber(49.99));
  newProduct.set('inStock', JSONBoolean(true));
  productsArray.add(newProduct);
  print('Products after adding Webcam: ${productsArray.toJson()}');

  // Remove the second product (Mechanical Keyboard)
  final mechanicalKeyboard = productsArray.elements[1];
  mechanicalKeyboard.removeMySelf();
  print('Products after removing Mechanical Keyboard: ${productsArray.toJson()}');

  // Add a new key-value pair to the store object
  locationObject.set('establishedYear', JSONNumber(2020));
  print('Store after adding establishedYear: ${locationObject.toJson()}');

  // Remove the manager (which is null)
  final managerElement = locationObject.get('manager');
  if (managerElement != null) {
    managerElement.removeMySelf();
  }
  print('Store after removing manager: ${locationObject.toJson()}');

  // Example 6: Error Handling with fromJson
  print('\n--- Error Handling with fromJson ---');
  const malformedJson = '{"key": "value", "another": }'; // Syntax error
  try {
    JSONTree.fromJson(malformedJson);
  } catch (e) {
    print('Caught expected error for malformed JSON: ${e.runtimeType}');
  }

  const nonObjectOrArrayRoot = '"just_a_string"'; // Root is not an object or array
  try {
    JSONTree.fromJson(nonObjectOrArrayRoot);
  } catch (e) {
    print('Caught expected error for non-object/array root: ${e.runtimeType}');
  }
}