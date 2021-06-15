import 'dart:typed_data';
import 'package:stride/stride.dart';

final nRows = 10;
final nCols = 5;
final stepSize = nCols;
final startPosition = 4;

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

final listFastIt = list.stride(stepSize, startPosition, false);
final typedListFastIt = typedList.stride(stepSize, startPosition, false);

final listIt = list.stride(stepSize, startPosition);
final typedListIt = typedList.stride(stepSize, startPosition);

var tmp = 0.0;

void main() {
  print(array2d);
  print(list);

  print('');
  print(listFastIt);
  print(typedListFastIt.toList());

  var column_4 = [
    for (var i = 0; i < array2d.length; i++) tmp = array2d[i][startPosition]
  ];

  print(column_4);
}
