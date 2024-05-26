import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isWall;
  bool isGround;
  bool isPlayer;
  CollisionBlock({
    position,
    size,
    this.isWall = false,
    this.isGround = false,
    this.isPlayer = false,
  }) : super(
          position: position,
          size: size,
        ) {
    debugMode = false;
  }

  void collidingWithPlayer() {}
}
