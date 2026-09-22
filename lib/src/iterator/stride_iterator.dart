/// Iterates an [Iterable] using a positive non-zero step size and
/// a custom start index.
///
/// Concurrent modification is checked
/// prior to advancing the iterator.
abstract class StrideIterator<E>(
  /// The iterable being iterated.
  final Iterable<E> _iterable,

  /// The iteration stride (step size). Must be larger than zero.
  int stepSize, [

  /// If `startIndex` is a valid index of the iterable,
  /// then the first element returned by the getter [current], after initially
  /// advancing the iterator, will be: `iterable.elementAt(startIndex)`.
  int startIndex = 0,
]) implements Iterator<E> {
  this
    : stepSize = stepSize <= 0 ? 1 : stepSize,
      _length = _iterable.length,
      _position = startIndex < 0 ? -stepSize : startIndex - stepSize;

  /// The length of [_iterable].
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
  bool moveNext();
}

/// Iterates an Iterable using a positive non-zero step size
/// and a custom start index.
class CheckedStrideIterator<E>(
  super.iterable,

  /// The iteration stride (step size). Must be larger than zero.
  super.stepSize, [

  /// If `startIndex` is a valid index of the iterable,
  /// then the first element returned by the getter [current], after initially
  /// advancing the iterator, will be: `iterable.elementAt(startIndex)`.
  super.startIndex = 0,
]) extends StrideIterator<E> {
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

/// Iterates an Iterable using a positive non-zero step size
/// and a custom start index.
///
/// Note: Concurrent modification is *not* checked
/// prior to advancing the iterator. It is assumed that the list length does
/// not change. Should be used to iterate *fixed* length lists.
class UncheckedStrideIterator<E>(
  super.iterable,

  /// The iteration stride (step size). Must be larger than zero.
  super.stepSize, [

  /// If `startIndex` is a valid index of the iterable,
  /// then the first element returned by the getter [current], after initially
  /// advancing the iterator, will be: `iterable.elementAt(startIndex)`.
  super.startIndex = 0,
]) extends StrideIterator<E> {
  /// Moves the iterator to the next element.
  ///
  /// Must be called before accessing the first element. If this method returns
  /// `true` it is safe to access the [current] element.
  ///
  /// Concurrent modification is *not* checked before advancing the iterator.
  /// [UncheckedStrideIterator] should be used for iterating *fixed*
  /// length iterables.
  @override
  bool moveNext() {
    _position += stepSize;
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
