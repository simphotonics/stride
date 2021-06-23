/// Iterates an [Iterable] using a positive non-zero step size and
/// a custom start index.
///
/// Concurrent modification is checked
/// prior to advancing the iterator.
class StrideIterator<E> implements Iterator<E> {
  /// Constructs an object of type [StrideIterator].
  /// * [iterable]: An iterable with entries of type `E`.
  /// * [stepSize]: The iteration stride (step size). Must be larger than zero.
  /// * [startIndex]: If [startIndex] is a valid list index
  /// then the first element returned by the getter `current` (after initially
  /// advancing the iterator) will be: `iterable.elementAt(startIndex)`.
  StrideIterator(Iterable<E> iterable, int stepSize, [int startIndex = 0])
      : _iterable = iterable,
        this.stepSize = stepSize <= 0 ? 1 : stepSize,
        _length = iterable.length,
        _position = startIndex < 0 ? -stepSize : startIndex - stepSize;

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

/// Iterates an [Iterable] using a negative non-zero step size and
/// a custom start index.
///
/// Concurrent modification is checked
/// prior to advancing the iterator.
class ReverseStrideIterator<E> implements Iterator<E> {
  /// Constructs an object of type [ReverseStrideIterator].
  /// * [iterable]: An iterable with entries of type `E`.
  /// * [stepSize]: The iteration stride (step size). Must be smaller than zero.
  /// * [startIndex]: If [startIndex] is a valid list index
  /// then the first element returned by the getter [current] (after initially
  /// advancing the iterator) will be: `iterable.elementAt(startIndex)`.
  ReverseStrideIterator(Iterable<E> iterable, int stepSize,
      [int startIndex = 0])
      : _iterable = iterable,
        this.stepSize = stepSize >= 0 ? -1 : stepSize,
        _length = iterable.length {
    _position = startIndex > _length - 1
        ? _length - 1 - this.stepSize
        : startIndex - this.stepSize;
  }

  /// The iterable being iterated.
  final Iterable<E> _iterable;

  /// The length of `_iterable`.
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
    if (_length != _iterable.length) {
      throw ConcurrentModificationError(_iterable);
    }
    if (_position >= 0) {
      _current = _iterable.elementAt(_position);
      return true;
    } else {
      _current = null;
      _position = -1;
      return false;
    }
  }
}
