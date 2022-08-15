import 'package:algo/queue/queue.dart';

class QueueList<E> implements QueueDataStructure<E> {
  final _list = <E>[];

  /// Removing an element from the beginning of a list is always
  /// a linear-time operation because it requires all the
  /// remaining elements in the list to be shifted in memory
  @override
  E? dequeue() => (isEmpty) ? null : _list.removeAt(0);

  /// Because list has space at the back this operation is O(1)
  /// capacity of list double each time it runs out of space but
  /// this doesn't happen often
  @override
  bool enqueue(E element) {
    _list.add(element);
    return true;
  }

  /// O(1)
  @override
  bool get isEmpty => _list.isEmpty;

  /// O(1)
  @override
  E? get peek => (isEmpty) ? null : _list.first;

  /// Add a new method to override toString so you can see the
  /// result of your operation
  @override
  String toString() => _list.toString();
}

void main() {
  final queue = QueueList<String>();
  queue.enqueue('S');
  queue.enqueue('P');
  queue.enqueue('E');
  queue.enqueue('E');
  queue.enqueue('D');
  queue.enqueue('D');
  queue.enqueue('A');
  queue.dequeue();
  queue.enqueue('R');
  queue.dequeue();
  queue.dequeue();
  queue.enqueue('T');
  print(queue);

  ///[S,P,E,E,D]
  ///[S,P,E,E,D,D,.,.,.,.]
  ///[S,P,E,E,D,D,A,.,.,.]
  ///[P,E,E,D,D,A,.,.,.,.]
  ///[E,E,D,D,A,.,.,.,.,.]
  ///[E,E,D,D,A,T,.,.,.,.]
}
