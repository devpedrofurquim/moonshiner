import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isWall;
  bool isGround;
  CollisionBlock({
    position,
    size,
    this.isWall = false,
    this.isGround = false,
  }) : super(
          position: position,
          size: size,
        ) {
    debugMode = true;
  }
}
