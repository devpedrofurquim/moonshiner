import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HUDMessage extends Component {
  String message;
  Vector2 position;

  HUDMessage({required this.message, required this.position});

  @override
  void render(Canvas canvas) {
    priority = 2;
    final textStyle = TextStyle(color: Colors.white, fontSize: 20);
    final textSpan = TextSpan(text: message, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, position.toOffset());
  }

  @override
  void update(double dt) {}
}
