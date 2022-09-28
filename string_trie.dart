import 'trie_node.dart';

class StringTrie {
  TrieNode<int> root = TrieNode(key: null, parent: null);

  /// implement allString as a stored property.
  ///
  /// It update in insert or remove by the code unit
  /// collections in the trie. and used in in isEmpty and
  /// length getter
  /// Now that you're storing all of the strings in your trie
  /// separately as a set, you've lost the space complexity
  /// benefits that trie gave you.
  final Set<String> _allString = {};

  /// O(k) k is number of code units you're trying to insert.
  /// This cost is because you need to traverse through or create
  /// a new node for each code unit.
  void insert(String text) {
    /// current keeps track of your traversal progress,
    /// which starts with the root node
    var current = root;

    /// The trie stores each code unit in separate node.
    for (var codeUnit in text.codeUnits) {
      /// ??= first check if the node exists in the children map.
      /// If it doesn't, you create a new node.
      current.children[codeUnit] ??= TrieNode(key: codeUnit, parent: current);

      /// During each loop, you move current to the next node.
      current = current.children[codeUnit]!;
    }

    /// After the loop completes, current is referencing the node
    /// at the end of the collection, that is, the last node in
    /// the string.
    /// You mark that node as the terminating node.
    current.isTerminating = true;
    _allString.add(text);
  }

  /// O(k) this comes from traversing through k nodes to determine
  /// whether the code unit collection is in the trie.
  bool contains(String text) {
    var current = root;
    for (var codeUnit in text.codeUnits) {
      final child = current.children[codeUnit];
      if (child == null) {
        return false;
      }
      current = child;
    }
    return current.isTerminating;
  }

  void remove(String text) {
    var current = root;

    /// You check if the code unit collection that you want
    /// to remove is part of the trie
    /// O(k) k represents the number of code units in the string
    /// that you're trying to remove.
    for (final codeUnit in text.codeUnits) {
      final child = current.children[codeUnit];

      /// If you don't find your search string that means the
      /// collection isn't in the trie and you can abort.
      if (child == null) {
        return;
      }

      /// if text is part of trie you point current to the last
      /// node of the collection
      current = child;
    }

    /// If the final node isn't marked as terminating, that means
    /// the collection isn't in the trie and you can abort.
    if (!current.isTerminating) {
      return;
    }

    /// You set [isTerminating] to false so the current node
    /// can be removed by the loop in the next step
    current.isTerminating = false;

    /// Update `_allString` stored property
    _allString.remove(text);

    ///Since nodes can be shared, you don't want to remove
    ///code units that belongs to another collection.
    ///So if there is no children in the current node, it means
    ///that other collections don't depend on the current node
    ///
    /// Also check if the current node is terminating, if it is,
    /// then it belongs to another collection
    ///
    /// As long as current satisfies these conditions, you
    /// continually backtrack through the parent property
    /// and remove the nodes until parent is null or other
    /// conditions become false
    while (current.parent != null &&
        current.children.isEmpty &&
        !current.isTerminating) {
      /// backtrack through the parent property and remove nodes
      current.parent!.children[current.key!] = null;
      current = current.parent!;
    }
  }

  List<String> matchPrefix(String prefix) {
    var current = root;

    /// verify that the trie contains the prefix.
    /// If not, you return an empty list
    for (final codeUnit in prefix.codeUnits) {
      final child = current.children[codeUnit];
      if (child == null) {
        return const [];
      }
      current = child;
    }
    //after you found the node that marks the end of the prefix,
    // you call a recursive helper method named [_moreMatches]
    // to find all the sequences after the current node
    return _moreMatches(prefix, current);
  }

  // O(K * m) where k represents the longest collection matching
  // the prefix and m represents the number of collections that
  // match the prefix
  List<String> _moreMatches(String prefix, TrieNode<int> node) {
    // create a list to hold the results.
    List<String> results = [];
    // if current node is terminating one , you add what you've    //got to the results.
    if (node.isTerminating) {
      results.add(prefix);
    }
    // you need to check the current node's children. For every   // child node, you recursively call _moreMatches to seek out   // other terminating nodes
    for (final child in node.children.values) {
      final codeUnit = child!.key!;
      results.addAll(_moreMatches(
        '$prefix${String.fromCharCode(codeUnit)}',
        child,
      ));
    }
    return results;
  }

  /// Returns all the collections in the trie.
  ///
  List<String> get allString {
    List<String> results = [];
    if (root.children.isEmpty) {
      return results;
    } else {
      results.addAll(sumString(root, ''));
    }
    return results;
  }

  List<String> sumString(TrieNode node, String preMade) {
    List<String> results = [];
    if (node.isTerminating) {
      results.add(preMade);
    }
    for (final child in node.children.values) {
      results.addAll(
          sumString(child!, '$preMade${String.fromCharCode(child.key)}'));
    }
    return results;
  }

  /// A count property that tells how many strings are
  /// currently in the trie.
  int get wordsCount => _countIsTerminating(root);

  int _countIsTerminating(TrieNode node) {
    var count = 0;
    if (node.isTerminating) {
      count++;
    }
    for (final childNode in node.children.values) {
      count += _countIsTerminating(childNode!);
    }
    return count;
  }

  bool get isEmpty => root.children.isEmpty;

  int get length => _allString.length;

  bool get isEmpty2 => _allString.isEmpty;

  Set<String> get allString2 => _allString;
}

void main() {
  final trie = StringTrie();
  // trie.insert('car');
  // trie.insert('card');
  trie.insert('a');
  trie.insert('ab');
  trie.insert('cars');
  trie.insert('carbs');
  trie.insert('carapace');
  trie.insert('cargo');
  // final test = trie.allString;
  final test = trie.wordsCount;
  print(test);
}
