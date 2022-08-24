import 'package:algo/queue/queue_double_stack.dart';
import 'package:flutter/material.dart' as material;

class TreeNode<T> {
  TreeNode(this.value);

  T value;

  /// Like linked list tree use nodes however
  /// since tree nodes can point to multiple
  /// other nodes, you use a list to hold
  /// references to all the children
  List<TreeNode<T>> children = [];

  void add(TreeNode<T> child) {
    children.add(child);
  }

  /// you allow caller to pass in an anonymous function
  /// named performAction that will be called once for
  /// every node.
  void forEachDepthFirst(void Function(TreeNode<T> node) performAction) {
    performAction(this); //exit strategy
    /// Recursion uses a stack under the hood
    /// you can use stack if you don't want your implementation
    /// to be recursive
    for (final child in children) {
      /// Then you visit all of the current node's children
      /// and call their forEachDepthFirst methods.
      /// Eventually you reach leaf nodes without any children
      /// and so the recursive function calls don't go forever
      child.forEachDepthFirst(performAction);
    }
  }

  /// level order traversal means that you visit all of
  /// the nodes at an upper level before visiting
  /// any of the nodes at the next level down.
  /// You can accomplish this by using a queue.
  void forEachLevelOrder(void Function(TreeNode<T> node) performAction) {
    final queue = QueueStack<TreeNode<T>>();
    performAction(this);

    /// You first enqueue the root node(level 0) and then
    /// add the children (level 1)
    children.forEach(queue.enqueue);
    var node = queue.dequeue();

    /// The while loop subsequently enqueues all of the children
    /// on te next level down.
    /// Since queue is FIFO, this will result in each level
    /// de-queuing in order from top to bottom
    while (node != null) {
      performAction(node);
      node.children.forEach(queue.enqueue);
      node = queue.dequeue();
    }
  }

  /// Search algorithm
  /// Since it visits all of the nodes, if there are multiple
  /// matches, the last match will win.
  /// This means you'll get different objects back depending on
  /// what traversal method you use.
  TreeNode? search(T value) {
    TreeNode? result;

    /// you iterate through each node and check if its
    /// value is the same as what you're searching for
    /// If so, you return it as the result,
    /// but return null if not
    forEachLevelOrder((node) {
      if (node.value == value) {
        result = node;
      }
    });
    return result;
  }
}

extension TreeNodeX<T> on TreeNode<T> {
  ///Exercise 1: Print a tree in level order
  /// nodes in the same level should be printed in the same line
  /// for example
  /// 15
  /// 1 17 20
  /// 1 5 0 2 5 7
  void printLevelOrder() {
    final queue = QueueStack<TreeNode<T>>();
    final queue2 = QueueStack<TreeNode<T>>();
    print(value); //print root
    children.forEach(queue.enqueue);
    do {
      var node = queue.dequeue();
      var result = '';
      while (node != null) {
        node.children.forEach((node) {
          queue2.enqueue(node);
        });
        result += '${node.value.toString()} ';
        node = queue.dequeue();
      }
      print(result);
      var node2 = queue2.dequeue();
      var result2 = '';
      while (node2 != null) {
        node2.children.forEach((node) {
          queue.enqueue(node);
        });
        result2 += '${node2.value.toString()} ';
        node2 = queue2.dequeue();
      }
      print(result2);
    } while (!(queue.isEmpty && queue2.isEmpty));
  }

  void printLevelOrder2() {
    /// A straightforward way to print the nodes in level-order
    /// is to leverage level order traversal
    /// When new line should occur? the number of elements in
    /// the queue is useful
    /// 1. create stringBuffer
    final result = StringBuffer();

    /// 2. create a queueStack
    var queue = QueueStack<TreeNode<T>>();

    /// 3. variable to hold node left in current level with
    /// initial value of zero
    var nodesLeftInCurrentLevel = 0;

    /// 4.add tree to queue - > root element
    queue.enqueue(this);

    /// 5. while queue is not empty do ->
    while (!queue.isEmpty) {
      /// 6. update node left in current level
      nodesLeftInCurrentLevel = queue.length;

      /// 7. while node left in current level is greater than 0
      /// do ->
      while (nodesLeftInCurrentLevel > 0) {
        /// 8. dequeue and store value
        var node = queue.dequeue();

        /// 9. if value is null then break the loop
        if (node == null) break;

        /// 10. write in stringBuffer current node value with a space
        result.write('${node.value} ');

        /// 11. for every element in node's children enqueue them
        for (var element in node.children) {
          queue.enqueue(element);
        }

        /// 12. update node left in queue by -1
        nodesLeftInCurrentLevel -= 1;

        /// end do
      }

      /// 13. write in stringBuffer \n
      result.write('\n');

      /// end do
    }

    /// print result
    print(result);
  }

  /// exercise material.Widget tree
  /// create three separate nodes with the following names and types:
  /// Column: a tree node that takes multiple children
  /// Padding: a tree node that takes a single child
  /// Text: a tree leaf node
  /// build simple material.Widget tree
  TreeNode<material.Widget> exercise() {
    TreeNode<material.Widget> column =
        TreeNode<material.Widget>(material.Column());
    TreeNode<material.Widget> padding = TreeNode<material.Widget>(
        const material.Padding(padding: material.EdgeInsets.all(8.0)));
    TreeNode<material.Widget> text =
        TreeNode<material.Widget>(const material.Text('text'));
    column.add(padding);
    padding.add(text);
    return column;
  }
}

///Exercise two
class Widget {}

class Column extends Widget {
  Column({this.children});

  final List<Widget>? children;
}

class Padding extends Widget {
  Padding({required this.value, this.child});

  double value;
  Widget? child;
}

///lead node
class Text extends Widget {
  Text(this.value);

  String value;
}

void main() {
  // final tree = makeBeverageTree();
  // tree.printLevelOrder2();

  final tree = Column(children: [
    Padding(value: 8, child: Text('this')),
    Padding(value: 8.0, child: Text('is')),
    Column(children: [
      Text('my'),
      Text('widget'),
      Text('tree'),
    ])
  ]);
}

TreeNode<String> makeBeverageTree() {
  final tree = TreeNode('beverages');
  final hot = TreeNode('hot');
  final cold = TreeNode('cold');
  final tea = TreeNode('tea');
  final coffee = TreeNode('coffee');
  final chocolate = TreeNode('cocoa');
  final blackTea = TreeNode('black');
  final greenTea = TreeNode('green');
  final chaiTea = TreeNode('chai');
  final soda = TreeNode('soda');
  final milk = TreeNode('milk');
  final gingerAle = TreeNode('ginger ale');
  final bitterLemon = TreeNode('bitter lemon');
  final bitterLemon2 = TreeNode('bitter lemon2');
  tree.add(hot);
  tree.add(cold);
  hot.add(tea);
  hot.add(coffee);
  hot.add(chocolate);
  cold.add(soda);
  cold.add(milk);
  tea.add(blackTea);
  tea.add(greenTea);
  tea.add(chaiTea);
  soda.add(gingerAle);
  soda.add(bitterLemon);
  bitterLemon.add(bitterLemon2);
  return tree;
}
