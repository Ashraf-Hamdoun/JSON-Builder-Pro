# JSON Builder Pro

[![pub version](https://img.shields.io/pub/v/json_builder_pro.svg)](https://pub.dev/packages/json_builder_pro)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A powerful and intuitive Dart package for programmatically building, manipulating, and serializing JSON structures using a tree-based, object-oriented approach.

Say goodbye to manual `Map<String, dynamic>` manipulation and complex JSON string concatenation. This package provides a robust, type-safe way to construct and modify JSON data, making it ideal for API request/response handling, configuration management, or any Dart/Flutter project that requires dynamic JSON generation.

## Key Features

-   **🌳 Intuitive Tree-Based Model**: Represents JSON data as a logical tree of `JSONElement` nodes (like `JSONObject`, `JSONArray`) and leaves (like `JSONString`, `JSONNumber`, `JSONBoolean`, `JSONNull`). This makes complex JSON structures easy to manage and navigate.
-   **✨ Object-Oriented API**: Interact with JSON data using familiar object-oriented methods (`set`, `get`, `add`, `remove`), providing a clean and readable alternative to raw `Map` and `List` operations.
-   **🔗 Parent-Aware Elements**: Each `JSONElement` is aware of its parent, enabling powerful operations like `removeMySelf()` where an element can remove itself from its parent structure, simplifying complex deletion logic.
-   **🚀 Pure Dart & Flutter Compatible**: Written in 100% Dart, ensuring seamless integration with any Dart or Flutter project on any platform.
-   **🔄 Dynamic Structure Manipulation**: Easily add, update, or remove elements at any level of the JSON tree, maintaining structural integrity automatically.
-   **📥 `fromJson` Constructors**: Effortlessly parse JSON strings or raw Dart `Map`/`List` objects into a `JSONTree` structure, making it simple to load existing JSON data.

## Core Concept: The JSON Tree

Think of `JSONTree` as a structured builder for your JSON data. Instead of a flat string or a raw `Map`, your JSON lives in a hierarchical tree.

-   **`JSONTree`**: The main class you interact with. It holds the root of your JSON structure (either a `JSONObject` or a `JSONArray`).
-   **`JSONElement`**: The abstract base class for all JSON components. It provides common functionality like `toJsonString()` and the `removeMySelf()` method.
-   **`JSONObject`**: Represents a JSON object (`{}`). It manages key-value pairs where keys are `String`s and values are `JSONElement`s.
-   **`JSONArray`**: Represents a JSON array (`[]`). It manages an ordered list of `JSONElement`s.
-   **`JSONString`, `JSONNumber`, `JSONBoolean`, `JSONNull`**: These are the leaf nodes, representing the primitive JSON data types.

When you add elements to a `JSONObject` or `JSONArray`, the package automatically establishes the parent-child relationships, allowing for powerful tree traversal and manipulation.

## Installation

Add this to your `pubspec.yaml` file:

```yaml
dependencies:
  json_builder_pro: ^1.0.3 # Use the latest version
```

Then, run `flutter pub get` or `dart pub get`.

## Getting Started

See the `examples/example.dart` file for a comprehensive example of how to use the library.

## Advanced Usage

See the `examples/example.dart` file for advanced usage examples, including building nested structures and using `removeMySelf()`.

## API Reference

-   **`JSONTree`**: The main entry point for building a JSON structure.
    -   `JSONTree({required JETypes initialType})`: Constructor to initialize the tree with a root object or array.
    -   `factory JSONTree.fromJson(String jsonString)`: Creates a `JSONTree` from a JSON string.
    -   `JSONElement get root`: Gets the root `JSONElement` of the tree.
    -   `String toJson()`: Converts the entire tree to its JSON string representation.

-   **`JSONElement`**: Abstract base class for all JSON types.
    -   `String get getType`: Returns the type of the JSON element (e.g., 'object', 'array', 'string').
    -   `String toJson()`: Converts the element to its JSON string representation.
    -   `bool removeMySelf()`: Attempts to remove this element from its parent. Returns `true` if successful.

-   **`JSONObject`**: Represents a JSON object.
    -   `JSONObject([Map<String, JSONElement>? initialMembers, ParentRemover? parentRemover])`: Constructor.
    -   `Map<String, JSONElement> get members`: Gets the underlying map of members.
    -   `void set(String key, JSONElement value)`: Adds or updates a key-value pair.
    -   `JSONElement? get(String key)`: Retrieves an element by key.
    -   `JSONElement? remove(String key)`: Removes a key-value pair and returns the removed element.
    -   `bool containsKey(String key)`: Checks if the object contains a key.
    -   `void clear()`: Removes all members.

-   **`JSONArray`**: Represents a JSON array.
    -   `JSONArray([List<JSONElement>? initialElements, ParentRemover? parentRemover])`: Constructor.
    -   `List<JSONElement> get elements`: Gets the underlying list of elements.
    -   `void add(JSONElement element)`: Adds an element to the end.
    -   `void addAll(Iterable<JSONElement> newElements)`: Adds multiple elements.
    -   `void insert(int index, JSONElement newElement)`: Inserts an element at a specific index.
    -   `bool remove(JSONElement element)`: Removes the first occurrence of an element.
    -   `JSONElement removeAt(int index)`: Removes an element at a specific index.
    -   `void clear()`: Removes all elements.

-   **`JSONString`, `JSONNumber`, `JSONBoolean`, `JSONNull`**: Concrete implementations of `JSONElement` for primitive types.
    -   Each has a `value` property (except `JSONNull`).

-   **`JETypes`**: An enum representing all possible JSON element types.

## Contributing

Contributions are welcome! If you find a bug or have a feature request, please file an issue on the [issue tracker](https://github.com/Ashraf-Hamdoun/JSON-Builder/issues). If you want to contribute code, please feel free to open a pull request on the [repository](https://github.com/Ashraf-Hamdoun/JSON-Builder).

## License

This package is licensed under the [MIT License](LICENSE).