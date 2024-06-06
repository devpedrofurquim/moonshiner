import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:moonshiner_game/components/button.dart';
import 'package:moonshiner_game/components/level.dart';
import 'package:moonshiner_game/components/player.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'components/enemy.dart';
import 'components/hud.dart';

class Moonshiner extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  late HUDMessage hudMessage; // Declare HUDMessage variable

  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late JoystickComponent joyStick;
  // true for mobile - false for desktop
  bool showControls = true;
  late CameraComponent cam;
  Player player = Player(character: 'Guy');
  Enemy enemy = Enemy(
    enemyCharacter: 'Mask Dude',
  );
  List<String> levelNames = ['Level-01', 'Level-02'];
  int currentLevelindex = 0;
  bool playSounds = false;
  double soundVolume = 1.0;
  @override
  FutureOr<void> onLoad() async {
    // load all images into cache
    await images.loadAllImages();

    _loadLevel(currentLevelindex);

    if (showControls) {
      addControls();
    }

    return super.onLoad();
  }

  void playBackgroundMusicForLevel(String levelName) {
    // Stop any currently playing music
    FlameAudio.bgm.stop();

    // Determine which music to play based on the level
    String musicFileName;
    switch (levelName) {
      case 'Level-01':
        musicFileName = 'the_farewell_ost.wav';
        break;
      case 'Level-02':
        musicFileName = 'moonshine_ost.mp3';
        break;
      // Add cases for other levels as needed
      default:
        musicFileName = 'default_music.mp3';
        break;
    }

    // Play the background music for the level
    FlameAudio.bgm.play(musicFileName, volume: 1.0);
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateControls();
    }
    super.update(dt);
  }

  void addControls() {
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
    add(Button());
  }

  void updateControls() {
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

  @override
  void pause() {
    pauseEngine();
  }

  @override
  void resume() {
    resumeEngine();
  }

  void loadNextLevel() {
    if (currentLevelindex < levelNames.length - 1) {
      currentLevelindex++;
    } else {
      currentLevelindex = 0;
    }
    _loadLevel(currentLevelindex);
  }

  void loadLastlevel() {
    if (currentLevelindex > 0) {
      currentLevelindex--;
      _loadLevel(currentLevelindex);
    } else {
      currentLevelindex = 0;
      _loadLevel(currentLevelindex);
    }
  }

  void _loadLevel(currentLevelindex) {
    @override
    final world = Level(
        levelName: levelNames[currentLevelindex], player: player, enemy: enemy);

    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    cam.priority = 1;
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);
  }
}
