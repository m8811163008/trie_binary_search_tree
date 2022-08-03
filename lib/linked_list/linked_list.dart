class Node<T> {
  T value;
  Node<T>? nextNode;
  Node({required this.value, this.nextNode, this.previousNode});

  /// Exercise
  Node<T>? previousNode;

  @override
  String toString() {
    if (nextNode == null) return '$value';
    return '$value --> ${nextNode.toString()}';
  }
}

class LinkedList<E> extends Iterable<E> {
  Node<E>? head;
  Node<E>? tail;
  @override
  bool get isEmpty => head == null;

  void push(E value) {
    if (isEmpty) {
      head = Node(value: value);
      tail = head;
      return;
    }
    head = Node(value: value, nextNode: head);
  }

  void append(E value) {
    if (isEmpty) {
      push(value);
      return;
    }
    tail!.nextNode = Node(value: value);
    tail = tail!.nextNode;
    // tail = Node(value: value);
  }

  Node<E>? nodeAt(int index) {
    var currentNode = head;
    var currentIndex = 0; // made it zero based index list
    while (currentNode != null && currentIndex < index) {
      // while (currentIndex < index) {
      currentNode = currentNode.nextNode;
      currentIndex += 1;
    }
    return currentNode;
  }

  Node<E> insertAfter(Node<E> node, E value) {
    if (node == tail) {
      append(value);
      return tail!;
    }
    node.nextNode = Node(value: value, nextNode: node.nextNode);
    return node.nextNode!;
  }

  ///By moving the head down a node, you've effectively removed the first node of the list
  E? pop() {
    final value = head?.value;
    head = head?.nextNode;

    /// In the event that the list becomes empty, you set tail to null
    if (isEmpty) {
      tail = null;
    }
    return value;
  }

  E? removeLast() {
    //1
    /// if only one node in liked list you delegate work to pop and it update tail and node
    if (head?.nextNode == null) return pop();
    //2
    /// keep searching the node until current next node is equal to tail
    /// This signify the current is node before tail
    var current = head;
    while (current!.nextNode != tail) {
      current = current.nextNode;
    }
    //3
    /// collect tail value and the then rewire the node before tail
    var value = tail?.value;
    tail = current;
    tail?.nextNode = null;
    return value;
  }

  E? removeAfter(Node<E> node) {
    var value = node.nextNode?.value;

    /// special care needs to be taken if the removal node is the tail node, since
    /// the tail node should be updated
    if (node.nextNode == tail) {
      tail = node;
    }

    /// skip the node that used to come after
    node.nextNode = node.nextNode?.nextNode;
    return value;
  }

  @override
  String toString() {
    return head.toString();
  }

  @override
  Iterator<E> get iterator => _LinkedListIterator(this);
}

class _LinkedListIterator<E> implements Iterator<E> {
  _LinkedListIterator(LinkedList<E> linkedList) : _linkedList = linkedList;

  /// you passed in a reference so that iterator has something to work with
  final LinkedList<E> _linkedList;
  Node<E>? _currentNode;

  /// Someone doesn't care about concept of node and need just value
  /// So when you return current you extracted value from current
  @override
  E get current => _currentNode!.value;

  bool _firstPass = true;
  @override
  bool moveNext() {
    /// If the list is empty, then there is no need to go further
    if (_linkedList.isEmpty) return false;

    /// Since _currentNode is null to start with, you need to
    /// set it to head on the first pass.
    /// after that just point it to the next node in the chain
    if (_firstPass) {
      _currentNode = _linkedList.head;
      _firstPass = false;
    } else {
      _currentNode = _currentNode?.nextNode;
    }

    /// return true lets the iterable know that there are still
    /// more elements, but when the current node is null, you know that you reach end of the list
    return _currentNode != null;
  }
}

class Exercise {
  ///exercise: Create a function that prints the nodes of a linked list in reverse order
  /// 1 -> 2 -> 3 -> null
  /// should be
  /// 3
  /// 2
  /// 1
  void printNodesRecursively<T>(Node<T>? node) {
    // use recursion since it allows you to build a call stack,
    // just need to call the print statement as the call stack
    // unwinds

    //start with base case: the condition for terminating the
    // recursion.if node is null, then it means you're reched the end of the list
    if (node == null) return;
    //this is recursive call: calling the same function with the nex node
    printNodesRecursively(node.nextNode);
    // Any code that comes after the recursive call is called
    // called only after the base case triggers, that is, after the recursive function hits the end of the list.
    print(node.value);
  }

  /// Exercise : find the middle node
  /// create a function that finds the middle node
  /// 1 -> 2 -> 3 -> 4 -> null
  /// middle is 3
  /// 1 -> 2 -> 3 -> null
  /// middle is 2
  Node<E>? getMiddle<E>(LinkedList<E> list) {
    // one solution is to have two reference traverse down the
    // nodes of the list, where one is twice as fast as the other.
    //once the faster reference reached the end, the slower reference will be in the middle.
    var slow = list.head;
    var fast = list.head;
    // in while loop, fast checks the next two nodes while slow
    // only gets one. This is knows as runner's technique.
    while (fast?.nextNode != null) {
      fast = fast?.nextNode?.nextNode;
      slow = slow?.nextNode;
    }

    return slow;
  }

  /// Exercise: Reverse a Linked List
  /// create a function that reverses a linked list. You do this
  /// by manipulating the nodes so that they're linked in other
  /// direction
  /// before: 1 -> 2 -> 3 -> null
  /// after: 3 -> 2 -> 1 -> null
  LinkedList<E> reverseLinkedList<E>(LinkedList<E> list) {
    LinkedList<E> result = LinkedList<E>();
    // traverse to last node and add it to new list
    // then traverse back to head
    Node<E>? head = list.head;
    while (head != null) {
      result.push(head.value);
      head = head.nextNode;
    }
    return result;
  }
}

extension ReversibleLinkedList<E> on LinkedList<E> {
  void reverse() {
    final tempList = LinkedList<E>();
    for (final value in this) {
      tempList.push(value);
    }
    head = tempList.head;
    tail = tempList.tail;
  }

  void efficientReverse() {
    // assign head to tail
    tail = head;
    // create two references to keep track of traversal
    // The strategy us each node points to the next node down
    // the list. You'll traverse the list and make each node
    // point to the previous node instead
    var previous = head;
    var current = head?.nextNode;
    previous?.nextNode = null;
    // to prevent lost the link to the rest of the list add a
    // third pointer
    while (current != null) {
      // Each time you perform the reversal, you create a new
      // reference to the next node.
      // After every reversal procedure, you move the two
      // pointers to the next two nodes
      final next = current.nextNode;
      current.nextNode = previous;
      previous = current;
      current = next;
    }
    // After reversing all the pointers, you'll set the head
    // to the last node of this list.
    head = previous;
  }
  // The time complexity of this is O(n).However, you didn't
  // need to use a temporary list or allocate any new Node
  // objects, which significantly improves the performance
  // of this algorithm

  /// Exercise: Remove all occurrences
  /// create a function that removes all occurrences of a specific
  /// element from a linked list.
  /// The implementation is similar to the removeAfter method
  /// original : 1 -> 3 -> 3 -> 3 -> 4
  /// this.removeOccurrences(3) => 1 -> 4
  /// 1 -> 1
  /// this.removeOccurrences(1) => null
  void removeOccurrences(E value) {
    //to remove at head(trimming the head)
    while (head != null && head!.value == value) {
      head = head!.nextNode;
    }
    //to unlink the prev node from next node and connect it to
    // node next to next node of prev
    // you need to traverse the list using two pointer,prev
    // and next.
    var previous = head;
    var current = head?.nextNode;
    while (current != null) {
      // The if bloc will trigger if it's necessary to remove
      // a node
      if (current.value == value) {
        previous?.nextNode = current.nextNode;
        current = previous?.nextNode;
        continue;
      }
      // then you need to move prev and next pointers along
      // if you don't this your while loop may never terminate
      previous = current;
      current = current.nextNode;
    }
    // update the tail. This is necessary when the original
    // tail is a node
    // containing the value you wanted to remove
    tail = previous;
  }
  //this algorithm has time complexity of O(n) since you need
  // to go through all the elements
}

void main() {
  var list = LinkedList<int>();
  list.push(3);
  list.push(2);
  list.push(2);
  list.push(1);
  list.push(1);

  list.removeOccurrences(2);
  print(list);
}
