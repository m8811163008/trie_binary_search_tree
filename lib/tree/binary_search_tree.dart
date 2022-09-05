import 'package:algo/tree/binary_node/binary_node.dart';

/// By definition, binary search trees can only hold values that
/// are Comparable
/// 2. If you prefer you could use Comparable<E> instead of
/// Comparable<dynamic> but if consumer to this class want to use
/// int , ind doesn't directly implement Comparable but its super
/// class num does. So by using Comparable<dynamic> you allow
/// them to use int directly
class BinarySearchTree<E extends Comparable<dynamic>> {
  BinaryNode<E>? root;

  @override
  String toString() => root.toString();

  void insert(E value) {
    root = _insert(root, value);
  }

  BinaryNode<E> _insert(BinaryNode<E>? node, E value) {
    /// base case
    if (node == null) {
      return BinaryNode(value);
    }

    ///control flow and variable
    if (value.compareTo(node.value) < 0) {
      // if (value.compareTo(node.value) > 0) {
      node.leftChild = _insert(node.leftChild, value);
    } else {
      node.rightChild = _insert(node.rightChild, value);
    }

    ///return for previous calls
    return node;
  }

  /// This algorithm has traverse in order which is O(n) so this
  /// algorithm has O(n) time complexity
  /// for optimization rely on properties of BST can help you
  /// avoid needless comparisons
  bool contains(E value) {
    if (root == null) return false;
    var found = false;
    root!.traverseInOrder((other) {
      if (value == other) {
        found = true;
      }
    });
    return found;
  }

  /// for optimization rely on properties of BST can help you
  /// avoid needless comparisons
  /// O(log n) operation in balanced binary search tree
  bool optimizeContain(E value) {
    var current = root;

    /// As long as current isn't null, you'll keep branching
    /// through the tree
    while (current != null) {
      //If current node's value is equal o what you're trying
      // to find return true
      if (current.value == value) {
        return true;
      }

      ///otherwise, decide whether you're going to check he left
      /// or the right child
      if (value.compareTo(current.value) < 0) {
        current = current.leftChild;
      } else {
        current = current.rightChild;
      }
    }
    return false;
  }

  void remove(E value) {
    root = _remove(root, value);
  }

  BinaryNode<E>? _remove(BinaryNode<E>? node, E value) {
    if (node == null) return null;
    if (value == node.value) {
      /// a leaf node simply return null
      if (node.leftChild == null && node.rightChild == null) {
        return null;
      }

      /// with one child
      /// if no left child then you return node.rightChild
      if (node.leftChild == null) {
        return node.rightChild;
      }
      if (node.rightChild == null) {
        return node.leftChild;
      }

      ///with 2 child
      ///replace the node's value with he smallest value from
      /// the right subtree
      node.value = node.rightChild!.min.value;
      node.rightChild = _remove(node.rightChild, node.value);
    } else if (value.compareTo(node.value) < 0) {
      node.leftChild = _remove(node.leftChild, value);
    } else {
      node.rightChild = _remove(node.rightChild, value);
    }
    return node;
  }
}

extension _MinFinder<E> on BinaryNode<E> {
  /// Based on BST left most child in bst is smallest element
  BinaryNode<E> get min => leftChild?.min ?? this;
}

void main() {
  final bst = buildExampleTree();
  final bst2 = buildExampleTree2();

  print(bst.root!.isEqual(bst2.root!));
}

BinarySearchTree<int> buildExampleTree() {
  var tree = BinarySearchTree<int>();
  tree.insert(3);
  tree.insert(4);
  tree.insert(4);
  return tree;
}

BinarySearchTree<int> buildExampleTree2() {
  var tree = BinarySearchTree<int>();
  tree.insert(3);
  tree.insert(4);
  tree.insert(4);
  tree.insert(4);
  return tree;
}

/// exercise 1
bool isBinary(BinarySearchTree binarySearchTree) =>
    _isBinary(binarySearchTree.root);

bool _isBinary(BinaryNode? node) {
  if (node == null) return true;
  var isRightBinaryFlag = false;
  if (node.rightChild != null) {
    isRightBinaryFlag = node.value <= node.rightChild!.value ? true : false;
  } else {
    isRightBinaryFlag = true;
  }

  var isLeftBinaryFlag = false;
  if (node.leftChild != null) {
    isLeftBinaryFlag = node.value > node.leftChild?.value ? true : false;
  } else {
    isLeftBinaryFlag = true;
  }
  if (isRightBinaryFlag && isLeftBinaryFlag) {
    final isBinaryLeft = _isBinary(node.leftChild);
    final isBinaryRight = _isBinary(node.rightChild);
    if (isBinaryLeft && isBinaryRight) {
      return true;
    }
  }
  return false;
}

/// exercise 1 solution 2
extension Checker<E extends Comparable<dynamic>> on BinaryNode<E> {
  bool isBinarySearchTree() {
    return _isBST(this, min: null, max: null);
  }

  bool _isBST(BinaryNode? tree, {E? min, E? max}) {
    if (tree == null) {
      return true;
    }
    //check for bounds
    if (min != null && tree.value.compareTo(min) < 0) {
      return false;
    } else if (max != null && tree.value.compareTo(max) >= 0) {
      return false;
    }
    return _isBST(tree.leftChild, min: min, max: tree.value) &&
        // any node on right child should be greater that or equal to parent
        _isBST(tree.rightChild, min: tree.value, max: max);
  }

  bool isEqual(BinaryNode<E>? other) {
    return _isEqual(this, other);
  }

  // isEquality recursively check two nodes and their
  // descendants for equality.
  _isEqual(BinaryNode<E>? tree1, BinaryNode<E>? tree2) {
    // if one of them is null then two of them must be null
    // This is the base case(result of _isEqual is true or
    // false). if one or
    // more of the nodes are
    // null, then there's no need to continue checking.If both
    // nodes are null, they're equal.Otherwise, one is null and
    // one isn't null, so they must not be equal.
    if (tree1 == null || tree2 == null) {
      return tree1 == null && tree2 == null;
    }
    // check for value of first and second node for equality and
    // recursively calling left child and right child of both
    // trees
    // Time complexity O(n) Space Complexity O(n)
    return tree1.value.compareTo(tree2.value) == 0 &&
        _isEqual(tree1.rightChild, tree2.rightChild) &&
        _isEqual(tree1.leftChild, tree2.leftChild);
  }
}

extension SubTree<E> on BinarySearchTree {
  /// O(n) space and time complexity
  bool containsSubtree(BinarySearchTree subtree) {
    /// 1
    /// You begin by inserting all the elements of the current
    /// tree into a set
    Set treeValuesSet = <E>{};
    root?.traverseInOrder((value) {
      treeValuesSet.add(value);
    });

    /// 2
    /// isEqual is there to store the end result, you need this
    /// flag because traverseInOrder takes a closure, and you
    /// can't directly return from inside the closure.
    var isEqual = true;

    /// 3
    /// for every element in subtree you check if the set
    /// contains the value. If at any point set.contains(value)
    /// evaluates as false, you'll make sure isEqual stays false
    /// even if subsequent elements evaluate as true
    subtree.root?.traverseInOrder((value) {
      // if(treeValuesSet.contains(value) == false) isEqual = false;
      isEqual = isEqual && treeValuesSet.contains(value);
    });
    return isEqual;
  }
}
