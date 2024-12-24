import 'package:moonshiner_game/components/background_tile.dart';
import 'package:moonshiner_game/components/clouds.dart';
import 'package:moonshiner_game/components/npc.dart';
import 'package:moonshiner_game/moonshiner.dart';
import 'package:moonshiner_game/components/WifesFather.dart';
import 'package:moonshiner_game/components/WifesMom.dart';
import 'package:moonshiner_game/components/player.dart';
import 'package:moonshiner_game/components/wife.dart';
import 'package:flame/components.dart';
import 'level.dart';

class LevelOne extends Level {
  bool developerMessageVisible = true;

  // Mission state
  bool talkedToWife = false;
  bool saidGoodbyeToFather = false;
  bool saidGoodbyeToMother = false;

  LevelOne({required String levelName, required Player player})
      : super(levelName: levelName, player: player);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    print("LevelOne onLoad called");

    player.onLevelTransition = _tryToMoveToNextLevel;

    if (!gameRef.hasShownLevelOneIntro) {
      _showIntroMessageWhenReady();
      gameRef.hasShownLevelOneIntro = true;
    }

    _setupBackground();
    _customizeWifeDialogues();
    _spawnParents();
  }

  void _setupBackground() {
    final backgroundTile = BackgroundTile(position: Vector2(0, 50));
    add(backgroundTile);
  }

  void _showIntroMessageWhenReady() async {
    while (gameRef.size.x == 0 || gameRef.size.y == 0) {
      await Future.delayed(Duration(milliseconds: 100));
    }
    print("Attempting to show developer message in LevelOne");
    gameRef.showDeveloperMessage(
        "Talk to your wife to start your journey to Moonshiner.");
  }

  void _tryToMoveToNextLevel() {
    if (talkedToWife && saidGoodbyeToFather && saidGoodbyeToMother) {
      endLevelAndMoveToMoonshiner();
    } else {
      // Build the message for incomplete tasks
      List<String> incompleteTasks = [];
      if (!talkedToWife) {
        incompleteTasks.add("Talk to your wife.");
      }
      if (!saidGoodbyeToFather) {
        incompleteTasks.add("Say goodbye to her father.");
      }
      if (!saidGoodbyeToMother) {
        incompleteTasks.add("Say goodbye to her mother.");
      }

      // Join the incomplete tasks into a single line
      String message = incompleteTasks.join(" ");

      // Show the message
      gameRef.showDeveloperMessage(message);
    }
  }

  void endLevelAndMoveToMoonshiner() {
    gameRef.showDeveloperMessage("Time to head to Moonshiner!");

    Future.delayed(Duration(seconds: 2), () {
      gameRef.loadNextLevel();
    });
  }

  void _customizeWifeDialogues() {
    try {
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

      wife.onPlayerInteraction = () {
        if (developerMessageVisible) {
          gameRef.hideDeveloperMessage();
          developerMessageVisible = false;
        }
        talkedToWife = true; // Mark mission as completed
        print("Talked to wife: $talkedToWife"); // Debug log
      };
    } catch (e) {
      print("Wife component not found in children.");
    }
  }

  void _spawnParents() {
    final fatherPosition = Vector2(100, 200);
    final motherPosition = Vector2(150, 200);

    final wifesFather = WifesFather(position: fatherPosition);
    final wifesMom = WifesMom(position: motherPosition);

    add(wifesFather);
    add(wifesMom);

    wifesFather.onPlayerInteraction = _onGoodbyeFather;
    wifesMom.onPlayerInteraction = _onGoodbyeMother;
  }

  void _onGoodbyeFather() {
    saidGoodbyeToFather = true; // Mark mission as completed
    print("Said goodbye to father: $saidGoodbyeToFather"); // Debug log
    _checkAllGoodbyes();
  }

  void _onGoodbyeMother() {
    saidGoodbyeToMother = true; // Mark mission as completed
    print("Said goodbye to mother: $saidGoodbyeToMother"); // Debug log
    _checkAllGoodbyes();
  }

  void _checkAllGoodbyes() {
    if (saidGoodbyeToFather && saidGoodbyeToMother) {
      gameRef
          .showDeveloperMessage("You said goodbye to everyone. Time to leave!");
    }
  }
}
