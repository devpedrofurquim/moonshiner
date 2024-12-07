import 'dart:ui';

import 'package:moonshiner_game/components/npc.dart';
import 'package:flame/components.dart';

class WifesMom extends AbstractNPC {
  WifesMom({required Vector2 position})
      : super(
          npcCharacter: 'Wifes Mother',
          dialogues: [
            "Farewell, my dear daughter!",
            "Please take care of yourself and your husband.",
          ],
          position: position,
        );

  @override
  Color getColorForNPC() => const Color(0xFFFFAAAA); // Light pink for the mom

  @override
  void updateMovement(double dt) {
    // This NPC does not move, so velocity is always zero
    current = NPCState.idle;
    velocity = Vector2.zero();
  }
}
