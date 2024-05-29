import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:moonshiner_game/moonshiner.dart';

class Button extends SpriteComponent with HasGameRef<Moonshiner>, TapCallbacks {
  Button();

  final double margin = 32;
  final double buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    priority = 2;
    sprite = Sprite(game.images.fromCache('HUD/button.png'));
    position = Vector2(
      game.size.x - margin - buttonSize,
      game.size.y - margin - buttonSize,
    );
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasInteracted = true;
    sprite = Sprite(game.images.fromCache('HUD/button_clicked.png'));
    Future.delayed(const Duration(milliseconds: 300), () {
      sprite = Sprite(game.images.fromCache('HUD/button.png'));
      game.player.hasInteracted = false;
    });
    super.onTapDown(event);
  }
}
