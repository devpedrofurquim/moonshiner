import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DeveloperMessageComponent extends PositionComponent with HasGameRef {
  final String message;
  late TextComponent textComponent;
  late RectangleComponent backgroundBox;

  DeveloperMessageComponent({required this.message});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Style the text
    textComponent = TextComponent(
      text: message,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontFamily: 'Arial', // Change to a custom font if desired
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    // Background box with rounded corners and semi-transparency
    backgroundBox = RectangleComponent(
      size: Vector2(textComponent.width + 30, textComponent.height + 20),
      paint: Paint()..color = Colors.black.withOpacity(0.7),
    )
      ..position = Vector2(-15, -10) // Position to cover text with padding
      ..anchor = Anchor.topLeft;

    // Add the background box and text to this component
    add(backgroundBox);
    add(textComponent);

    // Position the message near the bottom center
    position = Vector2(
      gameRef.size.x / 2 - backgroundBox.width / 2,
      gameRef.size.y - backgroundBox.height - 50,
    );
  }

  void showWithTimeout(Duration duration) {
    // Add the message and remove it after the specified timeout
    Future.delayed(duration, () {
      removeFromParent();
    });
  }
}
