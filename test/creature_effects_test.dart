import 'package:he_is_coming/src/battle.dart';
import 'package:he_is_coming/src/creature.dart';
import 'package:he_is_coming/src/data.dart';
import 'package:he_is_coming/src/effects.dart';
import 'package:he_is_coming/src/item.dart';
import 'package:he_is_coming/src/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockLogger extends Mock implements Logger {}

BattleResult doBattle({
  required Creature first,
  required Creature second,
  bool verbose = false,
}) {
  final logger = verbose ? Logger() : _MockLogger();
  return runWithLogger(
    logger,
    () => Battle.resolve(first: first, second: second, verbose: verbose),
  );
}

void main() {
  runWithLogger(_MockLogger(), () {
    data = Data.load();
  });

  test('Spider Level 1 effect', () {
    final player = createPlayer();
    expect(player.hp, 10);
    final enemy = data.creatures['Spider Level 1'];
    final result = doBattle(first: player, second: enemy);
    // Spider is faster than us so should do 3 damage on battle start.
    // And then hit 2 more times (since it goes first).
    expect(result.first.hp, 5);
    expect(result.winner, result.first);

    final player2 = createPlayer(intrinsic: const Stats(speed: 3));
    final result2 = doBattle(first: player2, second: enemy);
    // We are the same speed as the spider so it doesn't get the bonus damage
    // and only hits once (we kill it before it can hit a second time).
    expect(result2.first.hp, 9);
  });

  test('Bat Level 1', () {
    final player = createPlayer();
    final enemy = data.creatures['Bat Level 1'];
    final result = doBattle(first: player, second: enemy);
    // Bat is faster than us so should heal 1 on every other turn.
    // We hit first and take 6 hits to kill it.
    expect(result.first.hp, 4);
    expect(result.winner, result.first);
  });

  test('Black Knight', () {
    final player = createPlayer();
    final enemy = data.creatures['Black Knight'];
    final result = doBattle(first: player, second: enemy);
    // Black Knight should gain our attack so do 2 per hit.
    // We have the same speed so we will hit first, but will die in 5 hits.
    expect(result.first.hp, 0);
    // We will have hit 5 times, never having broken its armor.
    expect(result.second.hp, 10);

    // I need to confirm this in-game, but...
    // Player onBattle happens before enemy onBattle (regardless of speed?)
    // so black knight should get our increased attack from onBattle effects.
    final player2 = createPlayer(
      intrinsic: const Stats(maxHp: 20),
      withItems: [
        Item(
          'Ring',
          Rarity.common,
          effects: Effects(onBattle: (c) => c.gainAttack(1)),
        ),
      ],
    );
    // We go first, we hit for 2 and black knight hits for 3.
    // Black knight has 10 hp and 5 armor so will die in 8 hits.
    // Black knight kills us in 7 hits.
    final result2 = doBattle(first: player2, second: enemy);
    expect(result2.first.hp, 0);
    expect(result2.second.hp, 1);
  });

  test('Ironstone Golem', () {
    final player = createPlayer(intrinsic: const Stats(attack: 2, maxHp: 20));
    final enemy = data.creatures['Ironstone Golem'];
    final result = doBattle(first: player, second: enemy);
    // Ironstone hits for 4, killing us in 5 hits (at 20hp)
    // We hit for 3, killing it in 7 hits, but removing its armor in 5 hits when
    // it has only done 4 hits against us (16 hp), its last hits only do 1 dmg.
    expect(result.first.hp, 2);
    expect(result.winner, result.first);
  });
}
