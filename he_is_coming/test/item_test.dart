import 'package:he_is_coming/src/data.dart';
import 'package:he_is_coming/src/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

void main() {
  final data = runWithLogger(_MockLogger(), Data.load);

  test('Weapons require attack', () {
    expect(
      () => Item.test(isWeapon: true),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('Unique items can only be equipped once', () {
    final item = Item.test(isUnique: true);
    expect(
      () => data.player(customItems: [item, item]),
      throwsA(isA<ItemException>()),
    );
  });

  test('Item.partCount', () {
    const honey = 'Honeycomb';
    final honeyItem = Item.test(name: honey);
    expect(honeyItem.partCount(honey), 1);
    final item = Item.test(parts: const {'Honeycomb'});
    expect(item.partCount(honey), 1);
  });
}
