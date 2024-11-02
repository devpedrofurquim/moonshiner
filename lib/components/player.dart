import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:moonshiner_game/components/custom_hitbox.dart';
import 'package:moonshiner_game/components/npc.dart';
import 'package:moonshiner_game/components/itemTip.dart';
import 'package:moonshiner_game/components/utils.dart';
import 'package:moonshiner_game/moonshiner.dart';

import 'collision_block.dart';
import 'door.dart';
import 'backdoor.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent
    with KeyboardHandler, HasGameRef<Moonshiner>, CollisionCallbacks {
  String character;

  Player({
    position,
    this.character = 'Guy',
  }) : super(position: position);

  final double stepTime = 0.05;
  VoidCallback? onLevelTransition;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  bool isOnGround = false;
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    height: 28,
    width: 14,
  );
  bool reachedDoor = false;
  double horizontalMovement = 0;
  AbstractNPC? activeNPC; // Track the NPC currently in dialogue
  double verticalMovement = 0;
  double moveSpeed = 50;
  bool isInteracting = false; // Add this flag to manage interactions
  Vector2 velocity = Vector2.zero();
  bool isInteractingWithNPC = false; // Add this flag
  List<CollisionBlock> collisionBlocks = [];
  final double _gravity = 8.9;
  final double _jumpForce = 460;
  final double _terminalVelocity = 300;
  bool hasInteracted = false;
  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;
  final double dialogueRange = 40.0;

  @override
  FutureOr<void> onLoad() {
    priority = 2;
    _loadAllAnimations();
    add(RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height)));
    return super.onLoad();
  }

  void interact() {
    hasInteracted = true; // Set this to true on player interaction
    if (activeNPC != null) {}
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
    if (other is Door && hasInteracted) {
      if (!reachedDoor) {
        _reachedDoor();
      }
      hasInteracted = false;
    }
    if (other is Backdoor && hasInteracted) {
      if (!reachedDoor) {
        _reachedBackDoor();
      }
      hasInteracted = false;
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is AbstractNPC && activeNPC == null) {
      activeNPC = other;
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  // Method to reset active NPC
  void resetActiveNPC() {
    activeNPC = null;
  }

  // Reset interaction flag after each dialogue line is displayed
  void resetNPCInteraction() {
    isInteractingWithNPC = false;
    hasInteracted = false;
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      _updatePlayerState(fixedDeltaTime);
      _updatePlayerMovement(fixedDeltaTime);
      _checkCollisions();
      _checkNPCProximity(gameRef.activeNpcs); // Check for NPC proximity
      accumulatedTime -= fixedDeltaTime;
    }
    super.update(dt);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);

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

  void _checkNPCProximity(List<AbstractNPC> npcs) {
    for (final npc in npcs) {
      double distanceToNPC = npc.position.distanceTo(position);
      bool inRange = distanceToNPC < dialogueRange;

      if (inRange && !npc.hasDialogue) {
        npc.hasDialogue = true;
      } else if (!inRange && npc.hasDialogue) {
        npc.dialogueComponent?.clearMessageWithTypewriter();
        npc.hasDialogue = false;
      }
    }
  }

  void _updatePlayerState(double dt) {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x.abs() > 0 || velocity.y.abs() > 0) {
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
    print('Reached Door');
    reachedDoor = true;
    onLevelTransition?.call();
    _resetDoorState();
  }

  void _reachedBackDoor() {
    print('Reached Back Door');
    reachedDoor = true;
    game.loadPreviousLevel();
    _resetDoorState();
  }

  void _resetDoorState() {
    // Reset the reachedDoor flag after a small delay to avoid double triggers
    Future.delayed(Duration(milliseconds: 500), () {
      reachedDoor = false;
    });
  }
}
