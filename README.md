# Dart Stride Iterator
[![Dart](https://github.com/simphotonics/stride/actions/workflows/dart.yml/badge.svg)](https://github.com/simphotonics/stride/actions/workflows/dart.yml)

## Introduction

In the context of numerical computation, data is often represented as multi-dimensional arrays.
In Dart, a multi-dimensional array can be represented as a list of lists.
To speed up arithmetical operations and minimize memory usage it can be advantageous to
flatten multi-dimensional arrays
(see [Numerical computation](https://dart.dev/articles/archive/numeric-computation)).

The example below shows the elements of a 2-dimensional array stored as a 1-dimensional
array (a Dart list) using a row major layout.

![2D-Array](https://github.com/simphotonics/stride/blob/main/images/array.svg?sanitize=true)

To access the element array2\[i\]\[j\] one needs to
retrieve array1[nCols &middot; i + j], where nCols is the number of
columns. Since the 1D array is arranged using a row major layout it
is an easy task to access the elements of the row with index i:

row_i = array1.sublist(i &middot; nCols, i &middot; nCols + nCols). All we need to do is
skip i * nCols elements and then collect the next nCols elements.

In order to access the elements of the column with index j, one could use
the method [`stride`][stride-method] added by the extension [`Stride`][Stride]:

column_j = array1.stride(nCols, j).

The method returns an iterable starting from index j
and uses the step size `nCols` to advance to the next element. Looking at the
figure above and setting `nCols = 3` and `j = 1` one can see that the iterable
contains the elements of the column with index 1.


## Usage

To use this package include [stride] as dependency in your `pubspec.yaml` file.
The program below demonstrates how to use the extension method
[`stride`][stride-method] to iterate lists using a custom step size
and start index. The iteration step size must not be zero. A negative step
size may be used to iterate in reverse direction.

Tip: When iterating *fixed* size lists it is advisable to disable concurrent modification
checks. The slight performance improvement
is more evident when iterating very long lists.


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
    false,   // <-----------    Disabling concurrent modification checks.
  );

  print('Numerical list:');
  print(numericalList);
  print('');

  print('start index: 1 and step-size: 3:');
  print(strideIt1);
  print('');

  print('start index: 9 and step-size: -3:');
  final reverseStrideIt1 = numericalList.stride(-3, 9, false );
  print(reverseStrideIt1);
}

```
Running the program above produces the following console output:

```Console
$ dart example.dart
2D array:
[e00, e01, e02]
[e10, e11, e12]
[e20, e21, e22]

Column 1:
(e01, e11, e21)

Numerical list:
[0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]

start index: 1 and step-size: 3:
(1.0, 4.0, 7.0, 10.0)

start index: 9 and step-size: -3:
(9.0, 6.0, 3.0, 0.0)
```

## Row Major and Column Major Storage Layout

Consider an N-dimensional array, arrayN, with length d<sub>i</sub> along dimension i. Assuming that the array is flattened using a *row major layout*, one can
access the element arrayN[i<sub>0</sub>][i<sub>1</sub>]&ctdot;[i<sub>n-1</sub>]  as array1[  s<sub>0</sub> &middot; i<sub>0</sub>  + &ctdot; +  s<sub>n-1</sub> &middot; i<sub>n-1</sub>].

The strides (step sizes) used above are given by:

s<sub>0</sub> = d<sub>1</sub> &middot; d<sub>2</sub> &middot; &ctdot; &middot; d<sub>n-1</sub>

s<sub>1</sub> = d<sub>2</sub> &middot; d<sub>3</sub> &middot; &ctdot; &middot; d<sub>n-1</sub>

&nbsp; &nbsp; &vellip;

s<sub>n-2</sub> = d<sub>n-1</sub>

s<sub>n-1</sub> = 1.


## Examples

A copy of the program shown in the section above can be found in the folder [example].


## Features and bugs

Please file feature requests and bugs at the [issue tracker].

[issue tracker]: https://github.com/simphotonics/stride/issues

[example]: https://github.com/simphotonics/stride/tree/main/example

[stride]: https://pub.dev/packages/stride

[FastStrideIterator]: https://pub.dev/documentation/stride/latest/stride/FastStrideIterator-class.html

[Stride]: https://pub.dev/documentation/stride/latest/stride/Stride.html

[stride-method]: https://pub.dev/documentation/stride/latest/stride/Stride/stride.html