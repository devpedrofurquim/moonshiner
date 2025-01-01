import 'dart:math';
import 'dart:ui';
import 'package:moonshiner_game/components/CharacterShadow.dart';
import 'package:moonshiner_game/components/npc.dart';
import 'package:flame/components.dart';
import 'package:moonshiner_game/components/utils.dart';

class WifesFather extends AbstractNPC {
  WifesFather({required Vector2 position})
      : super(
          npcCharacter: 'Wifes Father',
          dialogues: [
            "Goodbye, my son-in-law!",
            "Take care of our daughter and future grandchild.",
          ],
          position: position,
        );

  @override
  Future<void> onLoad() async {
    loadAllAnimations();

    // Create a shadow component
    final shadow = CharacterShadow()
      ..size = Vector2(16, 4) // Adjust size based on your character
      ..position =
          Vector2(8, size.y - 4); // Position the shadow below the character

    // Add the shadow as a child
    add(shadow);
    return super.onLoad();
  }

  @override
  Color getColorForNPC() => const Color(0xFFFFAAAA); // Light pink for the mom

  @override
  void loadAllAnimations() {
    final idleAnimation = spriteAnimation('Idle', 11);
    final walkingAnimation = spriteAnimation('Run', 11);

    animations = {
      NPCState.idle: idleAnimation,
      NPCState.walking: walkingAnimation,
    };
    current = NPCState.idle;
  }

  @override
  SpriteAnimation spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/Wife Father/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.05,
        textureSize: Vector2.all(32),
      ),
    );
  }

  @override
  void update(double dt) {
    checkCollisions();

    velocity = Vector2.all(0);

    super.update(dt);
  }

  @override
  void checkCollisions() {}

  @override
  void updateMovement(double dt) {
    // TODO: implement updateMovement
  }
}
