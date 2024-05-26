import 'package:flutter/material.dart';
import 'package:moonshiner_game/components/pause_menu.dart';
import 'package:moonshiner_game/moonshiner.dart';
import 'package:flame/game.dart';

import 'game_over.dart';
import 'main_menu.dart';

class GameScreen extends StatelessWidget {
  final Moonshiner game;

  const GameScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameWidget<Moonshiner>(
          game: game,
          overlayBuilderMap: {
            'MainMenu': (_, game) => MainMenu(game: game),
            'PauseMenu': (_, game) => PauseMenu(game: game),
            'GameOver': (_, game) => GameOver(game: game),
          },
          initialActiveOverlays: const ['MainMenu'],
        ),
        Positioned(
          top: 20,
          right: 20,
          child: IconButton(
            icon: const Icon(Icons.pause, color: Colors.white, size: 30),
            onPressed: () {
              game.pauseEngine();
              game.overlays.add('PauseMenu');
            },
          ),
        ),
      ],
    );
  }
}
