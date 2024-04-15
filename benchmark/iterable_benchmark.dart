// ignore_for_file: unused_local_variable

import 'package:benchmark_runner/benchmark_runner.dart';
import 'package:stride/stride.dart';

void main() {
  final nRows = 1000000;
  final nCols = 10;
  final stepSize = nCols;
  final startIndex = 4;

// final array2d = List<List<double>>.generate(
//   nRows,
//   (i) => List<double>.generate(nCols, (j) => (nCols * i + j).toDouble()),
// );
  final list = List<double>.generate(
    nRows * nCols,
    (i) => i.toDouble(),
    growable: true,
  );
  final listFastIterator = list.fastStride(stepSize, startIndex);
  final listIterator = list.stride(stepSize, startIndex);

  List<double> column4;

  group('column4:', () {
    benchmark('list iterator checked', () {
      column4 = listIterator.toList();
    });
    benchmark('list iterator unchecked', () {
      column4 = listFastIterator.toList();
    });
  });
}
