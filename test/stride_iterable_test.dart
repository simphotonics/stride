import 'package:stride/stride.dart';
import 'package:test/test.dart';

void main() {
  final list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final stride = 3;

  group('Empty list:', () {
    final it = StrideIterable(<int>[], stride);
    test('isEmpty', () {
      expect(it.isEmpty, true);
    });
    test('length', () {
      expect(it.length, 0);
    });
  });
  group('Offset zero:', () {
    final it = StrideIterable(list, stride);
    test('isEmpty', () {
      expect(it.isEmpty, false);
    });
    test('length', () {
      expect(it.length, 4);
    });
    test('toString()', () {
      expect(it.toString(), '(0, 3, 6, 9)');
    });
    test('first', () {
      expect(it.first, 0);
    });
    test('last', () {
      expect(it.last, 9);
    });

    test('contains', () {
      expect(it.contains(6), true);
      expect(it.contains(10), false);
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
          [0.0, 1.0, 3.0, 4.0, 6.0, 7.0, 9.0, 10.0]);
    });

    test('fold', () {
      expect(it.fold<double>(0.0, (sum, element) => sum += element), 18.0);
    });

    test('followedBy', () {
      final it2 = StrideIterable<int>([100, 101, 102, 103, 104, 105], 2);
      expect(it.followedBy(it2), [0, 3, 6, 9, 100, 102, 104]);
    });
    test('skip', () {
      expect(it.skip(2), [6, 9]);
    });
    test('take', () {
      expect(it.take(2), [0, 3]);
    });
    test('takeWhile', () {
      expect(it.takeWhile((value) => value < 7), [0, 3, 6]);
    });

    test('where', () {
      expect(it.where((element) => element.isEven), [0, 6]);
    });
  });
  group('Offset 2:', () {
    final it = StrideIterable(list, stride);
    it.offset = 2;
    test('isEmpty', () {
      expect(it.isEmpty, false);
    });
    test('length', () {
      expect(it.length, 3);
    });
    test('toString()', () {
      expect(it.toString(), '(2, 5, 8)');
    });
    test('first', () {
      expect(it.first, 2);
    });
    test('last', () {
      expect(it.last, 8);
    });

    test('contains', () {
      expect(it.contains(5), true);
      expect(it.contains(6), false);
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
          [2.0, 3.0, 5.0, 6.0, 8.0, 9.0]);
    });

    test('fold', () {
      expect(it.fold<double>(0.0, (sum, element) => sum += element), 15.0);
    });

    test('followedBy', () {
      final it2 = StrideIterable<int>([100, 101, 102, 103, 104, 105], 2);
      it2.offset = 1;
      expect(it.followedBy(it2), [2, 5, 8, 101, 103, 105]);
    });
    test('skip', () {
      expect(it.skip(2), [8]);
    });
    test('take', () {
      expect(it.take(2), [2, 5]);
    });
    test('takeWhile', () {
      expect(it.takeWhile((value) => value < 7), [2, 5]);
    });

    test('where', () {
      expect(it.where((element) => element.isEven), [2, 8]);
    });
  });
  group('Concurrent mod:', () {
    final list = [0, 1, 2, 3, 4, 5];
    final stride = 2;
    final it = StrideIterable(list, stride);
    test('removing element', () {
      try {
        for (var item in it) {
          if (item == 4) {
            list.removeAt(4);
          }
        }
      } catch (e) {
        expect(e, isA<ConcurrentModificationError>());
      }
    });
  });
}
