# Dart Stride Iterators
[![Dart](https://github.com/simphotonics/stride/actions/workflows/dart.yml/badge.svg)](https://github.com/simphotonics/stride/actions/workflows/dart.yml)

## Introduction

The package [stride][stride] provides **stride iterators** and extension
methods that make it possible to iterate data structures of type `List` and
`Iterable` using a custom start point and step size.

In the context of numerical computation it is often useful to store data
in multi-dimensional arrays. In Dart, a multi-dimensional array may be
represented as a list of lists.
To speed up arithmetical operations and minimize memory usage it may be advantageous to
store a multi-dimensional array as a flat list. For more details see
[numerical computation](https://dart.dev/articles/archive/numeric-computation)
with Dart.

The example below shows how the elements of a 2-dimensional array can
be stored as a 1-dimensional array (a Dart list).

![2D-Array](https://github.com/simphotonics/stride/raw/main/images/array.svg?sanitize=true)

In order to access the elements of the column with index 1
(highlighted using an orange rectangle), we
need to start the iteration at index 1. To move to the next element
we have to use a step size, or stride, that is equal to the number of columns in the
2D-array.


## Usage

To use this package, include [stride] as a dependency in your `pubspec.yaml` file.
The program below demonstrates how to use the
extension method [`stride`][stride-method] to iterate lists using a custom step size
and start index. Note that the iteration step size must not be zero. A negative step
size and suitable start index may be used to iterate in reverse direction.

Tip: When iterating *fixed* size lists, immutable lists views, or typed lists
it makes perfect sense to omit concurrent modification
checks by using the method [`fastStride`][fastStride-method].
The slight performance improvement
is evident when iterating very long lists.

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

  // Omitting concurrent modification checks:
  final strideIt1 = numericalList.fastStride(
    stepSize,
    startIndex
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

```
Running the program above produces the following console output:

```Console
$ dart example/bin/example.dart
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

Consider an N-dimensional array, array_N, with length d<sub>i</sub> along dimension i,
where i &in; \[0, n-1\]. Let array_1 be a Dart list able to store all d<sub>0</sub> &middot; d<sub>1</sub> &middot; &hellip; &middot; d<sub>n-1</sub> elements of array_N.

Let array_N\[i<sub>0</sub>\]\[i<sub>1</sub>\]&hellip;\[i<sub>n&#x2011;1</sub>\] be stored at location array_1\[s<sub>0</sub>&middot;i<sub>0</sub>&nbsp;+&nbsp;&hellip;&nbsp;+&nbsp;s<sub>n-1</sub>&middot;i<sub>n-1</sub>\], where the iteration step sizes, s<sub>i</sub>, depend on the storage order.

For a *row major* storage order the step sizes are given by:

s<sub>0</sub> = d<sub>1</sub> &middot; d<sub>2</sub> &middot; &nbsp; &hellip; &nbsp; &middot; d<sub>n-1</sub>

s<sub>1</sub> = d<sub>2</sub> &middot; d<sub>3</sub> &middot;  &nbsp; &hellip;  &nbsp; &middot; d<sub>n-1</sub>

&nbsp; &nbsp; &vellip;

s<sub>n-2</sub> = d<sub>n-1</sub>

s<sub>n-1</sub> = 1.



For a *column major* storage order the step sizes are given by:

s<sub>0</sub> = 1

s<sub>1</sub> = d<sub>0</sub>

s<sub>2</sub> = d<sub>0</sub> &middot; d<sub>1</sub>


&nbsp; &nbsp; &vellip;

s<sub>n-2</sub> = d<sub>0</sub> &middot; d<sub>1</sub> &middot;  &nbsp; &hellip;  &nbsp; &middot; d<sub>n-3</sub>

s<sub>n-1</sub> = d<sub>0</sub> &middot; d<sub>1</sub> &middot;  &nbsp; &hellip;  &nbsp; &middot; d<sub>n-2</sub>


For more information see [Row- and column-major order](https://en.wikipedia.org/wiki/Row-_and_column-major_order).


## Examples

A copy of the program shown in the section above can be found in the folder [example].


## Features and bugs

Please file feature requests and bugs at the [issue tracker].

[issue tracker]: https://github.com/simphotonics/stride/issues

[example]: https://github.com/simphotonics/stride/tree/main/example

[stride]: https://pub.dev/packages/stride

[Stride]: https://pub.dev/documentation/stride/latest/stride/Stride.html

[stride-method]: https://pub.dev/documentation/stride/latest/stride/Stride/stride.html

[fastStride-method]: https://pub.dev/documentation/stride/latest/stride/FastStride/fastStride.html
