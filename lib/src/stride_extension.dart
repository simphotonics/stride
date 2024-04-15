import 'package:exception_templates/exception_templates.dart';

import 'stride_iterator.dart';
import 'reverse_stride_iterator.dart';

void _throwError<E>() {
  throw ErrorOf<Iterable<E>>(
      message: 'Error in method <stride>.',
      invalidState: 'Found: stepSize = 0.',
      expectedState: 'Parameter <stepSize> must not be zero.');
}

class _FastStrideIterable<E> with Iterable<E> {
  /// Constructs a object of type [_FastStrideIterable].
  /// * [_iterable]: An iterable with entries of type `E`.
  /// * [stepSize]: The iteration stride (step size). Must be larger than 0.
  /// * [startIndex]: If [startIndex] is a valid index the
  /// first element of `this` will be: `elementAt.(startIndex)`.
  _FastStrideIterable(Iterable<E> iterable, this.stepSize, [int startIndex = 0])
      : _iterable = iterable,
        startIndex = startIndex < 0 ? 0 : startIndex {
    length = startIndex > iterable.length
        ? 0
        : ((iterable.length - startIndex) / stepSize).ceil();
  }

  /// The iterable that is being iterated.
  final Iterable<E> _iterable;

  /// The stride used to iterate elements.
  final int stepSize;

  /// Parameter used to specify an non-zero start index.
  final int startIndex;

  /// The length of the iterable.
  @override
  late final int length;

  @override
  UncheckedStrideIterator<E> get iterator =>
      UncheckedStrideIterator<E>(_iterable, stepSize, startIndex);

  @override
  E elementAt(int index) {
    if (index < 0 || index >= length) {
      throw RangeError.range(index, 0, length - 1);
    }
    return _iterable.elementAt(startIndex + index * stepSize);
  }
}

class _ReverseFastStrideIterable<E> with Iterable<E> {
  /// Constructs a object of type [_FastStrideIterable].
  /// * [iterable]: An iterable with entries of type `E`.
  /// * [stepSize]: The iteration stride (step size). Must be smaller than 0.
  /// * [startIndex]: If [startIndex] is a valid index the
  /// first element of `this` will be: `this.elementAt(startIndex)`.
  _ReverseFastStrideIterable(Iterable<E> iterable, this.stepSize,
      [int startIndex = 0])
      : _iterable = iterable,
        startIndex =
            startIndex > iterable.length ? iterable.length - 1 : startIndex {
    if (_iterable.isEmpty || startIndex < 0) {
      length = 0;
    } else {
      length = ((startIndex + 1) / stepSize.abs()).ceil();
    }
  }

  /// The iterable that is being iterated.
  final Iterable<E> _iterable;

  /// The stride used to iterate elements.
  final int stepSize;

  /// Parameter used to specify an non-zero start index.
  final int startIndex;

  /// The length of the iterable.
  @override
  late final int length;

  @override
  ReverseUncheckedStrideIterator<E> get iterator =>
      ReverseUncheckedStrideIterator<E>(_iterable, stepSize, startIndex);

  @override
  E elementAt(int index) {
    if (index < 0 || index >= length) {
      throw RangeError.range(index, 0, length - 1);
    }
    return _iterable.elementAt(startIndex + index * stepSize);
  }
}

/// An `Iterable` with a customizable stride and startIndex.
class _StrideIterable<E> with Iterable<E> {
  /// Constructs a object of type [_StrideIterable].
  /// * `iterable`: An iterable with entries of type `E`.
  /// * `stepSize`: The iteration stride (step size). Must be larger than 0.
  /// * `startIndex`:

  _StrideIterable(Iterable<E> iterable, this.stepSize, [int startIndex = 0])
      : _iterable = iterable,
        startIndex = startIndex < 0 ? 0 : startIndex {
    length = startIndex > iterable.length
        ? 0
        : ((iterable.length - startIndex) / stepSize).ceil();
  }

  /// The iterable being iterated.
  final Iterable<E> _iterable;

  /// The stride (step-size) used to iterate elements.
  final int stepSize;

  /// Parameter used to specify a non-zero start index.
  final int startIndex;

  /// The length of the iterable.
  @override
  late final int length;

  @override
  bool get isNotEmpty => !isEmpty;

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

/// A reverse `Iterable` with a customizable start
/// index and step size.
class _ReverseStrideIterable<E> with Iterable<E> {
  /// Constructs a object of type [_ReverseStrideIterable].
  /// * [iterable]: An iterable with entries of type `E`.
  /// * [stepSize]: The iteration stride (step size). Must be smaller than 0.
  /// * [startIndex]: If [startIndex] is a valid index the
  /// first element of `this` will be: `this.elementAt(startIndex)`.
  _ReverseStrideIterable(Iterable<E> iterable, this.stepSize,
      [int startIndex = 0])
      : _iterable = iterable,
        startIndex = startIndex > iterable.length - 1
            ? iterable.length - 1
            : startIndex {
    if (iterable.isEmpty || startIndex < 0) {
      length = 0;
    } else {
      length = ((startIndex + 1) / stepSize.abs()).ceil();
    }
  }

  /// The iterable that is being iterated.
  final Iterable<E> _iterable;

  /// The stride used to iterate elements.
  final int stepSize;

  /// Parameter used to specify an non-zero start index.
  final int startIndex;

  /// The length of the iterable.
  @override
  late final int length;

  @override
  ReverseStrideIterator<E> get iterator =>
      CheckedReverseStrideIterator<E>(_iterable, stepSize, startIndex);

  @override
  E elementAt(int index) {
    if (index < 0 || index >= length) {
      throw RangeError.range(index, 0, length - 1);
    }
    return _iterable.elementAt(startIndex + index * stepSize);
  }
}

/// Extension on `Iterable<E>` providing the method `stride`.
extension Stride<E> on Iterable<E> {
  /// Returns an `Iterable<E>` which iterates `this` using a custom `stepSize`
  /// and starting from `startIndex`.
  /// * If `startIndex` is a valid index then the
  /// first element of the iterable will be: `this.elementAt(startIndex)`.
  /// * The parameter `stepSize` must not be zero.
  Iterable<E> stride(int stepSize, [int startIndex = 0]) {
    if (stepSize == 0) {
      _throwError<E>();
    }
    return stepSize > 0
        ? _StrideIterable<E>(this, stepSize, startIndex)
        : _ReverseStrideIterable(this, stepSize, startIndex);
  }
}

/// Extension providing the method `fastStride`.
/// Note: The backing iterable should be immutable or fixed length since
/// concurrent modification is not checked.
extension FastStride<E> on Iterable<E> {
  /// Returns an `Iterable<E>` which iterates `this` using a custom `stepSize`
  /// and starting from `startIndex`.
  /// * If `startIndex` is a valid index then the
  /// first element of the iterable will be: `elementAt(startIndex)`.
  /// * The parameter `stepSize` must not be zero.
  /// * This method does not check for concurrent modification.
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
