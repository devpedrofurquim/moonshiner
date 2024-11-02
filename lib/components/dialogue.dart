import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class NPCDialogueComponent extends PositionComponent with HasGameRef {
  List<String> messages;
  final Color npcColor;
  int currentMessageIndex = 0;
  late TextComponent textComponent;
  late RectangleComponent backgroundBox;
  late RectangleComponent npcIndicatorBox;
  late Timer typewriterTimer;
  String displayedText = '';
  bool isTyping = true;

  NPCDialogueComponent({
    required this.messages,
    required this.npcColor,
  }) {
    priority = 100;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    textComponent = TextComponent(
      text: '',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18.0, // Reduced font size
          fontFamily: 'Arial',
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    backgroundBox = RectangleComponent(
      size: Vector2(textComponent.width + 20, textComponent.height + 16),
      paint: Paint()..color = Colors.black.withOpacity(0.85),
    );

    npcIndicatorBox = RectangleComponent(
      size: Vector2(10, textComponent.height + 16), // Reduced indicator size
      paint: Paint()..color = npcColor,
    );

    add(npcIndicatorBox);
    add(backgroundBox);
    add(textComponent);

    // Center the dialogue box on the screen
    position = Vector2(
      gameRef.size.x / 2 - (backgroundBox.size.x / 2),
      gameRef.size.y - 100, // Adjusted to move it slightly higher
    );

    _showMessageWithTypewriter(messages[currentMessageIndex]);
  }

  void _showMessageWithTypewriter(String message) {
    displayedText = '';
    isTyping = true;
    typewriterTimer = Timer(0.05, repeat: true, onTick: () {
      if (displayedText.length < message.length) {
        displayedText += message[displayedText.length];
        textComponent.text = displayedText;

        backgroundBox.size =
            Vector2(textComponent.width + 20, textComponent.height + 16);
        npcIndicatorBox.size = Vector2(10, backgroundBox.height);

        textComponent.position = Vector2(
          backgroundBox.size.x / 2 - textComponent.width / 2,
          backgroundBox.size.y / 2 - textComponent.height / 2,
        );

        npcIndicatorBox.position = Vector2(-npcIndicatorBox.width - 5, 0);
      } else {
        isTyping = false;
        typewriterTimer.stop();
      }
    });
    typewriterTimer.start();
  }

  void updateMessage(String newMessage) {
    displayedText = '';
    _showMessageWithTypewriter(newMessage);
  }

  void clearMessageWithTypewriter() {
    isTyping = true;
    typewriterTimer = Timer(0.05, repeat: true, onTick: () {
      if (displayedText.isNotEmpty) {
        displayedText = displayedText.substring(0, displayedText.length - 1);
        textComponent.text = displayedText;
      } else {
        isTyping = false;
        typewriterTimer.stop();
        removeFromParent();
      }
    });
    typewriterTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    typewriterTimer.update(dt);
  }
}
