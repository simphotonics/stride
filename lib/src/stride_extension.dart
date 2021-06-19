import 'fast_stride_iterator.dart';
import 'stride_iterator.dart';

/// An `Iterable` backed by a *fixed* length list. The start
/// index and the step size can be specified.
class _FastStrideIterable<E> extends Iterable<E> {
  /// Constructs a object of type [_FastStrideIterable].
  /// * `fixedLengthList`: A list with fixed length and entries of type `E`.
  /// * `stepSize`: The iteration stride (step size). Must be larger than 0.
  /// * `startIndex`: If `startIndex` is a valid list index,
  /// the first element of the iterable
  /// will be: `fixedLengthList[startIndex]`.
  _FastStrideIterable(List<E> fixedLengthList, this.stepSize,
      [int startIndex = 0])
      : _list = fixedLengthList,
        length = startIndex < 0
            ? fixedLengthList.length
            : startIndex > fixedLengthList.length
                ? 0
                : ((fixedLengthList.length - startIndex.abs()) / stepSize)
                    .ceil(),
        this.startIndex = startIndex < 0 ? 0 : startIndex;

  /// The list that is iterated.
  final List<E> _list;

  /// The stride used to iterate elements.
  final int stepSize;

  /// Parameter used to specify an non-zero start index.
  int startIndex;

  /// The length of the iterable.
  final int length;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  FastStrideIterator<E> get iterator =>
      FastStrideIterator<E>(_list, stepSize, startIndex);

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
  /// Constructs a object of type `StrideIterable`.
  /// * `iterable`: An iterable with entries of type `E`.
  /// * `stepSize`: The iteration stride (step size). Must be larger than 0.
  /// * `startIndex`:  If `startIndex` is a valid index,
  /// the first element of the iterable
  /// will be: `fixedLengthList.elementAt(startIndex)`.

  _StrideIterable(Iterable<E> iterable, this.stepSize, [int startIndex = 0])
      : _iterable = iterable,
        length = startIndex < 0
            ? iterable.length
            : startIndex > iterable.length
                ? 0
                : ((iterable.length - startIndex.abs()) / stepSize).ceil(),
        this.startIndex = startIndex < 0 ? 0 : startIndex;

  /// The iterable being iterated.
  final Iterable<E> _iterable;

  /// The stride (step-size) used to iterate elements.
  final int stepSize;

  /// Parameter used to specify a non-zero start index.
  int startIndex;

  /// The length of the iterable.
  final int length;

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

/// Extension on `Iterable<E>` providing the method `stride`.
extension Stride<E> on Iterable<E> {
  /// Returns an `Iterable<E>` which iterates `this` starting from
  /// `startIndex` using a custom `stepSize`.
  ///
  /// Note: The parameter `stepSize` must be larger than zero.
  Iterable<E> stride(int stepSize, [int startIndex = 0]) =>
      _StrideIterable<E>(this, stepSize, startIndex);
}

/// Extension on `List<E>` providing the method `stride`.
extension FastStride<E> on List<E> {
  /// Returns an `Iterable<E>` which iterates `this` starting from
  /// `startIndex` using a custom `stepSize`.
  /// * The parameter `stepSize` must be larger than zero.
  /// * Checking for concurrent modification is enabled by default.
  /// * Iterating fixed length lists can be sped up by setting
  /// `checkConcurrentModification` to `false`.
  Iterable<E> stride(
    int stepSize, [
    int startIndex = 0,
    bool checkConcurrentModification = true,
  ]) =>
      checkConcurrentModification
          ? _StrideIterable(this, stepSize, startIndex)
          : _FastStrideIterable<E>(this, stepSize, startIndex);
}
