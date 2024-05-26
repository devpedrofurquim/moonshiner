import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:moonshiner_game/components/level.dart';
import 'package:moonshiner_game/components/player.dart';
import 'package:flame/input.dart';

class Moonshiner extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late JoystickComponent joyStick;
  // true for mobile - false for desktop
  bool showJoyStick = true;
  late final CameraComponent cam;
  Player player = Player(character: 'Guy');
  @override
  FutureOr<void> onLoad() async {
    // load all images into cache
    await images.loadAllImages();

    @override
    final world = Level(levelName: 'Level-01', player: player);

    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    cam.priority = 1;
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    if (showJoyStick) {
      addJoyStick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoyStick) {
      updateJoyStick();
    }
    super.update(dt);
  }

  void addJoyStick() {
    joyStick = JoystickComponent(
      priority: 2,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/knob.png'),
        ),
      ),
      knobRadius: 32,
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joyStick);
  }

  void updateJoyStick() {
    switch (joyStick.direction) {
      case JoystickDirection.left:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
        player.horizontalMovement = 1;
        break;
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        player.verticalMovement = 1;
        break;
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        player.verticalMovement = 1;
        break;
      case JoystickDirection.down:
        player.verticalMovement = 1;
        break;
      case JoystickDirection.up:
        player.verticalMovement = -1;
        break;
      case JoystickDirection.upRight:
        player.horizontalMovement = 1;
        player.verticalMovement = -1;
        break;
      case JoystickDirection.upLeft:
        player.horizontalMovement = -1;
        player.verticalMovement = -1;
        break;
      default:
        player.horizontalMovement = 0;
        player.verticalMovement = 0;
        break;
    }
  }
}
