import 'package:he_is_coming/src/effects.dart';
import 'package:he_is_coming/src/item.dart';

// Dart doesn't have if-expressions, so made a helper function.
void _if(bool condition, void Function() fn) {
  if (condition) {
    fn();
  }
}

/// Effects that can be triggered by items.
final itemEffects = EffectCatalog(
  <String, EffectCallbacks>{
    'Stone Steak':
        onBattle((c) => _if(c.my.isHealthFull, () => c.gainArmor(4))),
    'Redwood Cloak': onBattle((c) => c.restoreHealth(1 * c.m)),
    'Emergency Shield': onInitiative(
      (c) => _if(c.my.speed < c.enemy.speed, () => c.gainArmor(4 * c.m)),
    ),
    'Granite Gauntlet': onBattle((c) => c.gainArmor(5)),
    'Ruby Earring':
        onTurn((c) => _if(c.isEveryOtherTurn, () => c.dealDamage(1))),
    'Firecracker Belt':
        onExposed((c) => List.filled(3 * c.m, 1).forEach(c.dealDamage)),
    'Redwood Helmet': onExposed((c) => c.restoreHealth(3 * c.m)),
    'Explosive Surprise': onExposed((c) => c.dealDamage(5)),
    'Cracked Bouldershield': onExposed((c) => c.gainArmor(5)),
    'Vampiric Wine': onWounded((c) => c.restoreHealth(4 * c.m)),
    'Mortal Edge': onWounded(
      (c) => c
        ..gainAttack(5)
        ..takeDamage(2),
    ),
    'Lifeblood Burst': onWounded((c) => c.dealDamage(c.my.maxHp ~/ 2)),
    'Chain Mail': onWounded((c) => c.gainArmor(3)),
    'Stoneslab Sword': onHit((c) => c.gainArmor(2)),
    'Heart Drinker': onHit((c) => c.restoreHealth(1)),
    'Gold Ring': onBattle((c) => c.gainGold(1)),
    'Ruby Ring': onBattle(
      (c) => c
        ..gainAttack(1 * c.m)
        ..takeDamage(2 * c.m),
    ),
    'Melting Iceblade': onHit((c) => c.loseAttack(1)),
    'Double-edged Sword': onHit((c) => c.takeDamage(1)),
    'Citrine Ring': onBattle(
      (c) => _if(c.my.speed > 0, () => c.dealDamage(c.my.speed)),
    ),
    'Marble Mirror': onBattle(
      (c) => _if(c.enemy.armor > 0, () => c.gainArmor(c.enemy.armor)),
    ),
    // This might be wrong, since this probably should be onTurn?
    // "If you have more speed than the enemy, gain 2 attack"
    'Leather Boots': onBattle(
      (c) => _if(c.my.speed > c.enemy.speed, () => c.gainAttack(2)),
    ),
    'Plated Helmet':
        onTurn((c) => _if(c.my.belowHalfHealth, () => c.gainArmor(2))),
    'Ore Heart': onBattle(
      (c) => c.gainArmor(c.tagCount(ItemTag.stone) * 2),
    ),
    'Granite Hammer': onHit(
      (c) => _if(
        c.my.armor > 0,
        () => c
          ..loseArmor(1)
          ..gainAttack(2),
      ),
    ),
    'Iron Transfusion': onTurn(
      (c) => c
        ..gainArmor(2)
        ..loseHealth(1),
    ),
    'Fortified Gauntlet':
        onTurn((c) => _if(c.my.armor > 0, () => c.gainArmor(1))),
    'Iron Rose': onRestoreHealth((c) => c.gainArmor(1)),
    'Featherweight Coat': onBattle(
      (c) => _if(
        c.my.armor > 0,
        () => c
          ..loseArmor(1)
          ..gainSpeed(3),
      ),
    ),
    'Sticky Web': onInitiative(
      (c) => _if(c.my.speed < c.enemy.speed, () => c.stunEnemy(1)),
    ),
    'Impressive Physique': onExposed((c) => c.stunEnemy(1)),
    'Steelbond Curse': onBattle((c) => c.giveArmorToEnemy(8)),
    'Emerald Ring': onBattle((c) => c.restoreHealth(2 * c.m)),
    'Ironskin Potion': onBattle(
      (c) => _if(c.my.lostHp > 0, () => c.gainArmor(c.my.lostHp)),
    ),
    'Double-plated Armor': onExposed((c) => c.gainArmor(3)),
    'Sapphire Earring':
        onTurn((c) => _if(c.isEveryOtherTurn, () => c.gainArmor(1 * c.m))),
    'Emerald Earring': onTurn(
      (c) => _if(c.isEveryOtherTurn, () => c.restoreHealth(1 * c.m)),
    ),
    'Sapphire Ring': onBattle((c) => c.stealArmor(2)),
    'Horned Helmet': onBattle((c) => c.gainThorns(2 * c.m)),
    'Crimson Cloak': onTakeDamage((c) => c.restoreHealth(1)),
    'Tree Sap': onWounded((c) => [1, 1, 1, 1, 1].forEach(c.restoreHealth)),
    'Petrifying Flask': onWounded(
      (c) => c
        ..gainArmor(10)
        ..stunSelf(2),
    ),
    'Ruby Gemstone': onHit(
      (ctx) => _if(ctx.my.attack == 1, () => ctx.dealDamage(4)),
    ),
    'Bloody Steak': onWounded((c) => c.gainArmor(c.my.maxHp ~/ 2)),
    'Assault Greaves': onTakeDamage((c) => c.dealDamage(1)),
    'Thorn Ring': onBattle((c) => c..gainThorns(6)),
    'Bramble Buckler': onTurn(
      (c) => _if(
        c.my.armor > 0,
        () => c
          ..loseArmor(1)
          ..gainThorns(2),
      ),
    ),
    'Stormcloud Spear':
        onHit((c) => _if(c.everyNStrikes(5), () => c.stunEnemy(2))),
    'Pinecone Plate': onTurn(
      (c) => _if(c.myHealthWasFullAtBattleStart, () => c.gainThorns(1)),
    ),
    'Gemstone Scepter': EffectCallbacks(
      triggers: {
        Trigger.onHit: (c) {
          // "Draws power from emerald, ruby, sapphire and citrine items"
          final emeraldPower = c.gemCount(Gem.emerald);
          // These are supposedly one at a time rather than in bulk.
          // https://discord.com/channels/1041414829606449283/1209488593219756063/1283601378953924650
          for (var i = 0; i < emeraldPower; i++) {
            c.restoreHealth(1);
          }
          final rubyPower = c.gemCount(Gem.ruby);
          for (var i = 0; i < rubyPower; i++) {
            c.dealDamage(1);
          }
          final sapphirePower = c.gemCount(Gem.sapphire);
          for (var i = 0; i < sapphirePower; i++) {
            c.gainArmor(1);
          }
        },
        Trigger.onBattle: (c) {
          // Citrine means extra strikes on the first turn:
          // https://discord.com/channels/1041414829606449283/1209488302269534209/1278082886892781619
          for (var i = 0; i < c.gemCount(Gem.citrine); i++) {
            c.queueExtraStrike();
          }
        },
      },
    ),
    'Blacksmith Bond': onBattle((c) => c.addExtraExposed(1)),
    // This could also be done using computed stats once we have that.
    'Brittlebark Bow':
        // There are exactly 2 previous strikes during the 3rd strike.
        onHit((c) => _if(c.my.strikesMade == 2, () => c.loseAttack(2))),
    'Swiftstrike Rapier': onInitiative(
      (c) => _if(
        c.my.speed > c.enemy.speed,
        () => c
          ..queueExtraStrike()
          ..queueExtraStrike(),
      ),
    ),
    'Swiftstrike Gauntlet': onWounded((c) => c.queueExtraStrike()),
    'Bonespine Whip': onTurn(
      (c) => c
        ..queueExtraStrike(damage: 1)
        ..queueExtraStrike(damage: 1),
    ),
    'Heart-shaped Acorn':
        onBattle((c) => _if(c.my.baseArmor == 0, () => c.healToFull())),
    'Cherry Bomb': onBattle((c) => c.dealDamage(2)),
    'Plated Greaves': onExposed(
      (c) => _if(
        c.my.speed >= 3,
        () => c
          ..loseSpeed(3)
          ..gainArmor(9),
      ),
    ),
    'Saffron Feather': onTurn(
      (c) => _if(
        c.my.speed > 0,
        () => c
          ..loseSpeed(1)
          ..restoreHealth(1),
      ),
    ),
    'Bloodmoon Ritual': onWounded(
      (c) => c
        ..gainThorns(10)
        ..takeDamage(2),
    ),
    'Cherry Cocktail': multiTrigger(
      [Trigger.onBattle, Trigger.onWounded],
      (c) => c
        ..dealDamage(3)
        ..restoreHealth(3),
    ),
    'Explosive Sword': onExposedAndWounded((c) => c.dealDamage(3)),
    'Brittlebark Club': onExposedAndWounded((c) => c.loseAttack(2)),
    'Sanguine Rose': onRestoreHealth((c) => c.restoreHealth(1)),
    'Brittlebark Armor': onTakeDamage((c) => c.takeDamage(1)),
    'Shield Talisman': onGainArmor((c) => c.gainArmor(1)),
    'Briar Rose': onRestoreHealth((c) => c.gainThorns(2)),
    'Razorvine Talisman': onGainThorns((c) => c.gainThorns(1)),
    'Emerald Gemstone': onOverheal((c) => c.dealDamage(c.overhealValue)),
    'Sapphire Gemstone': onLoseArmor((c) => c.restoreHealth(-c.armorDelta)),
    'Razor Scales': onLoseArmor(
      (c) => _if(c.my.hasBeenExposed, () => c.dealDamage(-c.armorDelta)),
    ),
    'Citrine Earring': onTurn(
      (c) => _if(c.isEveryOtherTurn, () => c.gainSpeed(1)),
    ),
    'Tempest Plate': onExposed(
      // Negative armor doesn't exist? This if is probably unnecessary.
      (c) => _if(c.my.baseArmor > 0, () => c.gainSpeed(c.my.baseArmor)),
    ),
    'Blackbriar Blade': EffectCallbacks(
      triggers: {
        Trigger.onGainThorns: (c) => c.gainAttack(c.thornsDelta * 2),
        Trigger.onLoseThorns: (c) => c.loseAttack(c.thornsDelta * -2),
      },
    ),
    'Cracked Whetstone': EffectCallbacks(
      triggers: {
        Trigger.onTurn: (c) => _if(c.isFirstTurn, () => c.gainAttack(2 * c.m)),
        Trigger.onEndTurn: (c) =>
            _if(c.isFirstTurn, () => c.loseAttack(2 * c.m)),
      },
    ),
    'Oak Heart':
        dynamicStats((c) => Stats(maxHp: c.tagCount(ItemTag.wood) * 2)),
    "Woodcutter's Axe": dynamicStats((c) => Stats(attack: c.emptySlots * 2)),
    'Bejeweled Blade':
        dynamicStats((c) => Stats(attack: c.tagCount(ItemTag.jewelry) * 2)),
    'Citrine Gemstone': overrideStats((s) => s.copyWith(speed: -s.speed)),
    'Honey Ham': overrideStats((s) => s.copyWith(maxHp: s.maxHp * 2)),
    'Bearclaw Blade': EffectCallbacks(
      // Use dynamicStats to attack shows up correctly over-land.
      dynamicStats: (c) => Stats(attack: c.lostHp),
      triggers: {
        // Since base stats already include lost hp adjustment we just need
        // to update attack based on hp deltas.
        Trigger.onHpChanged: (c) => c.adjustAttack(-c.hpDelta),
      },
    ),
    'Granite Cherry': EffectCallbacks(
      triggers: {
        Trigger.onBattle: (c) => c.gainArmor(6),
        Trigger.onExposed: (c) => c.dealDamage(6),
      },
    ),
    'Charcoal Roast':
        onBattle((c) => _if(!c.my.isHealthFull, () => c.dealDamage(4))),
    'Sugar Bomb': onTurn((c) => c.dealDamage(2)),
    'Swiftstrike Cloak': onInitiative(
      (c) => _if(c.my.speed >= (c.enemy.speed * 2), () => c.queueExtraStrike()),
    ),
  },
);
