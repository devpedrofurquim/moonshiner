import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HUDMessage extends Component {
  String message;
  Vector2 position;
  TextStyle textStyle;
  Color backgroundColor;
  EdgeInsets padding;
  BorderRadius borderRadius;
  Duration fadeInDuration;
  Duration fadeOutDuration;

  HUDMessage({
    required this.message,
    required this.position,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 20),
    this.backgroundColor = Colors.black,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.fadeInDuration = const Duration(milliseconds: 200),
    this.fadeOutDuration = const Duration(milliseconds: 200),
  });

  @override
  void render(Canvas canvas) {
    priority = 2;
    final paint = Paint()..color = backgroundColor;
    final rect = Rect.fromPoints(
      position.toOffset() - Offset(padding.left, padding.top),
      position.toOffset() +
          Offset(
            textPainter.width + padding.right,
            textPainter.height + padding.bottom,
          ),
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(rect,
          topLeft: borderRadius.topLeft,
          topRight: borderRadius.topRight,
          bottomLeft: borderRadius.bottomLeft,
          bottomRight: borderRadius.bottomRight),
      paint,
    );
    textPainter.paint(canvas, position.toOffset());
  }

  @override
  void update(double dt) {}

  TextPainter textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  void updateTextPainter() {
    final textSpan = TextSpan(text: message, style: textStyle);
    textPainter.text = textSpan;
    textPainter.layout();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    updateTextPainter();
  }
}
