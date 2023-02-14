import 'dart:typed_data';

import 'package:benchmark/benchmark.dart';
import 'package:stride/stride.dart';

final nRows = 1000000;
final nCols = 10;
final stepSize = nCols;
final startIndex = 4;

final array2d = List<List<double>>.generate(
  nRows,
  (i) => List<double>.generate(nCols, (j) => (nCols * i + j).toDouble()),
);
final list = List<double>.generate(
  nRows * nCols,
  (i) => i.toDouble(),
  growable: true,
);
final typedList = Float64List.fromList(list);
final typedListIt = typedList.fastStride(stepSize, startIndex);
final listFastIt = list.fastStride(stepSize, startIndex);
final listIt = list.stride(stepSize, startIndex);

var tmp = 0.0;

void main() {

  group('column_4:', () {
    benchmark('array2d[i][4]', () {
      // ignore: unused_local_variable
      var column_4 = [
        for (var i = 0; i < array2d.length; i++) tmp = array2d[i][startIndex]
      ];
    }, duration: Duration(milliseconds: 1000));
    benchmark('list iterator checked', () {
      for (var element in listIt) {
        tmp = element;
      }
    }, duration: Duration(milliseconds: 1000));
    benchmark('list iterator', () {
      for (var element in listFastIt) {
        tmp = element;
      }
    }, duration: Duration(milliseconds: 1000));
    benchmark('typed list iterator', () {
      for (var element in typedListIt) {
        tmp = element;
      }
    }, duration: Duration(milliseconds: 1000));
  });
}
