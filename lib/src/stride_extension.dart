import 'package:exception_templates/exception_templates.dart';

import 'stride_iterator.dart';
import 'unchecked_stride_iterator.dart';

void _throwError<E>() {
  throw ErrorOf<Iterable<E>>(
      message: 'Error in method <stride>.',
      invalidState: 'Found: stepSize = 0.',
      expectedState: 'Parameter <stepSize> must not be zero.');
}

/// An `Iterable` backed by a *fixed* length list. The start
/// index and the step size can be specified.
class _FastStrideIterable<E> extends Iterable<E> {
  /// Constructs a object of type [_FastStrideIterable].
  /// * [fixedLengthList]: A list with fixed length and entries of type `E`.
  /// * [stepSize]: The iteration stride (step size). Must be larger than 0.
  /// * [startIndex]: If [startIndex] is a valid list index the
  /// first element of `this` will be: `fixedLengthList[startIndex]`.
  _FastStrideIterable(List<E> fixedLengthList, this.stepSize,
      [int startIndex = 0])
      : _list = fixedLengthList,
        this.startIndex = startIndex < 0 ? 0 : startIndex {
    length = startIndex > fixedLengthList.length
        ? 0
        : ((fixedLengthList.length - startIndex) / stepSize).ceil();
  }

  /// The list that is iterated.
  final List<E> _list;

  /// The stride used to iterate elements.
  final int stepSize;

  /// Parameter used to specify an non-zero start index.
  final int startIndex;

  /// The length of the iterable.
  late final int length;

  @override
  UncheckedStrideIterator<E> get iterator =>
      UncheckedStrideIterator<E>(_list, stepSize, startIndex);

  @override
  E elementAt(int index) {
    if (index < 0 || index >= length) {
      throw RangeError.range(index, 0, length - 1);
    }
    return _list[startIndex + index * stepSize];
  }
}

/// An `Iterable` backed by a *fixed* length list. The start
/// index and the step size can be specified.
class _ReverseFastStrideIterable<E> extends Iterable<E> {
  /// Constructs a object of type [_FastStrideIterable].
  /// * [fixedLengthList]: A list with fixed length and entries of type `E`.
  /// * [stepSize]: The iteration stride (step size). Must be smaller than 0.
  /// * [startIndex]: If [startIndex] is a valid list index the
  /// first element of `this` will be: `fixedLengthList[startIndex]`.
  _ReverseFastStrideIterable(List<E> fixedLengthList, this.stepSize,
      [int startIndex = 0])
      : _list = fixedLengthList,
        this.startIndex = startIndex > fixedLengthList.length
            ? fixedLengthList.length - 1
            : startIndex {
    if (_list.length == 0 || startIndex < 0) {
      length = 0;
    } else {
      length = ((startIndex + 1) / stepSize.abs()).ceil();
    }
  }

  /// The list that is iterated.
  final List<E> _list;

  /// The stride used to iterate elements.
  final int stepSize;

  /// Parameter used to specify an non-zero start index.
  final int startIndex;

  /// The length of the iterable.
  late final int length;

  @override
  ReverseUncheckedStrideIterator<E> get iterator =>
      ReverseUncheckedStrideIterator<E>(_list, stepSize, startIndex);

  @override
  E elementAt(int index) {
    if (index < 0 || index >= length) {
      throw RangeError.range(index, 0, length - 1);
    }
    return _list[startIndex + index * stepSize];
  }
}

/// An `Iterable` with a customizable stride and offset.
class _StrideIterable<E> extends Iterable<E> {
  /// Constructs a object of type [_StrideIterable].
  /// * `iterable`: An iterable with entries of type `E`.
  /// * `stepSize`: The iteration stride (step size). Must be larger than 0.
  /// * `startIndex`:

  _StrideIterable(Iterable<E> iterable, this.stepSize, [int startIndex = 0])
      : _iterable = iterable,
        this.startIndex = startIndex < 0 ? 0 : startIndex {
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
  late final int length;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  StrideIterator<E> get iterator =>
      StrideIterator<E>(_iterable, stepSize, startIndex);

  @override
  E elementAt(int index) {
    if (index < 0 || index >= length) {
      throw RangeError.range(index, 0, length - 1);
    }
    return _iterable.elementAt(startIndex + index * stepSize);
  }
}

/// An `Iterable` backed by a *fixed* length list. The start
/// index and the step size can be specified.
class _ReverseStrideIterable<E> extends Iterable<E> {
  /// Constructs a object of type [_ReverseStrideIterable].
  /// * [fixedLengthList]: A list with fixed length and entries of type `E`.
  /// * [stepSize]: The iteration stride (step size). Must be smaller than 0.
  /// * [startIndex]: If [startIndex] is a valid list index the
  /// first element of `this` will be: `fixedLengthList[startIndex]`.
  _ReverseStrideIterable(Iterable<E> iterable, this.stepSize,
      [int startIndex = 0])
      : _iterable = iterable,
        this.startIndex = startIndex > iterable.length - 1
            ? iterable.length - 1
            : startIndex {
    if (iterable.length == 0 || startIndex < 0) {
      length = 0;
    } else {
      length = ((startIndex + 1) / stepSize.abs()).ceil();
    }
  }

  /// The list that is being iterated.
  final Iterable<E> _iterable;

  /// The stride used to iterate elements.
  final int stepSize;

  /// Parameter used to specify an non-zero start index.
  final int startIndex;

  /// The length of the iterable.
  late final int length;

  @override
  ReverseStrideIterator<E> get iterator =>
      ReverseStrideIterator<E>(_iterable, stepSize, startIndex);

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
  /// Returns an `Iterable<E>` which iterates `this` using a custom [stepSize]
  /// and starting from [startIndex].
  /// * If [startIndex] is a valid list index then the
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

/// Extension on `List<E>` providing the method `stride`.
extension FastStride<E> on List<E> {
  /// Returns an `Iterable<E>` which iterates `this` using a custom [stepSize]
  /// and starting from [startIndex].
  /// * If [startIndex] is a valid list index then the
  /// first element of the iterable will be: `this[startIndex]`.
  /// * The parameter [stepSize] must not be zero.
  /// * Checking for concurrent modification is enabled by default.
  /// * Iterating fixed length lists can be sped up by setting the parameter
  /// `checkConcurrentModification` to `false`.
  Iterable<E> stride(
    int stepSize, [
    int startIndex = 0,
    bool checkConcurrentModification = true,
  ]) {
    if (stepSize == 0) {
      _throwError<E>();
    }
    if (checkConcurrentModification) {
      return stepSize > 0
          ? _StrideIterable<E>(this, stepSize, startIndex)
          : _ReverseStrideIterable(this, stepSize, startIndex);
    } else {
      return stepSize > 0
          ? _FastStrideIterable<E>(this, stepSize, startIndex)
          : _ReverseFastStrideIterable(this, stepSize, startIndex);
    }
  }
}
