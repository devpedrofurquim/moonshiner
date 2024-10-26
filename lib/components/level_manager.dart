import 'package:flame/components.dart';
import 'package:moonshiner_game/components/player.dart';
import 'package:moonshiner_game/moonshiner.dart';
import 'level.dart';

class LevelManager extends Component with HasGameRef<Moonshiner> {
  Level? currentLevel;
  final Player player;

  LevelManager({required this.player});

  Future<void> loadLevel(String levelName) async {
    await unloadLevel();

    currentLevel = Level(levelName: levelName, player: player);
    await currentLevel!.onLoad();

    gameRef.add(currentLevel!);
  }

  Future<void> unloadLevel() async {
    if (currentLevel != null) {
      currentLevel!.unload(); // Unload all components in the current level
      currentLevel!.removeFromParent();
      currentLevel = null;
    }
  }

  Future<void> switchLevel(String levelName) async {
    await unloadLevel();
    await loadLevel(levelName);
  }
}
