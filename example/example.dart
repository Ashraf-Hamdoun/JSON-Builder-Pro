import 'package:json_builder_pro/json_builder_pro.dart';

void main() {
  final JSONTree jsonTree = JSONTree();
  final JSONInputController controller = JSONInputController(jsonTree);

  // Build a simple JSON object:
  // {
  //   "name": "John Doe",
  //   "age": 30,
  //   "isStudent": false,
  //   "courses": [
  //     "Math",
  //     "Science"
  //   ]
  // }

  controller.addObject(); // Start with an object

  // Add a string property
  controller.addStringProperty('name', 'John Doe');

  // Add a number property
  controller.addNumberProperty('age', 30);

  // Add a boolean property
  controller.addBooleanProperty('isStudent', false);

  // Add an array property and navigate into it
  controller.addArrayProperty('courses');
  controller.select('courses'); // Select the 'courses' array

  controller.addString('Math');
  controller.addString('Science');

  controller.up(); // Go up to the main object

  print('Generated JSON:');
  print(jsonTree.toJsonString());
}
