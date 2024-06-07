import 'package:flame/components.dart';
import 'package:moonshiner_game/components/player.dart';
import 'package:moonshiner_game/moonshiner.dart';
import 'dart:math';

class Wife extends SpriteAnimationGroupComponent with HasGameRef<Moonshiner> {
  late final Player player;
  Vector2 velocity = Vector2.zero();
  double speed = 50; // Decreased speed to make her move more carefully
  bool facingRight = false;

  Wife({required this.player}) {
    // Set the initial position of the wife
    position = Vector2.all(100); // Change the initial position as needed

    // Share player's animations with the wife
    animations = player.animations;
    current = player.current;
  }

  @override
  void update(double dt) {
    // Calculate direction vector towards the player
    final Vector2 playerPosition = player.position;
    final Vector2 wifePosition = position;
    final Vector2 direction = playerPosition - wifePosition;

    // Normalize the direction vector
    if (direction.length > 0) {
      direction.normalize();

      // Calculate desired velocity
      final desiredVelocity = direction * speed;

      // Apply the velocity gradually to smooth out the movement
      final acceleration = (desiredVelocity - velocity) * 10 * dt;
      velocity += acceleration;

      // Update wife's current animation to match player's animation
      current = player.current;

      // Adjust wife's position to be beside the player
      final offset = player.scale.x > 0 ? Vector2(30, 0) : Vector2(-30, 0);
      final targetPosition = player.position - offset;

      // Calculate the distance between the wife and the target position
      final distanceToTarget = (targetPosition - position).length;

      // If the wife is not yet close to the target position, move her towards it
      if (distanceToTarget > 1) {
        // Calculate the movement vector towards the target position
        final moveVector = (targetPosition - position).normalized();

        // Calculate the movement speed based on the distance to the target
        final moveSpeed = min(speed * dt, distanceToTarget);

        // Apply the movement vector with the calculated speed
        position += moveVector * moveSpeed;
      }

      // Determine the direction the player is facing based on velocity and scale
      bool playerFacingRight = player.velocity.x >= 0;

      // Flip horizontally if necessary based on wife's position relative to the player
      if (playerFacingRight && !facingRight && position.x > player.position.x) {
        flipHorizontallyAroundCenter();
        facingRight = false;
      } else if (!playerFacingRight &&
          facingRight &&
          position.x < player.position.x) {
        flipHorizontallyAroundCenter();
        facingRight = true;
      }
    }

    super.update(dt);
  }
}
