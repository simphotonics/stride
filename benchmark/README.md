
# Dart Stride Iterators - Benchmark


## Benchmark setup

The benchmarked task consists of accessing the elements of column 4 of a 2D array
storing elements of type `double` with 1000000 rows and 10 columns.
The array is flattened using a row major storage order.
<details> <summary> Click to show the benchmark program. </summary>

```Dart
import 'package:benchmark_runner/benchmark_runner.dart';
import 'package:stride/stride.dart';

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

void main() {
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
```
</details>

## Running the benchmarks

To run the benchmarks, navigate to the package root in your local copy of
[`stride`][stride] and
use the command:
```Perl
$ dart run benchmark_runner
Finding benchmark files...
  benchmark/iterable_benchmark.dart

Progress timer: [05s:000ms]

Running: dart --define=isBenchmarkProcess=true benchmark/iterable_benchmark.dart
  [02s:438ms:812us] column4: list iterator checked; mean: 75.00 ± 28.57 ms, median: 63.38 ± 39.73 ms
                     ▉▅▂_ sample size: 24

  [02s:040ms:543us] column4: list iterator unchecked; mean: 65.41 ± 21.31 ms, median: 57.68 ± 24.16 ms
                     ▉▄▂__ sample size: 21


-------      Summary     --------
Total run time: [05s:751ms]
Completed benchmarks: 2.
Completed successfully.
Exiting with code: 0.
```


The report above was generated on a PC with an Intel Core i5-6260U processor and 32GB of memory
using the package [`benchmark_runner`][benchmark_runner].

The benchmark score shows that there is a slight performance improvement when disabling concurrent
modification checks.


## Features and bugs
Please file feature requests and bugs at the [issue tracker].


[benchmark_runner]: https://pub.dev/packages/benchmark_runner

[issue tracker]: https://github.com/simphotonics/stride/issues

[stride]: https://pub.dev/packages/stride