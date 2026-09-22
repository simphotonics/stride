import 'package:exception_templates/exception_templates.dart' show ErrorOf;

import '../iterator/stride_iterator.dart';
import '../iterator/reverse_stride_iterator.dart';

void _throwError<E>() {
  throw ErrorOf<Iterable<E>>(
    message: 'Error in method <stride>.',
    invalidState: 'Found: stepSize = 0.',
    expectedState: 'Parameter <stepSize> must not be zero.',
  );
}

class _StrideIterable<E>(
  /// The iterable that is being iterated.
  final Iterable<E> _iterable,

  /// The stride used to iterate elements.
  int stepSize, [

  /// If [startIndex] is a valid index then the
  /// first element of `this` will be: `_iterable.elementAt(startIndex)`.
  int startIndex = 0,
]) with Iterable<E> {
  this
    : startIndex = startIndex < 0 ? 0 : startIndex,
      stepSize = stepSize <= 0 ? 1 : stepSize;

  /// If [startIndex] is a valid index of `iterable`, then the first
  /// element of `this` will be the element of `iterable at` [startIndex].
  final int startIndex;

  /// The iteration stride or step size.
  final int stepSize;

  /// The length of [_iterable].
  late final _length = _iterable.length;

  /// The length of the iterable.
  @override
  late final int length = startIndex > _length
      ? 0
      : ((_length - startIndex) / stepSize).ceil();

  @override
  StrideIterator<E> get iterator =>
      CheckedStrideIterator<E>(_iterable, stepSize, startIndex);

  @override
  E elementAt(int index) {
    if (index < 0 || index >= length) {
      throw RangeError.range(index, 0, length - 1);
    }
    return _iterable.elementAt(startIndex + index * stepSize);
  }
}

class _FastStrideIterable<E>(
  super.iterable,
  super.stepSize, [
  super.startIndex = 0,
]) extends _StrideIterable<E> {
  @override
  StrideIterator<E> get iterator =>
      UncheckedStrideIterator<E>(_iterable, stepSize, startIndex);
}

class _ReverseStrideIterable<E>(
  /// The iterable that is being iterated.
  final Iterable<E> _iterable,

  /// The stride used to iterate elements. Must be smaller than 0.
  int stepSize, [

  /// Parameter used to specify the start index.
  int startIndex = 0,
]) with Iterable<E> {
  this
    : startIndex = startIndex > _iterable.length
          ? _iterable.length - 1
          : startIndex,
      stepSize = (stepSize >= 0) ? -1 : stepSize;

  /// The index of the first element
  final int startIndex;

  /// The stride or step size used to iterate [_iterable].
  final int stepSize;

  /// The length of the iterable.
  @override
  late final int length = (_iterable.isEmpty || startIndex < 0)
      ? 0
      : ((startIndex + 1) / stepSize.abs()).ceil();

  @override
  ReverseStrideIterator<E> get iterator =>
      CheckedReverseStrideIterator(_iterable, stepSize, startIndex);

  @override
  E elementAt(int index) {
    if (index < 0 || index >= length) {
      throw RangeError.range(index, 0, length - 1);
    }
    return _iterable.elementAt(startIndex + index * stepSize);
  }
}

class _ReverseFastStrideIterable<E>(
  super.iterable,
  super.stepSize, [
  super.startIndex = 0,
]) extends _ReverseStrideIterable<E> {
  @override
  ReverseStrideIterator<E> get iterator =>
      ReverseUncheckedStrideIterator(_iterable, stepSize, startIndex);
}

/// Extension on [Iterable] providing the method [stride].
extension Stride<E> on Iterable<E> {
  /// Returns an [Iterable] which iterates `this` using a custom [stepSize]
  /// and starting from [startIndex].
  /// * If [startIndex] is a valid index then the
  /// first element of the iterable will be: `this.elementAt(startIndex)`.
  /// * The parameter [stepSize] must not be zero.
  Iterable<E> stride(int stepSize, [int startIndex = 0]) {
    if (stepSize == 0) {
      _throwError<E>();
    }
    return stepSize > 0
        ? _StrideIterable<E>(this, stepSize, startIndex)
        : _ReverseStrideIterable(this, stepSize, startIndex);
  }
}

/// Extension on [Iterable] providing the method [fastStride].
/// Note: The backing iterable should be immutable or have fixed length since
/// concurrent modification is not checked.
extension FastStride<E> on Iterable<E> {
  /// Returns an [Iterable] which iterates `this` using a custom [stepSize]
  /// and starting from [startIndex].
  /// * If [startIndex] is a valid index then the
  /// first element of the iterable will be: `elementAt(startIndex)`.
  /// * The parameter [stepSize] must not be zero.
  /// * This method does **not** check for concurrent modification.
  /// * Should be used with fixed length or immutable iterables.
  Iterable<E> fastStride(int stepSize, [int startIndex = 0]) {
    if (stepSize == 0) {
      _throwError<E>();
    }
    return stepSize > 0
        ? _FastStrideIterable<E>(this, stepSize, startIndex)
        : _ReverseFastStrideIterable(this, stepSize, startIndex);
  }
}
