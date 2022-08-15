/// Queue is First in First out data structure
/// The queue only cares about removal from the front and
/// insertion at the back
///Create a queue with four different internal data structure
/// List
/// Doubly linked list
/// Ring buffer
/// Two stacks
abstract class QueueDataStructure<E> {
  /// Insert element in back of stack
  bool enqueue(E element);

  /// Remove element at the front of the queue and return it
  E? dequeue();
  bool get isEmpty;

  /// Return the element at the front of the queue
  E? get peek;
}
