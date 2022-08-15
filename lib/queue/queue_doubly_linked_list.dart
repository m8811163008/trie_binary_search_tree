import 'package:double_linked_list/double_linked_list.dart';

import 'queue.dart';

/// A doubly linked list is simply a linked
/// list in which nodes also contain a
/// reference to the previous node
/// time complexity of O(1) and space
/// complexity of O(n)
/// The main weakness with QueueLinkedList is that it suffer
/// from high overhead.Each element has to have extra storage
/// for the forward and back references.By contrast, QueueList
/// does bulk allocation, which is faster
class QueueLinkedList<E> implements QueueDataStructure<E> {
  final _list = DoubleLinkedList<E>.empty();

  /// O(1)
  @override
  E? dequeue() => _list.first.remove().content;

  @override
  bool enqueue(E element) {
    _list.end.insertBefore(element);
    return true;
  }

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  E? get peek => _list.isEmpty ? null : _list.first.content;

  @override
  String toString() => _list.toString();
}

void main() {
  final queue = QueueLinkedList<String>();
  queue.enqueue('S');
  queue.enqueue('P');
  queue.enqueue('E');
  queue.enqueue('E');
  queue.enqueue('D');
  queue.enqueue('D');
  queue.enqueue('A');
  queue.enqueue('A');
  queue.enqueue('A');
  queue.enqueue('A');
  queue.enqueue('A');
  queue.dequeue();
  queue.enqueue('R');
  queue.dequeue();
  queue.dequeue();
  queue.enqueue('T');
  print(queue);

  /// []
}
