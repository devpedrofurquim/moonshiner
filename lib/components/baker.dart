import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:moonshiner_game/components/dialogue.dart';
import 'package:moonshiner_game/components/npc.dart';

class Baker extends AbstractNPC {
  Baker({required Vector2 position})
      : super(
          npcCharacter: 'Baker',
          dialogues: [
            "Fresh bread today!",
            "A hard day’s work, but worth it.",
            "Care for a slice?",
          ],
          position: position,
        );

  @override
  Color getColorForNPC() => Colors.brown;

  @override
  void showDialogue() {
    if (messageDisplayed) return;

    final message = dialogues[currentDialogueIndex];
    currentDialogueIndex = (currentDialogueIndex + 1) % dialogues.length;

    final npcDialogue = NPCDialogueComponent(
      message: message,
      npcColor: getColorForNPC(),
    );

    gameRef.add(npcDialogue);
    npcDialogue.showWithTimeout(
        Duration(seconds: 2)); // Shorter duration for JournalGuy

    messageDisplayed = true;
    Future.delayed(Duration(seconds: 2), () {
      messageDisplayed = false;
    });
  }

  @override
  void updateMovement(double dt) {
    if (movingLeft) {
      velocity.x = -moveSpeed;
      if (scale.x > 0) flipHorizontallyAroundCenter();
    } else {
      velocity.x = moveSpeed;
      if (scale.x < 0) flipHorizontallyAroundCenter();
    }

    if (Random().nextDouble() < 0.02) {
      movingLeft = !movingLeft;
      velocity = Vector2.zero();
    }
  }
}
