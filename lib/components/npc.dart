import 'dart:async';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:moonshiner_game/components/collision_block.dart';
import 'package:moonshiner_game/components/custom_hitbox.dart';
import 'package:moonshiner_game/components/dialogue.dart';
import 'package:moonshiner_game/components/player.dart';
import 'package:moonshiner_game/components/utils.dart';
import 'package:moonshiner_game/moonshiner.dart';

enum NPCState { idle, walking }

abstract class AbstractNPC extends SpriteAnimationGroupComponent
    with HasGameRef<Moonshiner>, CollisionCallbacks {
  final String npcCharacter;
  final List<String> dialogues;
  double moveSpeed = 50;
  Vector2 velocity = Vector2.zero();
  bool movingLeft = true;
  bool messageDisplayed = false;
  List<CollisionBlock> collisionBlocks = [];
  bool movingUp = true;
  double changeDirectionProbability = 0.003;
  int stillnessCounter = 0;
  int maxStillnessDuration = 60;
  int currentDialogueIndex = 0;

  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    height: 28,
    width: 14,
  );

  AbstractNPC({
    required this.npcCharacter,
    required this.dialogues,
    required Vector2 position,
    int priority = 50, // Set default priority here
  }) : super(position: position, priority: priority);

  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimations();
    add(RectangleHitbox()..debugMode = false); // Basic collision hitbox
    super.onLoad();
  }

  void _loadAllAnimations() {
    final idleAnimation = _spriteAnimation('Idle', 11);
    final walkingAnimation = _spriteAnimation('Run', 12);

    animations = {
      NPCState.idle: idleAnimation,
      NPCState.walking: walkingAnimation,
    };
    current = NPCState.walking;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      print("AbstractNPC collided with Player");
      collidingWithPlayer(); // Call your interaction logic here
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/Journal Guy/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.05,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void collidingWithPlayer() {
    if (!messageDisplayed && !gameRef.currentlySpeakingNPC) {
      showDialogue();
    }
  }

  void showDialogue(); // Define specific behavior in each subclass

  Color getColorForNPC(); // Define in each subclass

  @override
  void update(double dt) {
    final Vector2 playerPosition = gameRef.player.position;
    final double distanceToPlayer = playerPosition.distanceTo(position);

    _checkCollisions();

    if (distanceToPlayer < 50) {
      velocity = Vector2.zero();
      current = NPCState.idle;
    } else {
      updateMovement(dt);
      current = NPCState.walking;
    }

    position += velocity * dt;
    super.update(dt);
  }

  void _checkCollisions() {
    for (final block in collisionBlocks) {
      if (checkCollision(this, block)) {
        if (velocity.x != 0 || velocity.y != 0) {
          if (block.isWall) {
            if (velocity.x != 0) {
              movingLeft = !movingLeft;
            }
            if (velocity.y != 0) {
              movingUp = !movingUp;
              movingLeft = !movingLeft;
            }
          } else if (block.isGround) {
            if (velocity.y != 0) {
              movingUp = !movingUp;
            }
          } else {
            if (velocity.y != 0) {
              movingUp = !movingUp;
            }
            if (velocity.x != 0) {
              movingLeft = !movingLeft;
            }
          }
        } else {
          if (stillnessCounter <= 0) {
            stillnessCounter = Random().nextInt(maxStillnessDuration) + 1;
            movingLeft = Random().nextBool();
            movingUp = Random().nextBool();
          } else {
            stillnessCounter--;
          }
        }
      }
    }
  }

  void updateMovement(double dt);
}
