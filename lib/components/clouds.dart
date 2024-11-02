import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';

class Clouds extends ParallaxComponent {
  Clouds({
    position,
  }) : super(
          position: position,
        );

  final double cloudScrollSpeed = 10; // Adjust for desired cloud speed

  @override
  FutureOr<void> onLoad() async {
    priority = -1;
    parallax = await game.loadParallax(
      [
        ParallaxImageData(
            'Background/clouds.png'), // Make sure you have a clouds image
      ],
      baseVelocity: Vector2(-cloudScrollSpeed, 0),
      repeat: ImageRepeat.repeatX,
      fill: LayerFill.height, // Stretch to fill the screen height
    );
    return super.onLoad();
  }
}
