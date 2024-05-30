import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';

class BackgroundTile extends ParallaxComponent {
  final String color;
  BackgroundTile({
    this.color = 'Gray',
    position,
  }) : super(
          position: position,
        );

  final double scrollSpeed = 10;

  @override
  FutureOr<void> onLoad() async {
    priority = -1;
    size = Vector2.all(64);
    parallax = await game.loadParallax(
        [ParallaxImageData('Background/$color.png')],
        baseVelocity: Vector2(-scrollSpeed, 0),
        repeat: ImageRepeat.repeat,
        fill: LayerFill.none);
    return super.onLoad();
  }
}
