import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class NPCDialogueComponent extends PositionComponent with HasGameRef {
  final String message;
  final Color npcColor; // Unique color representing the NPC
  late TextComponent textComponent;
  late RectangleComponent backgroundBox;
  late RectangleComponent npcIndicatorBox;

  NPCDialogueComponent({
    required this.message,
    required this.npcColor,
  }) {
    priority = 100; // Display above other components
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Style the dialogue text
    textComponent = TextComponent(
      text: message,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24.0, // Increased font size
          fontFamily: 'Arial',
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    // Background box for the text with additional padding
    backgroundBox = RectangleComponent(
      size: Vector2(textComponent.width + 70, textComponent.height + 40),
      paint: Paint()..color = Colors.black.withOpacity(0.85),
    )
      ..position =
          Vector2(30, 10) // Position with padding for the NPC indicator
      ..anchor = Anchor.topLeft;

    // NPC color indicator box
    npcIndicatorBox = RectangleComponent(
      size: Vector2(30, textComponent.height + 40), // Increased size
      paint: Paint()..color = npcColor,
    )
      ..position = Vector2(0, 10) // Positioned on the left with padding
      ..anchor = Anchor.topLeft;

    // Add components to the dialogue component
    add(npcIndicatorBox);
    add(backgroundBox);
    add(textComponent);

    // Position the dialogue component at the bottom of the screen
    position = Vector2(
      gameRef.size.x / 2 - backgroundBox.width / 2,
      gameRef.size.y - backgroundBox.height - 80, // Move it up a bit
    );

    // Center the text inside the background box
    textComponent.position = backgroundBox.size / 2 - textComponent.size / 2;
  }

  void showWithTimeout(Duration duration) {
    // Show the dialogue and remove it after the specified timeout
    Future.delayed(duration, () {
      removeFromParent();
    });
  }
}
