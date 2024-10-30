import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:moonshiner_game/components/dialogue.dart';
import 'package:moonshiner_game/components/npc.dart';

class OldLady extends AbstractNPC {
  OldLady({required Vector2 position})
      : super(
          npcCharacter: 'Old Lady',
          dialogues: [
            "In my day, things were different.",
            "I’ve lived here my whole life.",
            "Be careful, dear.",
          ],
          position: position,
        );

  @override
  Color getColorForNPC() =>
      Color(0xFF800080); // Use a pure Color instead of MaterialColor

  @override
  void updateMovement(double dt) {
    if (movingLeft) {
      velocity.x = moveSpeed * 0.3;
      if (scale.x > 0) flipHorizontallyAroundCenter();
    } else {
      velocity.x = -moveSpeed * 0.3;
      if (scale.x < 0) flipHorizontallyAroundCenter();
    }

    if (Random().nextDouble() < 0.02) {
      movingLeft = !movingLeft;
      velocity = Vector2.zero();
    }
  }
}
