import 'dart:async';

import 'package:flame/components.dart';
import 'package:moonshiner_game/moonshiner.dart';

class BackgroundTile extends SpriteComponent with HasGameRef<Moonshiner> {
  final String color;
  BackgroundTile({
    this.color = 'Gray',
    position,
  }) : super(
          position: position,
        );

  final double scrollSpeed = 0.1;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    size = Vector2.all(64.6);
    sprite = Sprite(game.images.fromCache("Background/$color.png"));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x += scrollSpeed;
    double tileSize = 64;
    int scrollWidth = (game.size.x / tileSize).floor();
    if (position.x > scrollWidth * tileSize) position.x = -tileSize;
    super.update(dt);
  }
}
