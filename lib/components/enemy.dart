import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:moonshiner_game/components/custom_hitbox.dart';
import 'package:moonshiner_game/components/player.dart';
import 'package:moonshiner_game/components/utils.dart';
import 'package:moonshiner_game/moonshiner.dart';

import 'collision_block.dart';
import 'hud.dart';

enum EnemyState { idle, walking }

class Enemy extends SpriteAnimationGroupComponent
    with HasGameRef<Moonshiner>, CollisionCallbacks {
  String enemyCharacter;
  double moveSpeed = 50;
  Vector2 velocity = Vector2.zero();
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    height: 28,
    width: 14,
  );

  final double proximityThreshold =
      100; // Adjust this value based on your game's scale
  bool playerColliding = false; // Flag to track player collision
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation walkingAnimation;
  List<CollisionBlock> collisionBlocks = [];

  bool movingLeft = true;

  Enemy({
    position,
    this.enemyCharacter = 'Mask Dude',
    size,
  }) : super(position: position);

  @override
  FutureOr<void> onLoad() {
    priority = 2;
    _loadAllAnimations();
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    )..debugMode = false); // Enable debug mode
    return super.onLoad();
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    walkingAnimation = _spriteAnimation('Run', 12);

    animations = {
      EnemyState.idle: idleAnimation,
      EnemyState.walking: walkingAnimation,
    };

    current = EnemyState.walking;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images
            .fromCache('Main Characters/$enemyCharacter/$state (32x32).png'),
        SpriteAnimationData.sequenced(
          amount: amount,
          stepTime: 0.05,
          textureSize: Vector2.all(32),
        ));
  }

  bool isMessage = false; // Declare a variable to store the HUDMessage

  HUDMessage hudMessage = HUDMessage(
    message: "Hello!",
    position: Vector2(100, 100), // Adjust position as needed
  );

  @override
  void update(double dt) {
    if (playerColliding) {
      if (!isMessage) {
        gameRef.add(hudMessage);
        isMessage = true;
      } else {
        gameRef.remove(hudMessage);
        isMessage = false;
      }
    }

    if (!playerColliding) {
      _updateEnemyMovement(dt);
      _checkCollisions();
    }
    current = playerColliding ? EnemyState.idle : EnemyState.walking;

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      playerColliding = true; // Set flag to true when colliding with player
      collidingWithPlayer();
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Player) {
      playerColliding = false; // Reset flag when player collision ends
    }
    super.onCollisionEnd(other);
  }

  void _updateEnemyMovement(double dt) {
    if (movingLeft) {
      velocity.x = -moveSpeed;
      if (scale.x > 0) {
        flipHorizontallyAroundCenter();
      }
    } else {
      velocity.x = moveSpeed;
      if (scale.x < 0) {
        flipHorizontallyAroundCenter();
      }
    }

    position.x += velocity.x * dt;
    position.y += velocity.y * dt;
  }

  void _checkCollisions() {
    for (final block in collisionBlocks) {
      if (checkCollision(this, block)) {
        if (velocity.x < 0 || velocity.x > 0) {
          movingLeft = !movingLeft;
        }
      }
    }
  }

  void collidingWithPlayer() {
    velocity.x = 0; // Stop horizontal movement
    // Adjust position if needed to prevent sticking
    if (velocity.x < 0) {
      position.x = position.x + width + hitbox.offsetX;
    } else if (velocity.x > 0) {
      position.x = position.x - hitbox.offsetX - hitbox.width;
    }
  }
}
