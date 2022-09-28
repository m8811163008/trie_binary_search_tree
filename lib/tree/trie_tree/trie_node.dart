import 'package:algo/tree/binary_search_tree.dart';

class TrieNode<T> {
  TrieNode({this.key, this.parent});

  /// Nullable Key holds data for a node and null for root node
  ///
  /// This is nullable because the root node of the trie has no
  /// key. It's called a key because you use it in a map of
  /// key-value pairs to store children nodes
  T? key;

  /// [TrieNode] holds a reference to its parent.This reference
  /// simplifies the remove method later
  TrieNode<T>? parent;

  /// Instead of left and right child in [BinarySearchTree]
  /// this holds the children of the node
  ///
  /// A node needs to hold multiple different elements. The
  /// children map accomplishes that.
  Map<T, TrieNode<T>?> children = {};

  /// [isTerminating] acts as a marker for the end of a collection
  bool isTerminating = false;
}

void main() {}
