import 'package:algo/queue/queue.dart';

class QueueStack<E> implements QueueDataStructure<E> {
  /// Dequeue: Whenever you enqueue an
  /// element, it
  /// goes in the right stack
  final _rightStack = <E>[];

  /// Enqueue: When you need to dequeue an
  /// element, you
  /// reverse the right stack, place it in the
  /// left stack, and remove the top element
  /// the reversing operation is only required
  /// when the left stack is empty,making
  /// most enqueue and dequeue operations
  /// constant-time
  final _leftStack = <E>[];

  /// return length property
  /// O(1) cause you used list for stacks
  int get length => _leftStack.length + _rightStack.length;

  @override
  E? dequeue() {
    if (_leftStack.isEmpty) {
      /// If the left stack is empty, set it as the reverse
      /// of the right stack
      _leftStack.addAll(_rightStack.reversed);

      /// Since you have transferred everything to the left,
      /// just clear the right
      _rightStack.clear();
    }
    if (_leftStack.isEmpty) return null;

    /// remove last element from left stack
    return _leftStack.removeLast();
  }

  ///push to the stack by appending to
  /// the list.
  /// O(1)
  @override
  bool enqueue(E element) {
    _rightStack.add(element);
    return true;
  }

  /// no element to dequeue and no new
  /// elements have been enqueued
  /// O(1)
  @override
  bool get isEmpty => _leftStack.isEmpty && _rightStack.isEmpty;

  /// O(1)
  @override
  E? get peek => _leftStack.isNotEmpty ? _leftStack.last : _rightStack.first;

  @override
  String toString() {
    final combined = [..._leftStack.reversed, ..._rightStack].join(', ');
    return '[$combined]';
  }
}

void main() {
  final queue = QueueStack<String>();
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
}

///Two main difference between stack and queue
///1) queue is First in First out but stack is Last in First out
///2) real-life example of stack: like cake, books, paper, undo functionality
///real-life example of queue: cinema ticket line or printer

/// SPEED
/// SPEEDD
/// SPEEDDA
/// PEEDDA
/// PEEDDAR
/// EEDDAR
/// EDDAR
/// EDDART
///
