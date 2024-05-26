import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:moonshiner_game/moonshiner.dart';

import 'custom_hitbox.dart';

class ItemTip extends SpriteAnimationComponent
    with HasGameRef<Moonshiner>, CollisionCallbacks {
  final String itemTip;
  ItemTip({this.itemTip = 'Lamp', position, size})
      : super(position: position, size: size);

  bool _collected = false;
  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 10,
    height: 12,
    width: 12,
  );

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    priority = 1;
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.passive,
    ));
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Objects/$itemTip.png'),
        SpriteAnimationData.sequenced(
            amount: 17, stepTime: stepTime, textureSize: Vector2.all(32)));
    return super.onLoad();
  }

  void collidingWithPlayer() {
    if (!_collected) {
      animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('Items/Objects/Collected.png'),
          SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: stepTime,
            textureSize: Vector2.all(32),
            loop: false,
          ));
      _collected = true;
    }
    removeOnFinish = true;
  }
}
