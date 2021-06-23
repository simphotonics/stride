import 'package:stride/stride.dart';
import 'package:test/test.dart';

/// Testing ReverseStrideIterator:
void main() {
  final list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final stepSize = -3;
  group('Empty list:', () {
    final it = <int?>[].stride(-1, 0).iterator;
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
      final it = list.stride(stepSize, 10).iterator;
      expect(it.moveNext(), true);
      expect(it.current, 10);
    });
    test('second', () {
      final it = list.stride(stepSize, 10).iterator;
      expect(it.moveNext(), true); // Current -> 10.
      expect(it.moveNext(), true); // Current -> 7.
      expect(it.current, 7);
    });
  });
  group('Offset 2:', () {
    final iterable = list.stride(stepSize, 2);
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
    test('removing element', () {
      final it = list.stride(stepSize).iterator;
      try {
        list.removeAt(3);
        it.moveNext();
      } catch (e) {
        expect(e, isA<ConcurrentModificationError>());
      }
    });

  });
}
