import 'package:stride/stride.dart';
import 'package:test/test.dart';

/// Testing ReverseUncheckedStrideIterator.
void main() {
  final list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final stepSize = -3;
  group('Empty list:', () {
    final it = <int?>[].stride(-1, 0, false).iterator;
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
      final it = list.stride(stepSize, 10, false).iterator;
      expect(it.moveNext(), true);
      expect(it.current, 10);
    });
    test('second', () {
      final it = list.stride(stepSize, 10, false).iterator;
      expect(it.moveNext(), true); // Current -> 10.
      expect(it.moveNext(), true); // Current -> 7.
      expect(it.current, 7);
    });
  });
  group('Offset 2:', () {
    final iterable = list.stride(stepSize, 2, false);
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
    final it = list.stride(stepSize, 5, false);
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
