import 'package:moonshiner_game/components/npc.dart';
import 'package:moonshiner_game/moonshiner.dart';
import 'package:moonshiner_game/components/player.dart';
import 'package:moonshiner_game/components/wife.dart';
import 'package:flame/components.dart';
import 'level.dart';

class LevelOne extends Level {
  LevelOne({required String levelName, required Player player})
      : super(levelName: levelName, player: player);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Debug message to ensure this code runs
    print("LevelOne onLoad called");

    // Set up the transition callback
    player.onLevelTransition = () => endLevelAndMoveToMoonshiner();

    // Show initial HUD message only if it hasn't been shown yet
    if (!gameRef.hasShownLevelOneIntro) {
      // Use a loop to keep checking the screen size until it's initialized
      _showIntroMessageWhenReady();
      gameRef.hasShownLevelOneIntro = true; // Mark the message as shown
    }
  }

  void _showIntroMessageWhenReady() async {
    // Keep checking the gameRef size until it is fully initialized
    while (gameRef.size.x == 0 || gameRef.size.y == 0) {
      await Future.delayed(Duration(milliseconds: 100));
    }

    // Once initialized, show the developer message
    print("Attempting to show developer message in LevelOne");
    gameRef.showDeveloperMessage(
        "Talk to your wife to start your journey to Moonshiner.");
  }

  void endLevelAndMoveToMoonshiner() {
    gameRef.showDeveloperMessage("Time to head to Moonshiner!");

    // Delay level transition to show the message
    Future.delayed(Duration(seconds: 2), () {
      gameRef.loadNextLevel();
    });
  }
}
