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
  bool messageDisplayed = false; // Flag for active dialogue
  bool hasSpokenOnCollision = false;
  bool hasDialogue = false; // Track if dialogue is currently displayed
  NPCDialogueComponent? dialogueComponent; // Store dialogue component
  List<CollisionBlock> collisionBlocks = [];
  bool movingUp = true;
  double changeDirectionProbability = 0.003;
  int stillnessCounter = 0;
  int maxStillnessDuration = 60;
  int currentDialogueIndex = 0;

  // Add this field for player interaction callbacks
  void Function()? onPlayerInteraction;

  AbstractNPC({
    required this.npcCharacter,
    required this.dialogues,
    required Vector2 position,
    int priority = 50,
  }) : super(position: position, priority: priority);

  @override
  Future<void> onLoad() async {
    _loadAllAnimations();
    add(RectangleHitbox()..debugMode = false);
    return super.onLoad();
  }

  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    height: 28,
    width: 14,
  );

  void _loadAllAnimations() {
    final idleAnimation = _spriteAnimation('Idle', 11);
    final walkingAnimation = _spriteAnimation('Run', 12);

    animations = {
      NPCState.idle: idleAnimation,
      NPCState.walking: walkingAnimation,
    };
    current = NPCState.walking;
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

  void _showDialogue(String message) {
    // Clear any existing dialogue
    if (dialogueComponent != null) {
      gameRef.remove(dialogueComponent!);
    }

    // Create and display the new dialogue message
    dialogueComponent = NPCDialogueComponent(
      messages: [message],
      npcColor: getColorForNPC(),
    );
    gameRef.add(dialogueComponent!);
    messageDisplayed = true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      // Check if player has interacted
      if (other.hasInteracted) {
        // Move to the next dialogue, loop back if at the end
        currentDialogueIndex = (currentDialogueIndex + 1) % dialogues.length;

        // Show the next dialogue message
        _showDialogue(dialogues[currentDialogueIndex]);
        other.hasInteracted = false; // Reset interaction flag in Player
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      if (!hasDialogue) {
        // Reset dialogue index for fresh start on first collision
        currentDialogueIndex = 0;
        _showDialogue(dialogues[currentDialogueIndex]);
        hasDialogue = true;
      }
      other.isInteractingWithNPC = true;
      hasSpokenOnCollision = true;

      // Trigger the interaction callback if assigned
      if (onPlayerInteraction != null) {
        onPlayerInteraction!(); // Call the assigned interaction callback
        print("onPlayerInteraction triggered for NPC: $npcCharacter");
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Player && messageDisplayed) {
      // Clear dialogue when the player leaves
      if (dialogueComponent != null && dialogueComponent!.isMounted) {
        gameRef.remove(dialogueComponent!);
        dialogueComponent = null;
      }
      messageDisplayed = false;
      hasDialogue = false; // Reset dialogue state
    }
    super.onCollisionEnd(other);
  }

  @override
  void update(double dt) {
    final Vector2 playerPosition = gameRef.player.position;
    final double distanceToPlayer = playerPosition.distanceTo(position);

    _checkCollisions();

    // Show dialogue if player is close, hide if far away
    if (distanceToPlayer < 50) {
      // Adjust the range as needed
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

  Color getColorForNPC(); // Defined in subclasses
}
