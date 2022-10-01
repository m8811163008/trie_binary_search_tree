/// Use [List] since it allows random access to any element by
/// index.
///
/// Since you need to be able to compare elements, the value type
/// must be [Comparable]. You can use `Comparable<E>`, but if you
/// do your users will need to specify `List<num>` for integers
/// rather than `List<int>` since only [num] directly implements
/// [Comparable]
extension SortedList<E extends Comparable<dynamic>> on List<E> {
  /// Binary search is recursive.
  ///
  /// As is common for range indices(plural of index), start is
  /// inclusive and end is exclusive. This makes it play well
  /// with length of a zero-based list since it is always one
  /// greater than the last index.
  /// O(n log n)
  int? binarySearch(E value, [int? start, int? end]) {
    // check if start and end are null. If so, you create a range
    // that covers the entire collection.
    final startIndex = start ?? 0;
    final endIndex = end ?? length;
    //check if the range contains at least one element.If it
    // doesn't, the search has failed, and you return null
    if (startIndex >= endIndex) {
      return null;
    }
    // Now that you're sure you have elements in the range, you
    // find [middleIndex] of the range.
    final size = endIndex - startIndex;
    final middleIndex = startIndex + size ~/ 2;
    // Then compare the value at this index with value that you
    // are searching for, if it matched then return it, if it
    // doesn't then recursively search either the left or right
    // half of the collection
    if (this[middleIndex] == value) {
      return middleIndex;
    } else if (value.compareTo(this[middleIndex]) < 0) {
      return binarySearch(value, startIndex, middleIndex);
    } else {
      return binarySearch(value, middleIndex + 1, endIndex);
    }
  }

  // non recursive version of binary search with while loop
  // O(log n) or O(n log n)
  int? binarySearchWhile(
    E value,
  ) {
    var start = 0;
    var end = length;
    // var size = end - start;
    // var middle = start + size ~/ 2;
    // while (middle < end && middle >= start) {
    // Good old loop can be a lot easier :)
    while (start < end) {
      final size = end - start;
      final middle = start + size ~/ 2;
      final compareResult = elementAt(middle).compareTo(value);
      if (compareResult == 0) {
        return middle;
      } else if (compareResult < 0) {
        // value is in right side of middle
        start = middle + 1;
      } else {
        // value is in left side of middle
        end = middle;
      }
    }
    return null;
  }
// On each loop you move start and end closer and closer to
// each other until you finally got the value
}

void main() {
  final list = [1, 2, 3, 3, 3, 3, 4, 5, 5];
  final range = findRange2(list, 3);
  print(range);
}

/// Binary search for every list(including unsorted ones)
int? safeBinarySearch<E extends Comparable<dynamic>, T extends Iterable<E>>(
    T list, E value,
    [int? start, int? end]) {
  // if list is not sorted then return
  var index = 1;
  while (index < list.length) {
    final biggerElement = list.elementAt(index);
    final smallerElement = list.elementAt(index - 1);
    if (smallerElement.compareTo(biggerElement) > 0) {
      // It is not sorted and return null or sort list
      print('list is not sorted');
      return null;
    }
    index++;
  }

  final startIndex = start ?? 0;
  final endIndex = end ?? list.length;

  if (startIndex >= endIndex) {
    return null;
  }

  final size = endIndex - startIndex;
  final middle = startIndex + size ~/ 2;
  final compareResult = list.elementAt(middle).compareTo(value);
  if (compareResult == 0) {
    return middle;
  } else if (compareResult < 0) {
    // value is in right side
    return safeBinarySearch(list, value, middle + 1, endIndex);
  } else {
    return safeBinarySearch(list, value, startIndex, middle);
  }
}

/// Search for a range
/// searches a sorted list and finds the range of indices for a
/// particular element.
class Range {
  int? start;
  int? end;
}

void findRange<E extends Comparable<dynamic>>(List<E> list,
    {required E value}) {
  final range = Range();
  var index = 0;
  for (final element in list) {
    if (element == value) {
      range.start ??= index;
      range.end ??= index + 1;
      if (index != range.start) {
        range.end = index + 1;
      }
    }
    index++;
  }
  print('(${range.start}, ${range.end})');
  // return start and end indices
}

//solution 2
class Range2 {
  Range2(this.start, this.end);

  final int start;
  final int end;

  @override
  String toString() => 'Range($start, $end)';
}

//elegant way using list capability
// O(n)
Range2? findRange2(List<int> list, int value) {
  final start = list.indexOf(value);
  if (start == -1) return null;
  final end = list.lastIndexOf(value) + 1;
  return Range2(start, end);
}

// This function improves the time complexity from O(n) to
// O(log n)
Range2? findRange3(List<int> list, int value) {
// start is inclusive and end is exclusive
  if (list.isEmpty) return null;
  final start = _startIndex(list, value);
  final end = _endIndex(list, value);
  if (start == null || end == null) return null;
  return Range2(start, end);
}

//helper function to find first element
int? _startIndex(List<int> list, int value) {
  var start = 0;
  var end = list.length;
  while (start < end) {
    final middle = start + (end - start) ~/ 2;
    if (list[middle] == value && list[middle - 1] != value) {
      return middle;
    } else if (list[middle] < value) {
      //value is in the right side
      start = middle + 1;
    } else {
      //value is in the left side
      end = middle;
    }
  }
  return null;
}

int? _endIndex(List<int> list, int value) {
  var start = 0;
  var end = list.length;
  while (start < end) {
    final middle = start + (end - start) ~/ 2;
    if (list[middle] == value && list[middle + 1] != value) {
      return middle;
    } else if (list[middle] > value) {
      //value is in the left side
      end = middle;
    } else {
      //value is in the left side
      start = middle + 1;
    }
  }
  return null;
}
