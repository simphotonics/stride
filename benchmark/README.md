
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
$ dart run benchmark_runner report

Locating benchmark files ...
./benchmark/iterable_benchmark.dart

$ dart ./benchmark/iterable_benchmark.dart
  [589ms:046us] column4: list iterator checked
    mean: 4.018 ± 3.92 ms, median: 3.60 ± 1.53 ms
    ▉▉█▉▂_▂▁______  37  _____
    sample size: 94

  [539ms:556us] column4: list iterator unchecked
    mean: 3.83 ± 1.31 ms, median: 4.031 ± 1.38 ms
    ▁▉▁▉________
    sample size: 88


-------      Summary     --------
Total run time: [12s:942ms]
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