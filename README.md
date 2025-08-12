# JSON Builder Pro

[![pub version](https://img.shields.io/pub/v/json_builder_pro.svg)](https://pub.dev/packages/json_builder_pro)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A powerful and intuitive Dart package for programmatically building, manipulating, parsing, and serializing JSON structures using a tree-based, object-oriented approach.

Say goodbye to manual `Map<String, dynamic>` manipulation and complex JSON string concatenation. This package provides a robust, type-safe way to construct and modify JSON data, making it ideal for API request/response handling, configuration management, or any Dart/Flutter project that requires dynamic JSON generation.

## Key Features

-   **🌳 Intuitive Tree-Based Model**: Represents JSON data as a logical tree of `JSONElement` nodes (like `JSONObjectNode`, `JSONArrayNode`) and leaves (like `JSONStringLeaf`, `JSONNumberLeaf`, `JSONBooleanLeaf`, `JSONNullLeaf`). This makes complex JSON structures easy to manage and navigate.
-   **✨ Object-Oriented API**: Interact with JSON data using familiar object-oriented methods (`addStringProperty`, `addObject`, `select`, `up`, etc. via `JSONInputController`), providing a clean and readable alternative to raw `Map` and `List` operations.
-   **🔗 Parent-Aware Elements**: Each `JSONElement` is aware of its parent, enabling powerful operations like `delete()` where an element can remove itself from its parent structure, simplifying complex deletion logic.
-   **🚀 Pure Dart & Flutter Compatible**: Written in 100% Dart, ensuring seamless integration with any Dart or Flutter project on any platform.
-   **🔄 Dynamic Structure Manipulation**: Easily add, update, or remove elements at any level of the JSON tree, maintaining structural integrity automatically.
-   **📥 `fromJson` Constructor**: Effortlessly parse JSON strings into a `JSONTree` structure, making it simple to load existing JSON data.

## Core Concept: The JSON Tree

Think of `JSONTree` as a structured builder for your JSON data. Instead of a flat string or a raw `Map`, your JSON lives in a hierarchical tree.

-   **`JSONTree`**: The main class you interact with. It holds the root of your JSON structure (either a `JSONObjectNode` or a `JSONArrayNode`).
-   **`JSONElement`**: The abstract base class for all JSON components. It provides common functionality like `toJsonString()`.
-   **`JSONNode`**: Abstract base for `JSONObjectNode` and `JSONArrayNode`.
-   **`JSONObjectNode`**: Represents a JSON object (`{}`). It manages key-value pairs where keys are `String`s and values are `JSONElement`s.
-   **`JSONArrayNode`**: Represents a JSON array (`[]`). It manages an ordered list of `JSONElement`s.
-   **`JSONStringLeaf`, `JSONNumberLeaf`, `JSONBooleanLeaf`, `JSONNullLeaf`**: These are the leaf nodes, representing the primitive JSON data types.

When you add elements to a `JSONObjectNode` or `JSONArrayNode`, the package automatically establishes the parent-child relationships, allowing for powerful tree traversal and manipulation.

## Installation

Add this to your `pubspec.yaml` file:

```yaml
dependencies:
  json_builder_pro: ^1.1.0 # Use the latest version
```

Then, run `flutter pub get` or `dart pub get`.

## Getting Started

See the `example/example.dart` file for a comprehensive example of how to use the library.

## Advanced Usage

See the `example/example.dart` file for advanced usage examples, including building nested structures and using `delete()`.

## API Reference

-   **`JSONTree`**: The main entry point for building and parsing JSON structures.
    -   `JSONTree()`: Constructor to initialize an empty tree.
    -   `factory JSONTree.fromJson(String jsonString)`: Creates a `JSONTree` from a JSON string.
    -   `String toJsonString()`: Converts the entire tree to its JSON string representation.

-   **`JSONInputController`**: Provides a high-level interface for manipulating the `JSONTree`.
    -   `JSONInputController(JSONTree tree)`: Constructor.
    -   `void addObject()`: Adds an object node.
    -   `void addArray()`: Adds an array node.
    -   `void addString(String value)`: Adds a string leaf.
    -   `void addNumber(double value)`: Adds a number leaf.
    -   `void addBoolean(bool value)`: Adds a boolean leaf.
    -   `void addStringProperty(String key, String value)`: Adds a string property to the current object.
    -   `void addNumberProperty(String key, double value)`: Adds a number property to the current object.
    -   `void addBooleanProperty(String key, bool value)`: Adds a boolean property to the current object.
    -   `void addArrayProperty(String key)`: Adds an array property to the current object.
    -   `void addObjectProperty(String key)`: Adds an object property to the current object.
    -   `void select(dynamic identifier)`: Navigates into a child node (by key for objects, index for arrays).
    -   `void up()`: Navigates to the parent node.
    -   `void pressDelete()`: Deletes the active child/element.
    -   `void pressClear()`: Clears the entire tree.

-   **`JSONElement`**: Abstract base class for all JSON types.
    -   `String get getType`: Returns the type of the JSON element (e.g., 'objectNode', 'arrayNode', 'stringLeaf').
    -   `String toJsonString()`: Converts the element to its JSON string representation.

-   **`JSONNode`**: Abstract base class for `JSONObjectNode` and `JSONArrayNode`.
    -   `void clear()`: Clears all children/members.
    -   `JSONNode? deleteActiveChild()`: Deletes the active child.

-   **`JSONObjectNode`**: Represents a JSON object.
    -   `Map<String, JSONElement> get members`: Gets the underlying map of members.
    -   `void set(String key, JSONElement value)`: Adds or updates a key-value pair.
    -   `JSONElement? get(String key)`: Retrieves an element by key.

-   **`JSONArrayNode`**: Represents a JSON array.
    -   `List<JSONElement> get children`: Gets the underlying list of elements.
    -   `void addChildLeaf(JSONLeaf leaf)`: Adds a leaf to the array.
    -   `void addChildNode(JSONNode node)`: Adds a node to the array.

-   **`JSONStringLeaf`, `JSONNumberLeaf`, `JSONBooleanLeaf`, `JSONNullLeaf`**: Concrete implementations of `JSONElement` for primitive types.
    -   Each has a `child` property (except `JSONNullLeaf` which has no content).

-   **`JEType`**: An enum representing all possible JSON element types.

## Contributing

Contributions are welcome! If you find a bug or have a feature request, please file an issue on the [issue tracker](https://github.com/Ashraf-Hamdoun/JSON-Builder-Pro/issues). If you want to contribute code, please feel free to open a pull request on the [repository](https://github.com/Ashraf-Hamdoun/JSON-Builder-Pro).

## License

This package is licensed under the [MIT License](LICENSE).
