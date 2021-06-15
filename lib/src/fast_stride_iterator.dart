/// Iterates a fixed length [List] using a custom stride (step size)
/// and offset. The iterator is initial positioned at `offset - stride`.
///
/// Note: Concurrent modification is *not* checked
/// prior to advancing the iterator. It is assumed that the list length does
/// not change. Should be used to iterate *fixed* length lists.
class FastStrideIterator<E> implements Iterator<E> {
  /// Constructs an object of type `FastStrideIterator`.
  /// * `fixedLengthList`: A list with fixed length and entries of type `E`.
  /// * `stepSize`: The iteration stride (step size). Must be larger than zero.
  /// * `startPosition`: If `startPosition` is a valid list index
  /// then the first element returned by the getter `current` (after initially
  /// advancing the iterator) will be: `fixedLengthList[startPosition]`.
  FastStrideIterator(List<E> fixedLengthList, int stepSize,
      [int startPosition = 0])
      : _list = fixedLengthList,
        this.stepSize = stepSize <= 0 ? 1 : stepSize,
        _fixedListLength = fixedLengthList.length,
        _position = startPosition < 0 ? -stepSize : startPosition - stepSize;

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
  /// [FastStrideIterator] should be used for iterating *fixed* length lists.
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
