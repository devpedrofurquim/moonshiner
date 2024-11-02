import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:moonshiner_game/components/dialogue.dart';
import 'package:moonshiner_game/components/player.dart';
import 'package:moonshiner_game/moonshiner.dart';
import 'dart:math';

import 'custom_hitbox.dart';
import 'hud.dart';

class Wife extends SpriteAnimationGroupComponent
    with HasGameRef<Moonshiner>, CollisionCallbacks {
  String character;
  late final Player player;
  late SpriteAnimation idleAnimation;
  late SpriteAnimation runningAnimation;
  final double stepTime = 0.05;
  bool playerColliding = false;
  Vector2 velocity = Vector2.zero();
  double speed = 50;
  NPCDialogueComponent? dialogueComponent;
  bool facingRight = true;
  double minDistance = 50;
  bool hasDialogue = false;
  bool hasSpokenOnCollision = false;

  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    height: 28,
    width: 14,
  );

  List<String> dialogues = [
    "I really love you, darling!",
    "What are you thinking about?",
    "I'm tired! Need rest.",
    "Do you want to eat something?"
  ]; // Make sure `dialogues` is not final so it can be modified.

  int currentDialogueIndex = 0;
  bool messageDisplayed = false;
  HUDMessage? hudMessage;
  Wife({
    required this.player,
    this.character = 'Mask Dude',
  }) {
    // Set the initial position of the wife
    position = Vector2.all(100); // Change the initial position as needed
  }

  @override
  Future<void> onLoad() async {
    priority = 2;
    await _loadAllAnimations();
    add(RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height)));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    final Vector2 playerPosition = player.position;
    final Vector2 direction = playerPosition - position;

    final double distanceToPlayer = direction.length;

    if (distanceToPlayer > minDistance) {
      direction.normalize();
      final desiredVelocity = direction * speed;
      velocity += (desiredVelocity - velocity) * 10 * dt;
      position += velocity * dt;
      current = PlayerState.running;

      bool playerFacingRight = player.velocity.x >= 0;
      if (playerFacingRight && !facingRight) {
        flipHorizontallyAroundCenter();
        facingRight = true;
      } else if (!playerFacingRight && facingRight) {
        flipHorizontallyAroundCenter();
        facingRight = false;
      }
    } else {
      velocity = Vector2.zero();
      current = PlayerState.idle;
    }

    super.update(dt);
  }

  void _showDialogue(String message) {
    if (dialogueComponent != null) {
      gameRef.remove(dialogueComponent!);
    }

    // Create and display the new dialogue message
    dialogueComponent = NPCDialogueComponent(
      messages: [message],
      npcColor: Color(0xFF800080), // Use a pure Color instead of MaterialColor
    );
    gameRef.add(dialogueComponent!);
    messageDisplayed = true;
  }

  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      playerColliding = true;

      // Advance dialogue if the player interacts
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
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Player && messageDisplayed) {
      // Clear dialogue when player leaves
      if (dialogueComponent != null) {
        gameRef.remove(dialogueComponent!);
        dialogueComponent = null;
      }
      messageDisplayed = false;
      hasDialogue = false; // Reset dialogue state
    }
    super.onCollisionEnd(other);
  }

  Future<void> _loadAllAnimations() async {
    idleAnimation = await _spriteAnimation('Idle', 11);
    runningAnimation = await _spriteAnimation('Run', 12);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation
    };

    current = PlayerState.running;
  }

  Future<SpriteAnimation> _spriteAnimation(String state, int amount) async {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$state (32x32).png'),
        SpriteAnimationData.sequenced(
          amount: amount,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
        ));
  }
}
