import 'dart:ui';

import 'package:moonshiner_game/components/dialogue.dart';

class NPCDialogueWithReset extends NPCDialogueComponent {
  final VoidCallback onDialogueEnd;

  NPCDialogueWithReset({
    required List<String> messages,
    required Color npcColor,
    required this.onDialogueEnd,
  }) : super(messages: messages, npcColor: npcColor);

  @override
  void onRemove() {
    onDialogueEnd(); // Call the callback when removed
    super.onRemove();
  }
}
