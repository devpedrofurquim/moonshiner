import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:moonshiner_game/components/player.dart';
import 'package:moonshiner_game/moonshiner.dart';

class Door extends SpriteAnimationComponent
    with HasGameRef<Moonshiner>, CollisionCallbacks {
  Door({
    position,
    size,
  }) : super(position: position, size: size);

  bool reacheDoor = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    add(RectangleHitbox(collisionType: CollisionType.passive));
    animation = SpriteAnimation.fromFrameData(
        game.images
            .fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 1, textureSize: Vector2(46, 63)));
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !reacheDoor) {
      _reachedDoor();
    }
    super.onCollision(intersectionPoints, other);
  }

  void _reachedDoor() {
    reacheDoor = true;
    animation = animation = SpriteAnimation.fromFrameData(
        game.images
            .fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 1, textureSize: Vector2(46, 63), loop: false));
  }
}
