import 'dart:typed_data';

import 'package:benchmark/benchmark.dart';
import 'package:stride/stride.dart';

extension StrideII<E> on Iterable<E> {
  Iterable<E> strideII(int stepSize, int startIndex) {
    var counter = 0;
    return this.skip(startIndex).skipWhile((_) {
      if (counter == 0) {
        ++counter;
        return true;
      } else if (counter == stepSize - 1) {
        counter = 0;
        return false;
      } else {
        ++counter;
        return false;
      }
    });
  }
}

final nRows = 100000;
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
  growable: false,
);
final typedList = Float64List.fromList(list);

final typedListIt = typedList.stride(stepSize, startIndex, false);
final listFastIt = list.stride(stepSize, startIndex, false);
final listIt = list.stride(stepSize, startIndex);

var tmp = 0.0;

void main() {
  setUp(() {});

  group('column_49:', () {
    benchmark('array2d[i][4]', () {
      // ignore: unused_local_variable
      var column_49 = [
        for (var i = 0; i < array2d.length; i++) tmp = array2d[i][startIndex]
      ];
    }, duration: Duration(milliseconds: 600));
    benchmark('list iterator checked', () {
      for (var element in listIt) {
        tmp = element;
      }
    }, duration: Duration(milliseconds: 600));
    benchmark('list iterator', () {
      for (var element in listFastIt) {
        tmp = element;
      }
    }, duration: Duration(milliseconds: 600));
    benchmark('typed list iterator', () {
      for (var element in typedListIt) {
        tmp = element;
      }
    }, duration: Duration(milliseconds: 600));
  });
}
