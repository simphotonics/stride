import 'package:stride/stride.dart';
import 'package:test/test.dart';

/// Unit tests checking the extension method `stride` using a negative
/// stride.
void main() {
  final list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final stepSize = -3;

  group('Empty list:', () {
    final it = <int>[].stride(-3);
    test('isEmpty', () {
      expect(it.isEmpty, true);
    });
    test('length', () {
      expect(it.length, 0);
    });
  });
  group('Start index 0:', () {
    final it = list.stride(stepSize);
    print(it);
    test('isEmpty', () {
      expect(it.isEmpty, false);
    });
    test('length', () {
      expect(it.length, 1);
    });
    test('toString()', () {
      expect(it.toString(), '(0)');
    });
  });

  group('Start index: 10', () {
    final it = list.stride(stepSize, 10);
    test('first', () {
      print(it);
      expect(it.first, 10);
    });
    test('last', () {
      expect(it.last, 1);
    });

    test('contains', () {
      expect(it.contains(7), true);
      expect(it.contains(10), true);
    });

    test('any', () {
      expect(it.any((element) => element.isEven), true);
    });

    test('expand', () {
      expect(
          it.expand<double>((element) => [
                element.toDouble(),
                element.toDouble() + 1,
              ]),
          [10.0, 11.0, 7.0, 8.0, 4.0, 5.0, 1.0, 2.0]);
    });

    test('fold', () {
      expect(it.fold<double>(0.0, (sum, element) => sum += element), 22.0);
    });

    test('followedBy', () {
      final it2 = <int>[100, 101, 102, 103, 104, 105].stride(2);
      expect(it.followedBy(it2), [10, 7, 4, 1, 100, 102, 104]);
    });
    test('skip', () {
      expect(it.skip(2), [4, 1]);
    });
    test('take', () {
      expect(it.take(2), [10, 7]);
    });
    test('takeWhile', () {
      expect(it.takeWhile((value) => value > 7), [10]);
    });

    test('where', () {
      expect(it.where((element) => element.isEven), [10, 4]);
    });
  });
  group('Start Index 6:', () {
    final it = list.stride(stepSize, 6);
    test('isEmpty', () {
      expect(it.isEmpty, false);
    });
    test('length', () {
      expect(it.length, 3);
    });
    test('toString()', () {
      expect(it.toString(), '(6, 3, 0)');
    });
    test('first', () {
      expect(it.first, 6);
    });
    test('last', () {
      expect(it.last, 0);
    });

    test('contains', () {
      expect(it.contains(5), false);
      expect(it.contains(6), true);
    });

    test('any', () {
      expect(it.any((element) => element.isEven), true);
    });
  });
}
