/// The type of a JSON element.
///
/// User-facing types are marked below. Internal types are for package use only.
enum JEType {
  // Internal types (not for direct user use)
  trunk,
  node,
  leaf,
  placeHolderLeaf,
  // User-facing node types
  arrayNode,
  objectNode,

  // User-facing leaf types
  numberLeaf,
  stringLeaf,
  booleanLeaf,
  nullLeaf,
}

extension JETypeUserFacing on JEType {
  /// Returns true if this type is intended for user code.
  bool get isUserFacing => const {
        JEType.numberLeaf,
        JEType.stringLeaf,
        JEType.booleanLeaf,
        JEType.nullLeaf,
        JEType.arrayNode,
      }.contains(this);
}
