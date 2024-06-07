import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
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
  bool playerColliding = false; // Flag to track player collision
  bool playerHasInteracted = false;
  bool messageDisplayed = false; // Flag to track if the message is displayed
  Vector2 velocity = Vector2.zero();
  double speed = 50; // Speed of the wife
  bool facingRight = true;
  double minDistance =
      50; // Minimum distance she should maintain from the player

  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    height: 28,
    width: 14,
  );

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

  bool isMessage = false; // Declare a variable to store the HUDMessage

  HUDMessage hudMessage = HUDMessage(
    message: "Hello!",
    position: Vector2(100, 100), // Adjust position as needed
  );

  List<String> dialogues = [
    "I really love you darling!",
    "What are you thinking about?",
    "I'm tired! Need rest",
    "Do you want to eat something?"
  ];
  int currentDialogueIndex = 0;

  bool hasDisplayedNewDialogue =
      false; // Track if new dialogue has been displayed

  @override
  void update(double dt) {
    // Calculate direction vector towards the player
    final Vector2 playerPosition = player.position;
    final Vector2 direction = playerPosition - position;

    // Calculate the distance to the player
    final double distanceToPlayer = direction.length;

    // Normalize the direction vector if she is farther than the minimum distance
    if (distanceToPlayer > minDistance) {
      direction.normalize();

      // Calculate desired velocity
      final desiredVelocity = direction * speed;

      // Smooth out the movement by interpolating velocity
      velocity += (desiredVelocity - velocity) * 10 * dt;

      // Update wife's position
      position += velocity * dt;

      // Set animation to walking
      current = PlayerState.running;

      // Determine the direction the player is facing
      bool playerFacingRight = player.velocity.x >= 0;

      // Flip horizontally if necessary based on wife's position relative to the player
      if (playerFacingRight && !facingRight) {
        flipHorizontallyAroundCenter();
        facingRight = true;
      } else if (!playerFacingRight && facingRight) {
        flipHorizontallyAroundCenter();
        facingRight = false;
      }
    } else {
      // If she is within the minimum distance, stop moving and switch to idle animation
      velocity = Vector2.zero();
      current = PlayerState.idle;
    }

    super.update(dt);
  }

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
