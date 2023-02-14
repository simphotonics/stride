import 'package:stride/stride.dart';
import 'package:test/test.dart';

/// Testing ReverseUncheckedStrideIterator.
void main() {
  final list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final stepSize = -3;
  group('Empty list:', () {
    final it = <int?>[].fastStride(-1, 0).iterator;
    test('current', () {
      expect(it.current, null);
    });
    test('moveNext()', () {
      it.moveNext();
      expect(it.current, null);
    });
  });
  group('Offset 10:', () {
    test('first', () {
      final it = list.fastStride(stepSize, 10).iterator;
      expect(it.moveNext(), true);
      expect(it.current, 10);
    });
    test('second', () {
      final it = list.fastStride(stepSize, 10).iterator;
      expect(it.moveNext(), true); // Current -> 10.
      expect(it.moveNext(), true); // Current -> 7.
      expect(it.current, 7);
    });
  });
  group('Offset 2:', () {
    final iterable = list.fastStride(stepSize, 2);
    test('first', () {
      final it = iterable.iterator;
      expect(it.moveNext(), true);
      expect(it.current, 2);
    });
    test('second', () {
      final it = iterable.iterator;
      expect(it.moveNext(), true);
      expect(it.moveNext(), false);
    });
  });
  group('Concurrent modification:', () {
    final list = [0, 1, 2, 3, 4, 5];
    final stepSize = -2;
    final it = list.fastStride(stepSize, 5);
    test('removing element', () {
      for (var item in it) {
        if (item == 3) {
          list.removeAt(3);
        }
      }
      // Concurrent modifcation does not throw an error,
      // since this iterator should be used only with fixed length lists.
      expect(list, [0, 1, 2, 4, 5]);
    });
  });
}
