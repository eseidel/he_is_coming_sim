import 'package:he_is_coming/src/battle.dart';
import 'package:he_is_coming/src/effects.dart';

EffectCallbacks _spiderEffect({required int damage}) {
  return onBattle(
    (c) {
      if (c.my.speed > c.enemy.speed) {
        c.dealDamage(damage);
      }
    },
  );
}

EffectCallbacks _batEffect({required int hp}) {
  return onHit(
    (c) {
      if (c.isEveryOtherTurn) {
        c.restoreHealth(hp);
      }
    },
  );
}

EffectCallbacks _hedgehogEffect({required int thorns}) =>
    onBattle((c) => c.gainThorns(thorns));

EffectCallbacks _wolfEffect({required int baseAttack, required int bonus}) {
  // We have no way for effects to have their own state, so we have to hard
  // code the base/bonus within this effect so we can tell during the effect
  // which state we're in.
  void adjustIfNeeded(EffectContext c) {
    final hasBonus = c.my.attack == baseAttack + bonus;
    final shouldHaveBonus = c.enemy.hp < 5;
    if (!{baseAttack, baseAttack + bonus}.contains(c.my.attack)) {
      throw StateError('Unexpected attack value for Wolf.');
    }
    if (hasBonus && !shouldHaveBonus) {
      c.loseAttack(bonus);
    } else if (!hasBonus && shouldHaveBonus) {
      c.gainAttack(bonus);
    }
  }

  return EffectCallbacks(
    triggers: {
      Trigger.onBattle: adjustIfNeeded,
      Trigger.onEnemyHpChanged: adjustIfNeeded,
    },
  );
}

// Dart doesn't have if-expressions, so made a helper function.
void _if(bool condition, void Function() fn) {
  if (condition) {
    fn();
  }
}

/// Effects that can be triggered by creatures.
final creatureEffects = EffectCatalog(<String, EffectCallbacks>{
  'Spider Level 1': _spiderEffect(damage: 3),
  'Spider Level 2': _spiderEffect(damage: 4),
  'Spider Level 3': _spiderEffect(damage: 5),
  'Bat Level 1': _batEffect(hp: 1),
  'Bat Level 2': _batEffect(hp: 2),
  'Bat Level 3': _batEffect(hp: 3),
  'Hedgehog Level 1': _hedgehogEffect(thorns: 3),
  'Woodland Abomination': onTurn(
    (c) {
      // The game lets the abomination attack once for 0 for whatever reason.
      if (c.isFirstTurn) {
        return;
      }
      c.gainAttack(1);
    },
  ),
  'Black Knight': onBattle(
    (c) => _if(c.enemy.attack > 0, () => c.gainAttack(c.enemy.attack)),
  ),
  'Ironstone Golem': onExposed((c) => c.loseAttack(3)),
  'Granite Griffin': onWounded(
    (c) => c
      ..gainArmor(30)
      ..stunSelf(2),
  ),
  'Razortusk Hog':
      onTurn((c) => _if(c.hadMoreSpeedAtStart, () => c.queueExtraStrike())),
  'Gentle Giant':
      onTakeDamage((c) => c.gainThorns(c.my.atOrBelowHalfHealth ? 4 : 2)),
  'Bloodmoon Werewolf': onTurn(
    (c) => _if(c.enemy.atOrBelowHalfHealth, () => c.executeEnemy()),
  ),
  'Brittlebark Beast': onTakeDamage((c) => c.takeDamage(3)),
  'Wolf Level 1': _wolfEffect(baseAttack: 1, bonus: 2),
  'Wolf Level 2': _wolfEffect(baseAttack: 2, bonus: 3),
  'Wolf Level 3': _wolfEffect(baseAttack: 3, bonus: 4),
});
