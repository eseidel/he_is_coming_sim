import 'package:he_is_coming/he_is_coming.dart';

export 'package:he_is_coming/src/battle.dart';
export 'package:he_is_coming/src/data.dart';
export 'package:he_is_coming/src/logger.dart';
export 'package:scoped_deps/scoped_deps.dart';

/// Simulate one game with a player.
void runSim() {
  final data = Data.load();
  Creature.defaultPlayerWeapon = data.items['Wooden Stick'];

  // final items = [
  //   'Heart Drinker',
  //   'Horned Helmet',
  //   'Iron Rose',
  //   'Crimson Cloak',
  //   'Impressive Physique',
  //   'Iron Transfusion',
  //   'Tree Sap',
  //   'Sapphire Earing',
  //   'Emerald Earing',
  // ];
  // const edge = 'Jagged Edge';
  // final oils = [
  //   'Speed Oil',
  // ];

  final items = [
    'Granite Hammer',
    'Elderwood Necklace',
    'Iron Transfusion',
    'Iron Transfusion',
    'Iron Transfusion',
    'Plated Helmet',
    'Iron Transfusion',
  ];
  const edge = 'Bleeding Edge';
  final oils = [
    'Attack Oil',
    'Armor Oil',
    'Speed Oil',
  ];
  final player = data.player(items: items, edge: edge, oils: oils);
  final enemy = data.creatures['Woodland Abomination'];

  // final player = data.player(items: [data.items['Stone Steak']]);
  // final enemy = data.creatures['Spider Level 1'];

  final result = Battle.resolve(first: player, second: enemy, verbose: true);
  final winner = result.winner;
  final damageTaken = winner.baseStats.maxHp - winner.hp;
  logger.info('${result.winner.name} wins in ${result.turns} turns with '
      '$damageTaken damage taken.');
}
