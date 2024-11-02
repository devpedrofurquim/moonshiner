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

    print("LevelOne onLoad called");

    player.onLevelTransition = () => endLevelAndMoveToMoonshiner();

    if (!gameRef.hasShownLevelOneIntro) {
      _showIntroMessageWhenReady();
      gameRef.hasShownLevelOneIntro = true;
    }

    // Customize dialogues for the Wife in LevelOne
    _customizeWifeDialogues();
  }

  void _showIntroMessageWhenReady() async {
    while (gameRef.size.x == 0 || gameRef.size.y == 0) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    print("Attempting to show developer message in LevelOne");
    gameRef.showDeveloperMessage(
        "Talk to your wife to start your journey to Moonshiner.");
  }

  void endLevelAndMoveToMoonshiner() {
    gameRef.showDeveloperMessage("Time to head to Moonshiner!");

    Future.delayed(Duration(seconds: 2), () {
      gameRef.loadNextLevel();
    });
  }

  void _customizeWifeDialogues() {
    try {
      // Locate the Wife instance and update her dialogues
      final wife = children.firstWhere((child) => child is Wife) as Wife;
      wife.dialogues = [
        "Are you ready for this journey, my love?",
        "I hope everything goes well in Moonshiner.",
        "I'm a bit nervous... but excited too!",
        "Don't forget to check our belongings.",
        "Promise me we’ll make it through anything together.",
        "I’ll miss this place... but I'm ready for a fresh start.",
        "Moonshiner... it sounds mysterious, doesn’t it?",
        "I hope the townspeople are friendly.",
        "Whatever happens, I’ll always be by your side.",
        "Let’s make the most of our new life, one day at a time."
      ];
    } catch (e) {
      // Handle the case where Wife component is not found
      print("Wife component not found in children.");
    }
  }
}
