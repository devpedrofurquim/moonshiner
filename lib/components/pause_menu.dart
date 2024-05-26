import 'package:flutter/material.dart';
import 'package:moonshiner_game/moonshiner.dart';

class PauseMenu extends StatelessWidget {
  final Moonshiner game;

  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Game Paused',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  game.overlays.remove('PauseMenu');
                  game.resumeEngine();
                },
                child: const Text('Resume', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  game.overlays.remove('PauseMenu');
                  game.overlays.add('MainMenu');
                },
                child: const Text('Main Menu', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
