import 'package:he_is_coming/src/effects.dart';

// Dart doesn't have if-expressions, so made a helper function.
void _if(bool condition, void Function() fn) {
  if (condition) {
    fn();
  }
}

/// Effects that can be triggered by set bonuses.
final setEffects = EffectCatalog(<String, EffectCallbacks>{
  'Redwood Crown': onWounded((c) => c.healToFull()),
  'Raw Hide': onTurn((c) => _if(c.isEveryOtherTurn, () => c.gainAttack(1))),
  'Briar Greaves': onTakeDamage((c) => c.gainThorns(1)),
  'Stone Scales': onWounded((c) => c.gainArmor(10)),
  'Elderwood Mask': onBattle((c) {
    final base = c.my.baseStats;
    final value = base.attack;
    if (value == base.armor && value == base.speed) {
      c
        ..gainAttack(value)
        ..gainArmor(value)
        ..gainSpeed(value);
    }
  }),
});
