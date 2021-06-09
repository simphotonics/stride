/// Iterates an [Iterable] using a custom stride (step size) and
/// offset. The iterator is initially positioned at `offset - stride`.
///
/// Note: Concurrent modification is checked
/// prior to advancing the iterator.
class StrideIterator<E> implements Iterator<E> {
  /// Constructs an object of type `StrideIterator`.
  /// * `iterable`: An iterable with entries of type `E`.
  /// * `stride`: The iteration stride (step size).
  /// * `offset`: Must be a valid index of `iterable`.
  /// `0 <= offset < iterable.length`.
  StrideIterator(Iterable<E> iterable, int stride, [int offset = 0])
      : _iterable = iterable,
        _stride = stride,
        _length = iterable.length,
        _position = offset < 0 ? -stride : offset - stride;

  /// The iterable being iterated.
  final Iterable<E> _iterable;

  /// The length of `_iterable`.
  final int _length;

  /// The current position.
  int _position;

  /// The iteration stride.
  final int _stride;

  /// The current element.
  E? _current;

  @override
  E get current => _current as E;

  @override
  bool moveNext() {
    _position += _stride;
    if (_length != _iterable.length) {
      throw ConcurrentModificationError(_iterable);
    }
    if (_position < _length) {
      _current = _iterable.elementAt(_position);
      return true;
    } else {
      _current = null;
      _position = _length;
      return false;
    }
  }
}
