import 'package:stride/stride.dart';
import 'package:test/test.dart';

void main() {
  final list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final stepSize = 3;
  group('Empty list:', () {
    final it = <int?>[].fastStride(1, 0).iterator;
    test('current', () {
      expect(it.current, null);
    });
    test('moveNext()', () {
      it.moveNext();
      expect(it.current, null);
    });
  });
  group('Offset zero:', () {
    test('first', () {
      final it = list.fastStride(stepSize, 0).iterator;
      expect(it.moveNext(), true);
      expect(it.current, 0);
    });
    test('second', () {
      final it = list.fastStride(stepSize, 0).iterator;
      expect(it.moveNext(), true);
      expect(it.moveNext(), true);
      expect(it.current, 3);
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
      expect(it.moveNext(), true);
      expect(it.current, 5);
    });
  });
  group('Concurrent modification:', () {
    final list = [0, 1, 2, 3, 4, 5];
    final stepSize = 2;
    final it = list.fastStride(stepSize, 0);
    test('removing element', () {
      for (var item in it) {
        if (item == 4) {
          list.removeAt(4);
        }
      }
      // Concurrent modifcation does not throw an error,
      // since this iterator should be used only with fixed length lists.
      expect(list, [0, 1, 2, 3, 5]);
    });
  });
}
