import 'package:exception_templates/exception_templates.dart';

import 'fast_stride_iterator.dart';
import 'stride_iterator.dart';

/// An `Iterable` backed by a *fixed* length list. The start
/// position and the step size can be specified.
class _FastStrideIterable<E> extends Iterable<E> {
  /// Constructs a object of type [_FastStrideIterable].
  /// * `fixedLengthList`: A list with fixed length and entries of type `E`.
  /// * `stepSize`: The iteration stride (step size). Must be larger than 0.
  /// * `startPosition`: If `startPosition` is a valid list index,
  /// the first element of the iterable
  /// will be: `fixedLengthList[startPosition]`.
  _FastStrideIterable(List<E> fixedLengthList, this.stepSize,
      [int startPosition = 0])
      : _list = fixedLengthList,
        length = startPosition < 0
            ? fixedLengthList.length
            : startPosition > fixedLengthList.length
                ? 0
                : ((fixedLengthList.length - startPosition.abs()) / stepSize)
                    .ceil(),
        this.startPosition = startPosition < 0 ? 0 : startPosition;

  /// The list that is iterated.
  final List<E> _list;

  /// The stride used to iterate elements.
  final int stepSize;

  /// Parameter used to specify an non-zero start index.
  int startPosition;

  /// The length of the iterable.
  final int length;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  FastStrideIterator<E> get iterator =>
      FastStrideIterator<E>(_list, stepSize, startPosition);

  @override
  E elementAt(int index) {
    if (index < 0 || index >= length) {
      throw RangeError.range(index, 0, length - 1);
    }
    return _list[startPosition + index * stepSize];
  }
}

/// An `Iterable` with a customizable stride and offset.
class _StrideIterable<E> extends Iterable<E> {
  /// Constructs a object of type `StrideIterable`.
  /// * `iterable`: An iterable with entries of type `E`.
  /// * `stepSize`: The iteration stride (step size). Must be larger than 0.
  /// * `startPosition`:  If `startPosition` is a valid index,
  /// the first element of the iterable
  /// will be: `fixedLengthList.elementAt(startPosition)`.

  _StrideIterable(Iterable<E> iterable, this.stepSize, [int startPosition = 0])
      : _iterable = iterable,
        length = startPosition < 0
            ? iterable.length
            : startPosition > iterable.length
                ? 0
                : ((iterable.length - startPosition.abs()) / stepSize).ceil(),
        this.startPosition = startPosition < 0 ? 0 : startPosition;

  /// The iterable being iterated.
  final Iterable<E> _iterable;

  /// The stride (step-size) used to iterate elements.
  final int stepSize;

  /// Parameter used to specify a non-zero start index.
  int startPosition;

  /// The length of the iterable.
  final int length;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  StrideIterator<E> get iterator =>
      StrideIterator<E>(_iterable, stepSize, startPosition);

  @override
  E elementAt(int index) {
    if (index < 0 || index >= length) {
      throw RangeError.range(index, 0, length - 1);
    }
    return _iterable.elementAt(startPosition + index * stepSize);
  }
}

/// Extension on `Iterable<E>` providing the method `stride`.
extension Stride<E> on Iterable<E> {
  /// Returns an `Iterable<E>` which iterates `this` starting from
  /// `startPosition` using a custom `stepSize`.
  ///
  /// Note: The parameter `stepSize` must be larger than zero.
  Iterable<E> stride(int stepSize, [int startPosition = 0]) {
    if (stepSize < 1) {
      throw ErrorOf<Iterable<E>>(
          message: 'Could not construct _StrideIterable<$E>.',
          invalidState: 'stepsize = $stepSize.',
          expectedState: 'The step size must be larger than 0.');
    }
    return _StrideIterable<E>(this, stepSize, startPosition);
  }
}

/// Extension on `List<E>` providing the method `stride`.
extension FastStride<E> on List<E> {
  /// Returns an `Iterable<E>` which iterates `this` starting from
  /// `startPosition` using a custom `stepSize`.
  /// * The parameter `stepSize` must be larger than zero.
  /// * Checking for concurrent modification is enabled by default.
  /// * Iterating fixed length lists can be sped up by setting
  /// `checkConcurrentModification` to `false`. 
  Iterable<E> stride(
    int stepSize, [
    int startPosition = 0,
    bool checkConcurrentModification = true,
  ]) {
    if (stepSize < 1) {
      throw ErrorOf<List<E>>(
          message: 'Could not construct _FastStrideIterable<$E>.',
          invalidState: 'stepsize = $stepSize.',
          expectedState: 'The step size must be larger than 0.');
    }

    return checkConcurrentModification
        ? _StrideIterable(this, stepSize, startPosition)
        : _FastStrideIterable<E>(this, stepSize, startPosition);
  }
}
