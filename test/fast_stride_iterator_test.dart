import 'package:stride/stride.dart';
import 'package:test/test.dart';

void main() {
  final list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final stride = 3;
  group('Empty list:', () {
    final it = FastStrideIterator(<int?>[], stride);
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
      final it = FastStrideIterator(list, stride);
      expect(it.moveNext(), true);
      expect(it.current, 0);
    });
    test('second', () {
      final it = FastStrideIterator(list, stride);
      expect(it.moveNext(), true);
      expect(it.moveNext(), true);
      expect(it.current, 3);
    });
  });
  group('Offset 2:', () {
    final iterable = StrideIterable(list, stride);
    iterable.offset = 2;
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
}
