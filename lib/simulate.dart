import 'package:he_is_coming_sim/creatures.dart';
import 'package:he_is_coming_sim/logger.dart';
import 'package:he_is_coming_sim/src/battle.dart';

/// Simulate one game with a player.
void runSim() {
  // This is mostly a placeholder for now.

  final player = Creature.player();
  final wolf = Enemies.wolfLevel1;
  logger
    ..info('Player: ${player.startingStats}')
    ..info('Wolf: ${wolf.startingStats}');

  final battle = Battle();
  final result = battle.resolve(first: player, second: wolf);
  logger.info('${result.winner.name} wins!');

  // Create a new Game
  // Simulate it until the player dies?
  // Print the results.
}
