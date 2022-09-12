// Copyright (c) 2022 Razeware LLC
// For full license & permission details, see LICENSE.

import 'dart:math' as math;

import 'avl_node.dart';

class AvlTree<E extends Comparable<dynamic>> {
  AvlNode<E>? root;

  void insert(E value) {
    //update state and pass root and value to _insertAt
    root = _insertAt(root, value);
  }

  AvlNode<E> _insertAt(AvlNode<E>? node, E value) {
    //base case > create a Node if node is passed is empty
    if (node == null) {
      return AvlNode(value);
    }
    // by definition of BST left child [AvlNode] value is less
    // than value , is it is the case then traverse in left child
    // with same method but this time with left child as node and
    // same value and return update node and assign it to node
    // left child
    if (node.value.compareTo(value) > 0) {
      node.leftChild = _insertAt(node.leftChild, value);
    } else {
      node.rightChild = _insertAt(node.rightChild, value);
    }
    final balancedTree = balanced(node);
    balancedTree.height = 1 + math.max(node.rightHeight, node.leftHeight);
    return balancedTree;
  }

  AvlNode<E> leftRotate(AvlNode<E> node) {
    // The right child chosen as the pivot(shaft of rotation)
    // point. This node will replace the the rotated node as the
    // root of the subtree.That means it'll move up a level
    final pivot = node.rightChild!;
    // The node to be rotated will become the left child of the
    // pivot
    node.rightChild = pivot.leftChild;
    // The pivot's left child can now be set to the rotated node
    pivot.leftChild = node;
    // update the heights of the rotated node and the pivot.
    node.height = 1 + math.max(node.leftHeight, node.rightHeight);
    pivot.height = 1 + math.max(pivot.leftHeight, pivot.rightHeight);
    // return the pivot so that it can replace the rotated node
    // in the tree
    return pivot;
  }

  AvlNode<E> rightRotate(AvlNode<E> node) {
    // exclamation mark to specify this property is not null
    // and will not be null
    final pivot = node.leftChild!;

    node.leftChild = pivot.rightChild;
    pivot.rightChild = node;

    node.height = 1 + math.max(node.leftHeight, node.rightHeight);
    pivot.height = 1 + math.max(pivot.rightHeight, pivot.leftHeight);

    return pivot;
  }

  AvlNode<E> rightLeftRotate(AvlNode<E> node) {
    if (node.rightChild == null) {
      return node;
    }
    // place all the element in the right side
    node.rightChild = rightRotate(node.rightChild!);
    // when every element is in right side make a left rotate
    return leftRotate(node);
  }

  AvlNode<E> leftRightRotate(AvlNode<E> node) {
    if (node.leftChild == null) {
      return node;
    }
    node.leftChild = leftRotate(node.leftChild!);
    return rightRotate(node);
  }

  AvlNode<E> balanced(AvlNode<E> node) {
    switch (node.balanceFactor) {
      case 2:

        /// A balance factor of 2 suggests that the left child
        /// is "heavier"(contains more nodes) than the right child.
        /// This means that you want to use either left or
        /// right-left rotation/
        final left = node.leftChild;
        if (left != null && left!.balanceFactor == -1) {
          return leftRightRotate(node);
        } else {
          return rightRotate(node);
        }
      // ...
      case -2:
        final right = node.rightChild;
        if (right != null && right.balanceFactor == 1) {
          return rightLeftRotate(node);
        } else {
          return leftRotate(node);
        }
      // ...
      default:
        // first write default
        return node;
    }
  }

  void remove(E value) {
    root = _remove(root, value);
  }

  AvlNode<E>? _remove(AvlNode<E>? node, E value) {
    if (node == null) return null;

    //You can find an element in search tree easily with this
    // else-if statements
    if (value == node.value) {
      if (node.leftChild == null && node.rightChild == null) {
        return null;
      }
      if (node.leftChild == null) {
        return node.rightChild;
      }
      if (node.rightChild == null) {
        return node.leftChild;
      }
      // update current node value with min of right hand side or
      // bottom of most left side of [rightChild]
      node.value = node.rightChild!.min.value;
      node.rightChild = _remove(node.rightChild, node.value);
    } else if (value.compareTo(node.value) < 0) {
      node.leftChild = _remove(node.leftChild, value);
    } else {
      node.rightChild = _remove(node.rightChild, value);
    }
    final balancedNode = balanced(node);
    balancedNode.height =
        1 + math.max(balancedNode.leftHeight, balancedNode.rightHeight);
    return balancedNode;
  }

  bool contains(E value) {
    var current = root;
    while (current != null) {
      if (current.value == value) {
        return true;
      }
      if (value.compareTo(current.value) < 0) {
        current = current.leftChild;
      } else {
        current = current.rightChild;
      }
    }
    return false;
  }

  @override
  String toString() => root.toString();
}

extension _MinFinder<E> on AvlNode<E> {
  AvlNode<E> get min => leftChild?.min ?? this;

  int leafNodes(int height) {
    return math.pow(2, height).toInt();
  }

  int nodes(int height) {
    int nodes = 0;
    for (int h = 0; h <= height; h++) {
      nodes += math.pow(2, h).toInt();
    }
    return nodes;
  }

  int nodesFaster(int height) {
    return math.pow(2, height + 1).toInt() - 1;
  }
}

void main() {
  final tree = AvlTree<int>();
  tree.insert(15);
  tree.insert(10);
  tree.insert(16);
  tree.insert(16);
  tree.insert(16);
  tree.insert(16);
  tree.insert(16);
  tree.insert(16);
  print(tree.root!.height);
  // tree.remove(18);
  // print(tree);
}
