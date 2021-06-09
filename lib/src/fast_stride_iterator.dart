/// Iterates a fixed length [List] using a custom stride (step size)
/// and offset. The iterator is initial positioned at `offset - stride`.
///
/// Note: Concurrent modification is *not* checked
/// prior to advancing the iterator. It is assumed that the list length does
/// not change. Should be used to iterate *fixed* length lists.
class FastStrideIterator<E> implements Iterator<E> {
  /// Constructs an object of type `FastStrideIterator`.
  /// * `fixedLengthList`: A list with fixed length and entries of type `E`.
  /// * `stride`: The iteration stride (step size).
  /// * `offset`: Must be a valid list index.
  ///  `0 <= offset < fixedLengthList.length`.
  FastStrideIterator(List<E> fixedLengthList, int stride, [int offset = 0])
      : _list = fixedLengthList,
        _stride = stride,
        _fixedListLength = fixedLengthList.length,
        _position = offset < 0 ? -stride : offset - stride;

  /// The iterable being iterated.
  final List<E> _list;

  /// The length of the fixed length list.
  final int _fixedListLength;

  /// The current position.
  int _position;

  /// The iteration stride.
  final int _stride;

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
    _position += _stride;
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
