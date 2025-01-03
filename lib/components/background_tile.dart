import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';

class BackgroundTile extends ParallaxComponent {
  BackgroundTile({
    position,
  }) : super(
          position: position,
        );

  final double scrollSpeed = 1;

  @override
  FutureOr<void> onLoad() async {
    priority = -1;
    parallax = await game.loadParallax(
      [
        ParallaxImageData('Background/new_sky.png'), // Use the new image
      ],
      baseVelocity:
          Vector2(-scrollSpeed, 0), // Adjust scroll speed if necessary
      repeat: ImageRepeat.repeatX, // Only repeat horizontally
      fill: LayerFill.height, // Stretch to fill the screen height
    );
    return super.onLoad();
  }
}
