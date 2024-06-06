import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:moonshiner_game/components/player.dart';
import 'package:moonshiner_game/moonshiner.dart';

class Backdoor extends SpriteAnimationComponent
    with HasGameRef<Moonshiner>, CollisionCallbacks {
  Backdoor({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  bool reacheDoor = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    add(RectangleHitbox(collisionType: CollisionType.passive));
    animation = SpriteAnimation.fromFrameData(
        game.images
            .fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 1, textureSize: Vector2(46, 63)));
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player && !reacheDoor) {
      _reachedDoor();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _reachedDoor() {
    print('Backdoor reached by Player.');
    reacheDoor = true;
    animation = SpriteAnimation.fromFrameData(
        game.images
            .fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 1, textureSize: Vector2(46, 63), loop: false));
  }
}
