import 'dart:math';

class BinaryNode<T> {
  BinaryNode(this.value);

  T value;
  BinaryNode<T>? rightChild;
  BinaryNode<T>? leftChild;
  int _height = 0;

  @override
  String toString() {
    return _diagram(this);
  }

  String _diagram(
    BinaryNode<T>? node, [
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
    final a = _diagram(
      node.rightChild,
      '$top ',
      '$top┌──',
      '$top│ ',
    );
    final b = '$root${node.value}\n';

    final c = _diagram(
      node.leftChild,
      '$bottom│ ',
      '$bottom└──',
      '$bottom ',
    );
    return '$a$b$c';
  }

  void traverseInOrder(void Function(T value) action) {
    /// If its not null then do traverseInOrder
    /// If tree node are structured in a certain way,
    /// in-order traversal visits them in ascending(increasing in
    /// size or importance)
    leftChild?.traverseInOrder(action);
    action(value);
    rightChild?.traverseInOrder(action);
  }

  void traversePreOrder(void Function(T value) action) {
    /// you call action before recursively traversing the children
    /// always visits the current node first
    action(value);
    leftChild?.traversePreOrder(action); //conditional nullable access
    rightChild?.traversePreOrder(action);
  }

  /// O(n) space complexity
  void traversePostOrder(void Function(T value) action) {
    /// only visits the current node after the left and right
    /// child have been visited
    leftChild?.traversePostOrder(action);
    rightChild?.traversePostOrder(action);
    action(value);
  }

  int get getHeight {
    if (value == null) return _height;
    int leftHeight = 0;
    if (leftChild != null) {
      leftHeight = leftChild!.getHeight + 1;
    }
    int rightHeight = 0;
    if (rightChild != null) {
      rightHeight = rightChild!.getHeight + 1;
    }
    _height = max(rightHeight, leftHeight);
    return _height;
  }

  /// O(n) time complexity
  /// since you need to traverse through all the nodes
  /// incurs a space cost of O(n) space complexity
  /// since you need to make the same n recursive calls to the
  /// call stack
  int getHeight2(BinaryNode? node) {
    /// This is the base case for the recursive solution.
    /// If the node is null, you'll return -1
    if (node == null) return -1;

    /// Here, you recursively call the getHeight function.
    /// for every node you visit, you add one to the height
    /// of the highest child
    return 1 +
        max(
          getHeight2(node.leftChild),
          getHeight2(node.rightChild),
        );
  }

  bool isBinary() {
    return false;
  }
}

void main() {
  final tree = createBinaryTree();
  final list = serialize(tree);
  final treeAfterReverse = deserializeHelper(list);
  final treeBeforeReverse = _deserialize(list);
  print('treeAfterReverse : \n $treeAfterReverse');
  print(treeBeforeReverse);
}

BinaryNode<int> createBinaryTree() {
  final n15 = BinaryNode(15);
  final n10 = BinaryNode(10);
  final n5 = BinaryNode(5);
  final n12 = BinaryNode(12);
  final n25 = BinaryNode(25);
  final n17 = BinaryNode(17);
  n15.leftChild = n10;
  n10.leftChild = n5;
  n10.rightChild = n12;
  n15.rightChild = n25;
  n25.leftChild = n17;
  return n15;
}

/// Exercise
/// A common task in software development is representing a
/// complex object using another data type.
/// serialization allows custom types to be used in systems
/// only support a closed set of data types.
/// devise (figure it out) a way to serialize a binary tree
/// into a list and a way to deserialize the list back to same
/// binary tree
/// O(n) time and space cost since creating a new list
extension Serializable<T> on BinaryNode<T> {
  void traversePreorderWithNull(Function(T? value) action) {
    action(value);
    if (leftChild == null) {
      action(null);
    } else {
      leftChild!.traversePreorderWithNull(action);
    }
    if (rightChild == null) {
      action(null);
    } else {
      rightChild!.traversePreorderWithNull(action);
    }
  }
}

/// deserialize takes a mutable list of values.
/// This is important because you'll be able to make
/// mutations to the list in each recursive step and allow
/// future recursive calls to see the changes.
BinaryNode<T>? _deserialize<T>(List<T?> list) {
  /// This is the base case. if the list is empty you
  /// end the recursion here.
  if (list.isEmpty) return null;

  /// You also won't bother
  /// making any nodes for null values in the list
  /// Since you're calling removeAt(0) as many times as elements
  /// in the list, this algorithm has an O(n2) time complexity
  /// O(n)
  final value = list.removeAt(0);

  /// O(1)
  // final value = list.removeLast();
  if (value == null) return null;

  /// You reassemble the tree by creating a node from the current
  /// value and recursively calling deserialize to assign nodes
  /// to the left and right children.
  /// This is similar to preOrder traversal
  final node = BinaryNode<T>(value);
  node.leftChild = _deserialize(list);
  node.rightChild = _deserialize(list);
  return node;
}

/// This is a helper function that first reverses the list
/// before calling the main deserialize function.
BinaryNode<T>? deserializeHelper<T>(List<T?> list) {
  return _deserialize(list.reversed.toList());
}

List<T?> serialize<T>(BinaryNode<T> node) {
  final List<T?> result = [];
  node.traversePreorderWithNull((value) {
    result.add(value);
  });
  return result;
}

// BinaryNode<T> fromList<T>(List<T> binaryList) {
//   final node = BinaryNode(binaryList.first);
//   binaryList.removeAt(0);
//   BinaryNode<T> nodeResult;
//   for (T element in binaryList) {
//     final nodeResult = addToTree(node, element);
//   }
// }

// BinaryNode<T> addToTree<T>(BinaryNode<T> tree, T newValue) {
//   if (tree.value == null) {
//     tree.value = newValue;
//   } else if (tree.leftChild == null) {
//     tree.leftChild = BinaryNode(newValue);
//   } else {
//     tree.rightChild ??= BinaryNode(newValue);
//   }
//   return tree;
// }
