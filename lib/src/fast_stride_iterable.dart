import 'fast_stride_iterator.dart';

/// An `Iterable` backed by a *fixed* length list. The start
/// index and the stride can be specified.
class FastStrideIterable<E> extends Iterable<E> {
  /// Constructs a object of type [FastStrideIterable].
  /// * `fixedLengthList`: A list with fixed length and entries of type `E`.
  /// * `stride`: The iteration stride (step size).
  /// * `offset`: If `offset` is a valid list index, the first element of the iterable
  /// will be: `fixedLengthList[offset]`.
  FastStrideIterable(List<E> fixedLengthList, this.stride, [int offset = 0])
      : _list = fixedLengthList,
        _listLength = fixedLengthList.length,
        _length = offset < 0
            ? fixedLengthList.length
            : offset > fixedLengthList.length
                ? 0
                : ((fixedLengthList.length - offset.abs()) / stride).ceil(),
        _offset = offset < 0 ? 0 : offset;

  /// The list that is iterated.
  final List<E> _list;

  /// The stride used to iterate elements.
  final int stride;

  /// Optional parameter used to specify an non-zero start index.
  int _offset;

  /// The length of the iterable.
  int _length;

  /// The length of backing list.
  final int _listLength;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  FastStrideIterator<E> get iterator =>
      FastStrideIterator<E>(_list, stride, _offset);

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
    _offset = index.abs();
    _length = (_listLength - _offset) < 0
        ? 0
        : ((_listLength - _offset) / stride).ceil();
  }

  @override
  E elementAt(int index) {
    if (index < 0 || index >= _length) {
      throw RangeError.range(index, 0, length - 1);
    }
    return _list[_offset + index * stride];
  }
}
