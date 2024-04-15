/// Iterates an [Iterable] using a negative non-zero step size and
/// a custom start index.
///
/// Concurrent modification is checked
/// prior to advancing the iterator.
abstract class ReverseStrideIterator<E> implements Iterator<E> {
  /// Constructs an object of type [ReverseStrideIterator].
  /// * [iterable]: An iterable with entries of type `E`.
  /// * [stepSize]: The iteration stride (step size). Must be smaller than zero.
  /// * [startIndex]: If [startIndex] is a valid list index
  /// then the first element returned by the getter [current] (after initially
  /// advancing the iterator) will be: `iterable.elementAt(startIndex)`.
  ReverseStrideIterator(Iterable<E> iterable, int stepSize,
      [int startIndex = 0])
      : _iterable = iterable,
        stepSize = stepSize >= 0 ? -1 : stepSize,
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
  bool moveNext();
}

/// Iterates an [Iterable] using a negative non-zero step size and
/// a custom start index.
///
/// Concurrent modification is *not* checked
/// prior to advancing the iterator.
class CheckedReverseStrideIterator<E> extends ReverseStrideIterator<E> {
  /// Constructs an object of type [ReverseUncheckedStrideIterator].
  /// * [iterable]: An iterable with entries of type `E`.
  /// * [stepSize]: The iteration stride (step size). Must be smaller than zero.
  /// * [startIndex]: If [startIndex] is a valid list index
  /// then the first element returned by the getter [current] (after initially
  /// advancing the iterator) will be: `iterable.elementAt(startIndex)`.
  CheckedReverseStrideIterator(super.iterable, super.stepSize,
      [super.startIndex = 0]);

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

/// Iterates an [Iterable] using a negative non-zero step size and
/// a custom start index.
///
/// Concurrent modification is *not* checked
/// prior to advancing the iterator.
class ReverseUncheckedStrideIterator<E> extends ReverseStrideIterator<E> {
  /// Constructs an object of type [ReverseUncheckedStrideIterator].
  /// * [iterable]: An iterable with entries of type `E`.
  /// * [stepSize]: The iteration stride (step size). Must be smaller than zero.
  /// * [startIndex]: If [startIndex] is a valid list index
  /// then the first element returned by the getter [current] (after initially
  /// advancing the iterator) will be: `iterable.elementAt(startIndex)`.
  ReverseUncheckedStrideIterator(super.iterable, super.stepSize,
      [super.startIndex = 0]);

  @override
  bool moveNext() {
    _position += stepSize;
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
