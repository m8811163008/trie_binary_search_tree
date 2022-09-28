import 'package:algo/tree/trie_tree/trie_node.dart';

/// E represent element in a collection and T represent
/// the iterable like [List] which is [Iterable] collection
/// E represent the type for the [TrieNode] key
class Trie<E, T extends Iterable<E>> {
  TrieNode<E> root = TrieNode(key: null, parent: null);

  void insert(T collection) {
    /// it use for iteration process
    var current = root;

    /// add value to children of current if it doesn't exist and
    /// traverse further
    for (E value in collection) {
      current.children[value] ??= TrieNode(key: value, parent: current);

      /// during each loop you move current to next node
      current = current.children[value]!;
    }

    /// Since after loop we are in last node so update
    /// `isTerminating` to true;
    current.isTerminating = true;
  }

  bool contains(T collection) {
    var current = root;
    for (E value in collection) {
      final child = current.children[value];
      if (child == null) {
        return false;
      }
      current = child;
    }
    return current.isTerminating;
  }

  void remove(T collection) {
    /// finds the node that you want to remove
    /// traverse from root to child and if iterableCollection
    /// doesn't exist return
    var current = root;
    for (E value in collection) {
      final child = current.children[value];
      if (child == null) {
        return;
      }

      /// If iterableCollection is part of trie you point current
      /// to last node of collection
      current = child;
    }

    /// If the final node isn't mark as isTerminating, that means
    /// the collection isn't in trie and you can abort
    if (!current.isTerminating) {
      return;
    }

    /// Set [isTerminating] to false so in next iteration it will
    /// be remove.
    current.isTerminating = false;

    /// since values in trie can be shared you don't want to
    /// remove shared nodes.
    /// If children of current is empty it means it doesn't belong to other collection
    /// If current `isTerminating` meas it belong to other collection
    /// if parent is not null we backtrack through the parent
    /// property and make current node
    /// to null and update current to current parent
    while (!current.isTerminating &&
        current.children.isEmpty &&
        current.parent != null) {
      current.parent!.children[current.key!] = null;
      current = current.parent!;
    }
  }
}

void main() {
  final trie = Trie<int, List<int>>();
  trie.insert('cut'.codeUnits);
  trie.insert('cute'.codeUnits);
  if (trie.contains('cute'.codeUnits)) {
    print('cute is in the trie');
  }
  trie.remove('cut'.codeUnits);
  assert(!trie.contains('cut'.codeUnits));
}
