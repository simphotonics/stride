/// Iterates a fixed length [List] using a positive non-zero step size
/// and a custom start index.
///
/// Note: Concurrent modification is *not* checked
/// prior to advancing the iterator. It is assumed that the list length does
/// not change. Should be used to iterate *fixed* length lists.
class UncheckedStrideIterator<E> implements Iterator<E> {
  /// Constructs an object of type [UncheckedStrideIterator].
  /// * [fixedLengthList]: A list with fixed length and entries of type `E`.
  /// * [stepSize]: The iteration stride (step size). Must be larger than zero.
  /// * [startIndex]: If [startIndex] is a valid list index
  /// then the first element returned by the getter [current] (after initially
  /// advancing the iterator) will be: `fixedLengthList[startIndex]`.
  UncheckedStrideIterator(List<E> fixedLengthList, int stepSize,
      [int startIndex = 0])
      : _list = fixedLengthList,
        stepSize = stepSize <= 0 ? 1 : stepSize,
        _fixedListLength = fixedLengthList.length,
        _position = startIndex < 0 ? -stepSize : startIndex - stepSize;

  /// The iterable being iterated.
  final List<E> _list;

  /// The length of the fixed length list.
  final int _fixedListLength;

  /// The current position.
  int _position;

  /// The iteration stride.
  final int stepSize;

  /// The current element.
  E? _current;

  @override
  E get current => _current as E;

  /// Moves the iterator to the next element.
  ///
  /// Must be called before accessing the first element. If this method returns
  /// `true` it is safe to access the [current] element.
  ///
  /// Concurrent modification is *not* checked before advancing the iterator.
  /// [UncheckedStrideIterator] should be used for iterating *fixed*
  /// length lists.
  @override
  bool moveNext() {
    _position += stepSize;
    if (_position < _fixedListLength) {
      _current = _list[_position];
      return true;
    } else {
      _current = null;
      _position = _fixedListLength;
      return false;
    }
  }
}

/// Iterates an [Iterable] using a negative non-zero step size and
/// a custom start index.
///
/// Concurrent modification is *not* checked
/// prior to advancing the iterator.
class ReverseUncheckedStrideIterator<E> implements Iterator<E> {
  /// Constructs an object of type [ReverseUncheckedStrideIterator].
  /// * [fixedLengthList]: A fixed length list with entries of type `E`.
  /// * [stepSize]: The iteration stride (step size). Must be smaller than zero.
  /// * [startIndex]: If [startIndex] is a valid list index
  /// then the first element returned by the getter [current] (after initially
  /// advancing the iterator) will be: `fixedLengthList[startIndex]`.
  ReverseUncheckedStrideIterator(List<E> fixedLengthList, int stepSize,
      [int startIndex = 0])
      : _list = fixedLengthList,
        stepSize = stepSize >= 0 ? -1 : stepSize,
        _length = fixedLengthList.length {
    _position = startIndex > _length - 1
        ? _length - 1 - this.stepSize
        : startIndex - this.stepSize;
  }

  /// The fixed length list being iterated.
  final List<E> _list;

  /// The length of `_list`.
  final int _length;

  /// The current position.
  late int _position;

  /// The iteration stride.
  final int stepSize;

  /// The current element.
  E? _current;

  @override
  E get current => _current as E;

  @override
  bool moveNext() {
    _position += stepSize;
    if (_position >= 0) {
      _current = _list[_position];
      return true;
    } else {
      _current = null;
      _position = -1;
      return false;
    }
  }
}
