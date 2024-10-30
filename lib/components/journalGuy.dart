import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:moonshiner_game/components/dialogue.dart';
import 'package:moonshiner_game/components/npc.dart';

class JournalGuy extends AbstractNPC {
  JournalGuy({required Vector2 position})
      : super(
          npcCharacter: 'Journal Guy',
          dialogues: [
            "News of the day! Get your news here!",
            "Rumor has it, strange things are happening.",
            "Can’t keep secrets in this town.",
          ],
          position: position,
        );

  @override
  Color getColorForNPC() =>
      Color(0xFF800080); // Use a pure Color instead of MaterialColor

  @override
  void updateMovement(double dt) {
    if (movingLeft) {
      velocity.x = moveSpeed * 1.5;
      if (scale.x < 0) flipHorizontallyAroundCenter();
    } else {
      velocity.x = -(moveSpeed * 1.5);
      if (scale.x > 0) flipHorizontallyAroundCenter();
    }

    if (Random().nextDouble() < 0.05) {
      movingLeft = !movingLeft;
      velocity = Vector2.zero();
    }
  }
}
