import 'package:he_is_coming/src/data.dart';
import 'package:he_is_coming/src/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

void main() {
  runWithLogger(_MockLogger(), () {
    data = Data.load();
  });

  test('Weapons require attack', () {
    expect(
      () => Item(
        'Test',
        kind: ItemKind.weapon,
        ItemRarity.common,
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('Unique items can only be equipped once', () {
    final item = Item('Test', ItemRarity.common, isUnique: true);
    expect(
      () => createPlayer(items: [item, item]),
      throwsA(isA<ItemException>()),
    );
  });
}
