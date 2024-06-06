import 'dart:async';
import 'dart:math';
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
  bool playerHasInteracted = false;
  bool messageDisplayed = false; // Flag to track if the message is displayed
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation walkingAnimation;
  List<CollisionBlock> collisionBlocks = [];

  bool movingLeft = true;
  bool movingUp = true;
  double changeDirectionProbability =
      0.003; // Adjust this probability as needed
  int stillnessCounter = 0; // Counter to track remaining stillness duration
  int maxStillnessDuration =
      60; // Maximum duration for stillness (adjust as needed)

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

  List<String> dialogues = [
    "Stay back!",
    "This is my territory!",
    "I won't let you pass!",
    "You dare challenge me?"
  ];
  int currentDialogueIndex = 0;

  bool hasDisplayedNewDialogue =
      false; // Track if new dialogue has been displayed

  @override
  void update(double dt) {
    // Handle enemy movement
    if (playerColliding) {
      current =
          EnemyState.idle; // Stop enemy movement when colliding with player
    } else {
      _updateEnemyMovement(dt);
    }

    // Check collisions
    _checkCollisions();

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      playerColliding = true;

      // Check if the player has interacted
      if (other.hasInteracted) {
        playerHasInteracted = true;

        // Move to the next dialogue, loop back if at the end
        currentDialogueIndex = (currentDialogueIndex + 1) % dialogues.length;

        // Show the next dialogue message
        hudMessage.message = dialogues[currentDialogueIndex];
        hudMessage.position = position + Vector2(0, -30);

        // Remove the previously displayed dialogue message
        if (messageDisplayed) {
          gameRef.remove(hudMessage);
        }

        // Add the new dialogue message to the game
        gameRef.add(hudMessage);
        messageDisplayed = true;

        other.hasInteracted = false; // Reset the interaction flag in Player
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Player) {
      playerColliding = false; // Reset flag when player collision ends
      // Remove message from the game
      if (messageDisplayed) {
        gameRef.remove(hudMessage);
        messageDisplayed = false;
      }
      current = EnemyState.walking;
    }
    super.onCollisionEnd(other);
  }

  void _updateEnemyMovement(double dt) {
    // Apply horizontal movement
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

    // Apply vertical movement
    if (movingUp) {
      velocity.y = -moveSpeed;
    } else {
      velocity.y = moveSpeed;
    }

    // Introduce random changes in direction
    if (Random().nextDouble() < changeDirectionProbability) {
      movingLeft = !movingLeft;
    }
    if (Random().nextDouble() < changeDirectionProbability) {
      movingUp = !movingUp;
    }

    // Update position
    position.x += velocity.x * dt;
    position.y += velocity.y * dt;
  }

  void _checkCollisions() {
    for (final block in collisionBlocks) {
      if (checkCollision(this, block)) {
        if (velocity.x != 0 || velocity.y != 0) {
          // Enemy is currently moving
          if (block.isWall) {
            // Handle wall collision
            if (velocity.x != 0) {
              movingLeft = !movingLeft;
            }
            if (velocity.y != 0) {
              movingUp = !movingUp;
              movingLeft = !movingLeft;
            }
          } else if (block.isGround) {
            // Handle ground collision
            if (velocity.y != 0) {
              movingUp = !movingUp;
            }
          } else {
            // Handle collision with other obstacles
            if (velocity.y != 0) {
              movingUp = !movingUp;
            }
            if (velocity.x != 0) {
              movingLeft = !movingLeft;
            }
          }
        } else {
          // Enemy is currently still
          if (stillnessCounter <= 0) {
            // Stillness period is over, resume walking
            stillnessCounter = Random().nextInt(maxStillnessDuration) + 1;
            movingLeft = Random().nextBool();
            movingUp = Random().nextBool();
          } else {
            // Decrement stillness counter
            stillnessCounter--;
          }
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
