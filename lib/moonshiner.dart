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
import 'components/enemy.dart';
import 'components/hud.dart';

class Moonshiner extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  late HUDMessage hudMessage;

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late JoystickComponent joyStick;
  late Button interactButton;

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
    await images.loadAllImages();
    addControls();
    _loadLevel(currentLevelindex);
    return super.onLoad();
  }

  void playBackgroundMusicForLevel(String levelName) {
    FlameAudio.bgm.stop();
    String musicFileName;
    switch (levelName) {
      case 'Level-01':
        musicFileName = 'the_farewell_ost.wav';
        break;
      case 'Level-02':
        musicFileName = 'moonshine_ost.mp3';
        break;
      default:
        musicFileName = 'default_music.mp3';
        break;
    }
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

    interactButton = Button();

    add(joyStick);
    add(interactButton);
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
    } else {
      currentLevelindex = 0;
    }
    _loadLevel(currentLevelindex);
  }

  void _loadLevel(int currentLevelindex) {
    children.whereType<PositionComponent>().forEach((component) {
      if (component != joyStick && component != interactButton) {
        component.removeFromParent();
      }
    });

    player = Player(character: 'Guy', position: Vector2(100, 100));
    enemy = Enemy(
      enemyCharacter: 'Mask Dude',
      position: Vector2(200, 100),
    );

    final world = Level(
      levelName: levelNames[currentLevelindex],
      player: player,
      enemy: enemy,
    );

    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );
    cam.priority = 1;
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    if (!contains(joyStick) && showControls) {
      add(joyStick);
    }

    if (!contains(interactButton) && showControls) {
      add(interactButton);
    }

    playBackgroundMusicForLevel(levelNames[currentLevelindex]);
  }
}
