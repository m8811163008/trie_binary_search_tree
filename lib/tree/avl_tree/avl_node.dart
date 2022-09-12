// Copyright (c) 2022 Razeware LLC
// For full license & permission details, see LICENSE.
import 'dart:math' as math;

import 'package:algo/tree/avl_tree/avl_tree.dart';

import 'avl_node_abstract.dart';

class AvlNode<T> extends TraversableBinaryNode {
  AvlNode(this.value);

  @override
  T value;
  @override
  AvlNode<T>? leftChild;
  @override
  AvlNode<T>? rightChild;

  /// Shows longest distance from the current node to a leaf node.
  int height = 0;

  /// [BalanceFactor] computes the height difference of the left
  /// and right child.
  ///
  /// If a particular child is null, its height is considered to
  /// be -1.
  /// If the left child and the right child of a particular child
  /// is null, its height is considered to be 0.
  /// Used to determine whether a particular node is balanced.
  /// The height of the left and right children of each node must
  /// differ at most by 1. This number is known as the balance
  /// factor
  int get balanceFactor => leftHeight - rightHeight;

  int get leftHeight => leftChild?.height ?? -1;

  int get rightHeight => rightChild?.height ?? -1;

  @override
  String toString() {
    return _diagram(this);
  }

  String _diagram(
    AvlNode<T>? node, [
    String top = '',
    String root = '',
    String bottom = '',
  ]) {
    if (node == null) {
      return '$root null\n';
    }
    if (node.leftChild == null && node.rightChild == null) {
      return '$root ${node.value}\n';
    }
    final a = _diagram(node.rightChild, '$top ', '$top┌──', '$top│ ');
    final b = '$root${node.value}\n';
    final c = _diagram(node.leftChild, '$bottom│ ', '$bottom└──', '$bottom ');
    return '$a$b$c';
  }

  int leafNodes(int height) {
    return math.pow(2, height).toInt();
  }
}

void main() {
  final tree = AvlTree<int>();
  for (var i = 0; i < 10; i++) {
    tree.insert(i);
  }
  tree.root?.traverseInOrder(print);
}

class EnglishDictionary {
  final List<String> words = [];

  List<String> lookup(String prefix) {
    /// startsWith prefix go throw each letter.
    /// where goes throw list of string for length
    /// O(n * k)
    return words.where((word) => word.startsWith(prefix)).toList();
  }
}
