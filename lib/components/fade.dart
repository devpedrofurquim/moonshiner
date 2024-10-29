import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class FadeEffect extends RectangleComponent {
  OpacityEffect? fadeEffect;

  FadeEffect(Vector2 screenSize)
      : super(
          size: screenSize,
          anchor: Anchor.topLeft,
          paint: Paint()
            ..color = Colors.black.withOpacity(0), // Start transparent
          priority:
              100, // High priority to ensure it renders above other components
        );

  void startFade() {
    // If a fade effect is already active, remove it
    if (fadeEffect != null) {
      fadeEffect?.removeFromParent();
    }

    // Create a new fade-in effect
    fadeEffect = OpacityEffect.to(
      1.0, // Target opacity (fully opaque)
      EffectController(duration: 1.0), // Duration in seconds
      onComplete: () {
        // Clear the effect after it completes
        fadeEffect = null;
      },
    );

    // Add the new effect to the component
    add(fadeEffect!);
  }
}
