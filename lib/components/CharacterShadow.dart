import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CharacterShadow extends PositionComponent {
  @override
  void render(Canvas canvas) {
    // Draw an ellipse for the shadow
    final paint = Paint()..color = Colors.black.withOpacity(0.5);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y),
        width: size.x * 0.8,
        height: size.y * 0.2,
      ),
      paint,
    );
  }
}
