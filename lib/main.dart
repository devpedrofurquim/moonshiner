import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:moonshiner_game/components/gameScreen.dart';
import 'package:moonshiner_game/moonshiner.dart';

import 'components/game_over.dart';
import 'components/main_menu.dart';
import 'components/pause_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure device settings for the game.
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  // Initialize the background music system and add a small delay to ensure stability
  FlameAudio.bgm.initialize();
  await Future.delayed(Duration(milliseconds: 100)); // Brief delay for setup

  // Create an instance of the Moonshiner game.
  final Moonshiner game = Moonshiner();

  // Launch the Flutter app.
  runApp(GameApp(game: game));
}

class GameApp extends StatelessWidget {
  final Moonshiner game;

  // Constructor with required game parameter.
  const GameApp({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: Scaffold(
        // Use GameScreen to manage different game states.
        body: GameScreen(game: game),
      ),
    );
  }
}
