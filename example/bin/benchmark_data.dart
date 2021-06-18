import 'dart:typed_data';
import 'package:stride/stride.dart';

final nRows = 10;
final nCols = 5;
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

final listFastIt = list.stride(stepSize, startIndex, false);
final typedListFastIt = typedList.stride(stepSize, startIndex, false);

final listIt = list.stride(stepSize, startIndex);
final typedListIt = typedList.stride(stepSize, startIndex);

var tmp = 0.0;

void main() {
  print(array2d);
  print(list);

  print('');
  print(listFastIt);
  print(typedListFastIt);

  var column_4 = [
    for (var i = 0; i < array2d.length; i++) tmp = array2d[i][startIndex]
  ];

  print(column_4);
}
