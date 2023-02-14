import 'dart:typed_data';

import 'package:stride/stride.dart';

main(List<String> args) {
  // 3x3 matrix.
  final array2D = <List<String>>[
    ['e00', 'e01', 'e02'],
    ['e10', 'e11', 'e12'],
    ['e20', 'e21', 'e22'],
  ];

  /// Elements of 3x3 matrix in row major layout.
  final list = ['e00', 'e01', 'e02', 'e10', 'e11', 'e12', 'e20', 'e21', 'e22'];

  final stepSize = 3;
  final startIndex = 1;
  final strideIt0 = list.stride(stepSize, startIndex);

  print('2D array:');
  print(array2D[0]);
  print(array2D[1]);
  print(array2D[2]);
  print('');

  print('Column 1:');
  print(strideIt0);
  print('');

  // Typed list (with fixed length).
  final numericalList =
      Float64List.fromList([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

  final strideIt1 = numericalList.stride(
    stepSize,
    startIndex,
  );

  print('Numerical list:');
  print(numericalList);
  print('');

  print('start index: 1 and step-size: 3:');
  print(strideIt1);
  print('');

  print('start index: 9 and step-size: -3:');
  final reverseStrideIt1 = numericalList.stride(-3, 9);
  print(reverseStrideIt1);
}
