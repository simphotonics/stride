/// Iterates an [Iterable] using a custom stride (step size) and
/// start position.
///
/// Note: Concurrent modification is checked
/// prior to advancing the iterator.
class StrideIterator<E> implements Iterator<E> {
  /// Constructs an object of type `StrideIterator`.
  /// * `iterable`: An iterable with entries of type `E`.
  /// * `stepSize`: The iteration stride (step size). Must be larger than zero.
  /// * `startPosition`: If `startPosition` is a valid list index
  /// then the first element returned by the getter `current` (after initially
  /// advancing the iterator) will be: `iterable.elementAt(startPosition)`.
  StrideIterator(Iterable<E> iterable, int stepSize, [int startPosition = 0])
      : _iterable = iterable,
      this.stepSize = stepSize <= 0 ? 1: stepSize,
        _length = iterable.length,
        _position = startPosition < 0 ? -stepSize : startPosition - stepSize;

  /// The iterable being iterated.
  final Iterable<E> _iterable;

  /// The length of `_iterable`.
  final int _length;

  /// The current position.
  int _position;

  /// The iteration stride.
  final int stepSize;

  /// The current element.
  E? _current;

  @override
  E get current => _current as E;

  @override
  bool moveNext() {
    _position += stepSize;
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
