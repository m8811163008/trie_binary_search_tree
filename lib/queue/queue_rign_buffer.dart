import 'package:algo/queue/queue.dart';

// Copyright (c) 2022 Razeware LLC
// For full license & permission details, see LICENSE.

class RingBuffer<E> {
  RingBuffer(int length) : _list = List.filled(length, null, growable: false);

  final List<E?> _list;

  ///front of the queue
  int _writeIndex = 0;

  ///next available slot
  int _readIndex = 0;
  int _size = 0;

  bool get isFull => _size == _list.length;

  bool get isEmpty => _size == 0;

  void write(E element) {
    if (isFull) throw Exception('Buffer is full');
    _list[_writeIndex] = element;
    _writeIndex = _advance(_writeIndex);
    _size++;
  }

  int _advance(int index) {
    return (index == _list.length - 1) ? 0 : index + 1;
  }

  E? read() {
    print('here2');
    if (isEmpty) return null;
    final element = _list[_readIndex];
    _readIndex = _advance(_readIndex);
    _size--;
    return element;
  }

  E? get peek => (isEmpty) ? null : _list[_readIndex];

  @override
  String toString() {
    final text = StringBuffer();
    text.write('[');
    int index = _readIndex;
    while (index != _writeIndex) {
      if (index != _readIndex) {
        text.write(', ');
      }
      text.write(_list[index % _list.length]);
      index++;
    }
    text.write(']');
    return text.toString();
  }
}

class QueueRingBuffer<E> implements QueueDataStructure<E> {
  QueueRingBuffer(int length) : _ringBuffer = RingBuffer<E>(length);
  final RingBuffer<E> _ringBuffer;

  @override
  E? dequeue() => _ringBuffer.read();

  ///Enqueue is still an O(1) operation
  @override
  bool enqueue(E element) {
    print('here');
    if (_ringBuffer.isFull) {
      return false;
    }

    /// To append an element to the queue
    _ringBuffer.write(element);
    return true;
  }

  @override
  bool get isEmpty => _ringBuffer.isEmpty;

  @override
  E? get peek => _ringBuffer.peek;

  @override
  String toString() {
    return _ringBuffer.toString();
  }
}

void main() {
  final queue = QueueRingBuffer<String>(3);
  queue.enqueue('S');
  queue.enqueue('P');
  queue.enqueue('P');
  queue.dequeue();
  print(queue);
}

/// Exercise: In a game the problem is that everyone always forgets
/// whose turn it is. Crete organizer that tell you whose turn it
/// is.
extension BoardGameManager<E> on QueueRingBuffer {
  E? nextPlayer() {
    final player = dequeue();
    if (player != null) {
      enqueue(player);
    }

    return player;
  }
}

/// exercise: double ended queue
/// A double ended queue aka deque is, as its name suggests,
/// a queue where elements can be added or removed from the
/// and back
/// A queue (FIFO order) allows you to add elements to back and
/// remove from the front
/// A stack (LIFO order) allows you to add elements to the back,
/// and remove from the back
/// Deque can be considered both a queue and a stack at the same
/// time.
/// Build a deque.bellow is a simple Deque interface, the enum
/// Direction describes whether you are adding or removing
/// an element from the front or back of the deque.
enum Direction {
  front,
  back,
}

abstract class Deque<E> {
  bool get isEmpty;

  E? peek(Direction from);

  bool enqueue(E element, Direction to);

  E? dequeue(Direction from);
}

class DequeImpl<E> implements Deque<E> {
  final _list = [];

  @override
  E? dequeue(Direction from) {
    if (_list.isEmpty) {
      return null;
    }
    if (from == Direction.front) {
      return _list.removeAt(0);
    } else {
      return _list.removeLast();
    }
  }

  @override
  bool enqueue(E element, Direction to) {
    if (to == Direction.front) {
      _list.insert(0, element);
    } else {
      _list.add(element);
    }
    return true;
  }

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  E? peek(Direction from) => from == Direction.front ? _list.first : _list.last;

  @override
  String toString() => _list.toString();
}
