
# Dart Stride Iterators - Benchmark


## Benchmark setup

The benchmarked task consists of accessing the elements of column 4 of a 2D array
storing elements of type `double` with 1000000 rows and 10 columns.
The array is flattened using a row major storage order.
<details> <summary> Click to show the benchmark program. </summary>

```Dart
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
    }, duration: Duration(milliseconds: 6000));
    benchmark('list iterator checked', () {
      for (var element in listIt) {
        tmp = element;
      }
    }, duration: Duration(milliseconds: 6000));
    benchmark('list iterator', () {
      for (var element in listFastIt) {
        tmp = element;
      }
    }, duration: Duration(milliseconds: 6000));
    benchmark('typed list iterator', () {
      for (var element in typedListIt) {
        tmp = element;
      }
    }, duration: Duration(milliseconds: 6000));
  });
}
```
</details>

## Running the benchmarks

To run the benchmarks, navigate to the package root in your local copy of [`stride`][stride] and
use the command:
```Console
$ dart run benchmark
```
A sample benchmark output is listed below:
```Dart
$ pub run benchmark
 DONE  ./benchmark/bin/iterable_benchmark.dart (27 s)
 column_4:
  ✓ array2d[i][4] (684 ms)
  ✓ list iterator checked (158 ms)
  ✓ list iterator (152 ms)
  ✓ typed list iterator (83 ms)

Benchmark suites: 1 passed, 1 total
Benchmarks:       4 passed, 4 total
Time:             27 s
Ran all benchmark suites.
```

The report above was generated on a PC with an Intel Core i5-6260U processor and 32GB of memory
using the package [`benchmark`][benchmark]. Each benchmark task was run for 1000 milliseconds.

The report above shows that there is a slight performance improvement when disabling concurrent
modification checks. In this particular case, opting for a typed list leads to a further performance improvement.


## Features and bugs
Please file feature requests and bugs at the [issue tracker].


[benchmark]: https://pub.dev/packages/benchmark

[issue tracker]: https://github.com/simphotonics/stride/issues

[stride]: https://pub.dev/packages/stride