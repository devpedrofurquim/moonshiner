import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moonshiner_game/components/gameScreen.dart';
import 'package:moonshiner_game/moonshiner.dart';
import 'components/game_over.dart';
import 'components/main_menu.dart';
import 'components/pause_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  Moonshiner game = Moonshiner();
  runApp(GameApp(game: game));
}

class GameApp extends StatelessWidget {
  final Moonshiner game;

  const GameApp({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: Scaffold(
        body: GameScreen(game: game),
      ),
    );
  }
}
