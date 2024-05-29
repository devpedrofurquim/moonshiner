import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:moonshiner_game/components/custom_hitbox.dart';
import 'package:moonshiner_game/components/enemy.dart';
import 'package:moonshiner_game/components/itemTip.dart';
import 'package:moonshiner_game/components/utils.dart';
import 'package:moonshiner_game/moonshiner.dart';

import 'collision_block.dart';
import 'door.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent
    with KeyboardHandler, HasGameRef<Moonshiner>, CollisionCallbacks {
  String character;

  // ignore: use_super_parameters
  Player({
    position,
    this.character = 'Guy',
  }) : super(position: position);
  final double stepTime = 0.05;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  bool isOnGround = false;
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    height: 28,
    width: 14,
  );
  bool reacheDoor = false;
  double horizontalMovement = 0;
  double verticalMovement = 0;
  double moveSpeed = 50;
  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisionBlocks = [];
  final double _gravity = 8.9;
  final double _jumpForce = 460;
  final double _terminalVelocity = 300;
  bool hasInteracted = false;

  @override
  FutureOr<void> onLoad() {
    priority = 2;
    _loadAllAnimations();
    // debugMode = true;
    add(RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height)));
    return super.onLoad();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    verticalMovement = 0;

    final bool isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final bool isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final bool isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final bool isDownKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyS) ||
            keysPressed.contains(LogicalKeyboardKey.arrowDown);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    verticalMovement += isUpKeyPressed ? -1 : 0;
    verticalMovement += isDownKeyPressed ? 1 : 0;

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ItemTip) other.collidingWithPlayer();
    if (other is Enemy) other.collidingWithPlayer();
    if (other is Door && hasInteracted) {
      if (!reacheDoor) {
        _reachedDoor();
      }
      hasInteracted = false;
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void update(double dt) {
    _updatePlayerState(dt);
    _updatePlayerMovement(dt);
    _checkCollisions();
    super.update(dt);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);

    // list of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation
    };

    current = PlayerState.running;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$state (32x32).png'),
        SpriteAnimationData.sequenced(
          amount: amount,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
        ));
  }

  void _updatePlayerState(double dt) {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // check if moving, set running

    if ((velocity.x) > 0 || velocity.x < 0) {
      playerState = PlayerState.running;
    } else if (velocity.y > 0 || velocity.y < 0) {
      playerState = PlayerState.running;
    } else {
      playerState = PlayerState.idle;
    }

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    velocity.y = verticalMovement * moveSpeed;
    position.x += velocity.x * dt;
    position.y += velocity.y * dt;
  }

  void _checkCollisions() {
    for (final block in collisionBlocks) {
      if (block.isWall) {
        if (checkCollision(this, block)) {
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + height / 2;
          }
        }
      } else if (block.isGround) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - height;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.offsetX + hitbox.width;
          }
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _reachedDoor() {
    reacheDoor = true;
    game.loadNextLevel();
  }
}
