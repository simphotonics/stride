# Dart Stride Iterators

[![Dart](https://github.com/simphotonics/exception_templates/actions/workflows/dart.yml/badge.svg)](https://github.com/simphotonics/exception_templates/actions/workflows/dart.yml)


## Introduction

In the context of numerical computation, data is often represented as multi-dimensional arrays. To speed up arithmetical operations and minimize storage it can be advantageous to flatten multi-dimensional arrays (see [Numerical computation](https://dart.dev/articles/archive/numeric-computation)).

The example below shows the elements of a 2-dimensional array stored as a 1-dimensional
array using a row major layout.

![Console Output](https://github.com/simphotonics/stride/blob/main/images/array.svg?sanitize=true)

To access the element `array2D[i][j]` one needs to
retrieve `array1D[nCols * i + j]`, where `nCols` is the number of
columns.

Since the 1D array is arranged in a row major format it
is an easy task to access the elements of the row with index `i`:
`row_i = array1D.sublist(i * nCols, i * nCols + nCols)`. All we need to do is
skip `i * nCols` elements and then collect the next `nCols` elements.

In order to access the elements of the column with index `j`, one could use
a [`StrideIterable`][StrideIterable]:
`column_j = array1D.stride(nCols, j)`. The iterable starts at `j`
and uses the stride `nCols` to advance to the next element. Looking at the
figure above and setting `nCols = 3` and `j = 1` one can see that the iterable
contains the elements of the column with index 1.


## Usage

To use this library include [stride] as dependency in your `pubspec.yaml` file.
The program below demonstrates how to iterate lists using a custom step size
and start position.

Tip: When iterating *fixed* size lists it is possible to disable concurrent modification
checks before advancing to the next element (see below).

```Dart
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
  final startPosition = 1;
  final strideIt0 = list.stride(stepSize, startPosition);

  print('3D array:');
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
    startPosition,
    false,   // <-----------    Disabling concurrent modification checks.
  );

  print('Numerical list:');
  print(numericalList);
  print('');

  print('Start position: 1 and step-size: 3:');
  print(strideIt1);
  print('');
}

```
Running the program above produces the following console output:

```Console
$ dart example.dart
3D array:
[e00, e01, e02]
[e10, e11, e12]
[e20, e21, e22]

Column 1:
(e01, e11, e21)

Numerical list:
[0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]

Start position: 1 and step-size: 3:
(1.0, 4.0, 7.0, 10.0)
```


## Examples

A copy of the program shown in the section above can be found in the folder  [example].


## Features and bugs

Please file feature requests and bugs at the [issue tracker].

[issue tracker]: https://github.com/simphotonics/stride/issues

[example]: example

[StrideIterable]: https://pub.dev/documentation/stride/latest/stride/StrideIterable-class.html

[FastStrideIterable]: https://pub.dev/documentation/stride/latest/stride/FastStrideIterable-class.html

[StrideIterator]: https://pub.dev/documentation/stride/latest/stride/StrideIterator-class.html

[FastStrideIterator]: https://pub.dev/documentation/stride/latest/stride/FastStrideIterator-class.html

[stride]: https://pub.dev/packages/stride