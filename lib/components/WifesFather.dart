import 'dart:ui';

import 'package:moonshiner_game/components/npc.dart';
import 'package:flame/components.dart';

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
  Color getColorForNPC() => const Color(0xFFAA0000); // Dark red for the father

  @override
  void updateMovement(double dt) {
    // This NPC does not move, so velocity is always zero
    current = NPCState.idle;
    velocity = Vector2.zero();
  }
}
