import 'stride_iterator.dart';

/// An `Iterable` with a customizable stride and offset.
class StrideIterable<E> extends Iterable<E> {
  /// Constructs a object of type `StrideIterable`.
  /// * `iterable`: An iterable with entries of type `E`.
  /// * `stride`: The iteration stride (step size).
  /// * `offset`: Must be a valid list index.
  ///  `0 <= offset < iterable.length`.
  StrideIterable(Iterable<E> iterable, this.stride, [int offset = 0])
      : _iterable = iterable,
        _iterableLength = iterable.length,
        _length = offset < 0
            ? iterable.length
            : offset > iterable.length
                ? 0
                : ((iterable.length - offset.abs()) / stride).ceil(),
        _offset = offset < 0 ? 0 : offset;

  /// The iterable being iterated.
  final Iterable<E> _iterable;

  /// The stride (step-size) used to iterate elements.
  final int stride;

  /// Optional parameter used to specify a  non-zero start index.
  int _offset;

  /// The length of the iterable.
  int _length;

  /// The length of backing list.
  final int _iterableLength;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  StrideIterator<E> get iterator =>
      StrideIterator<E>(_iterable, stride, _offset);

  @override
  int get length => _length;

  /// Specifies an offset with respect to the underlying fixed
  /// length list.
  ///
  /// If `index` is a valid index of the backing list,
  /// the first element of the iterable will
  /// be the list element at `offset`.
  /// ```
  /// // Usage
  /// final strideIt = FastStrideIterator<int>([0, 1, 2, 3, 4, 5, 6, 7, 8], 3);
  /// print(strideIt); // Prints (0, 3, 7);
  /// strideIt.offset = 2;
  /// print(strideIt) // Prints: (2, 5, 8)
  /// ```
  set offset(int index) {
    _offset = index < 0 ? 0 : index;
    _length = (_iterableLength - _offset) < 0
        ? 0
        : ((_iterableLength - _offset) / stride).ceil();
  }

  @override
  E elementAt(int index) {
    if (index < 0 || index >= _length) {
      throw RangeError.range(index, 0, length - 1);
    }
    return _iterable.elementAt(_offset + index * stride);
  }
}
