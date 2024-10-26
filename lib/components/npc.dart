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

enum NPCState { idle, walking }

class NPC extends SpriteAnimationGroupComponent
    with HasGameRef<Moonshiner>, CollisionCallbacks {
  final String npcCharacter;
  final List<String> dialogues; // Unique dialogues for each NPC type
  double moveSpeed = 50;
  Vector2 velocity = Vector2.zero();
  Vector2 initialPosition; // Define initialPosition
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    height: 28,
    width: 14,
  );

  bool playerColliding = false;
  bool playerHasInteracted = false;
  bool messageDisplayed = false;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation walkingAnimation;
  List<CollisionBlock> collisionBlocks = [];

  bool movingLeft = true;
  bool movingUp = true;
  double changeDirectionProbability = 0.003;
  int stillnessCounter = 0;
  int maxStillnessDuration = 60;

  // Dialogue display message
  HUDMessage hudMessage = HUDMessage(
    message: "",
    position: Vector2(100, 100),
  );

  Timer? randomDialogueTimer; // Timer for random dialogues

  NPC({
    required this.npcCharacter,
    required this.dialogues,
    position,
    size,
  })  : initialPosition = position ?? Vector2.zero(),
        super(position: position);

  @override
  FutureOr<void> onLoad() {
    priority = 2;
    _loadAllAnimations();
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    )..debugMode = false);

    randomDialogueTimer = Timer(
      Random().nextInt(6) + 5,
      onTick: _triggerRandomDialogue,
      repeat: true,
    )..start();

    return super.onLoad();
  }

  @override
  void onRemove() {
    randomDialogueTimer?.stop(); // Stop the timer when NPC is removed
    super.onRemove();
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    walkingAnimation = _spriteAnimation('Run', 12);

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

  @override
  void update(double dt) {
    super.update(dt);
    randomDialogueTimer?.update(dt); // Update the random dialogue timer

    final Vector2 currentPlayerPosition = gameRef.player.position;
    final double distanceToPlayer = currentPlayerPosition.distanceTo(position);
    const double stoppingDistance = 50.0;

    if (distanceToPlayer < stoppingDistance) {
      velocity = Vector2.zero();
      current = NPCState.idle;
    } else {
      _updateNPCMovement(dt);
      current = NPCState.walking;
    }

    _checkCollisions();
  }

  void _triggerRandomDialogue() {
    if (!playerColliding && !messageDisplayed) {
      hudMessage.message = dialogues[Random().nextInt(dialogues.length)];
      hudMessage.position = position + Vector2(0, -30);

      gameRef.add(hudMessage);
      messageDisplayed = true;

      Future.delayed(Duration(seconds: 3), () {
        if (messageDisplayed) {
          gameRef.remove(hudMessage);
          messageDisplayed = false;
        }
      });
    }
  }

  void stopDialogueTimer() {
    randomDialogueTimer?.stop();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      playerColliding = true;

      if (other.hasInteracted) {
        playerHasInteracted = true;

        hudMessage.message = dialogues[Random().nextInt(dialogues.length)];
        hudMessage.position = position + Vector2(0, -30);

        if (messageDisplayed) {
          gameRef.remove(hudMessage);
        }

        gameRef.add(hudMessage);
        messageDisplayed = true;

        other.hasInteracted = false;
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Player) {
      playerColliding = false;
      if (messageDisplayed) {
        gameRef.remove(hudMessage);
        messageDisplayed = false;
      }
      current = NPCState.walking;
    }
    super.onCollisionEnd(other);
  }

  void _updateNPCMovement(double dt) {
    switch (npcCharacter) {
      case 'Baker':
        _bakerMovement(dt);
        break;
      case 'Priest':
        _priestMovement(dt);
        break;
      case 'Journal Guy':
        _journalGuyMovement(dt);
        break;
      case 'Old Lady':
        _oldLadyMovement(dt);
        break;
      default:
        _bakerMovement(dt);
        break;
    }
  }

  void _bakerMovement(double dt) {
    if (movingLeft) {
      velocity.x = -moveSpeed;
      if (scale.x > 0) flipHorizontallyAroundCenter();
    } else {
      velocity.x = moveSpeed;
      if (scale.x < 0) flipHorizontallyAroundCenter();
    }

    position.x += velocity.x * dt;

    if (Random().nextDouble() < 0.02) {
      movingLeft = !movingLeft;
      velocity = Vector2.zero();
    }
  }

  void _priestMovement(double dt) {
    if (movingLeft) {
      velocity.x = -(moveSpeed * 0.5);
      if (scale.x > 0) flipHorizontallyAroundCenter();
    } else {
      velocity.x = moveSpeed * 0.5;
      if (scale.x < 0) flipHorizontallyAroundCenter();
    }

    position.x += velocity.x * dt;

    if (stillnessCounter <= 0) {
      stillnessCounter = Random().nextInt(180) + 120;
      velocity = Vector2.zero();
      movingLeft = !movingLeft;
    } else {
      stillnessCounter--;
    }
  }

  void _journalGuyMovement(double dt) {
    if (movingLeft) {
      velocity.x = moveSpeed * 1.5;
      if (scale.x < 0) flipHorizontallyAroundCenter();
    } else {
      velocity.x = -(moveSpeed * 1.5);
      if (scale.x > 0) flipHorizontallyAroundCenter();
    }

    position.x += velocity.x * dt;

    if (Random().nextDouble() < 0.05) {
      movingLeft = !movingLeft;
      velocity = Vector2.zero();
    }
  }

  void _oldLadyMovement(double dt) {
    if (movingLeft) {
      velocity.x = moveSpeed * 0.3;
      if (scale.x > 0) flipHorizontallyAroundCenter();
    } else {
      velocity.x = -moveSpeed * 0.3;
      if (scale.x < 0) flipHorizontallyAroundCenter();
    }

    position.x += velocity.x * dt;

    if (stillnessCounter <= 0) {
      stillnessCounter = Random().nextInt(100) + 80;
      velocity = Vector2.zero();
      movingLeft = !movingLeft;
    } else {
      stillnessCounter--;
    }
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

  void collidingWithPlayer() {
    velocity.x = 0;
    if (velocity.x < 0) {
      position.x = position.x + width + hitbox.offsetX;
    } else if (velocity.x > 0) {
      position.x = position.x - hitbox.offsetX - hitbox.width;
    }
  }
}
