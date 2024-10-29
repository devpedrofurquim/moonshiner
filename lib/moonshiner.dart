import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/painting.dart';
import 'package:moonshiner_game/components/button.dart';
import 'package:moonshiner_game/components/developer_message.dart';
import 'package:moonshiner_game/components/fade.dart';
import 'package:moonshiner_game/components/level_one.dart';
import 'package:moonshiner_game/components/npc.dart';
import 'package:moonshiner_game/components/player.dart';
import 'package:moonshiner_game/components/level.dart'; // Use Level directly
import 'components/hud.dart';

class Moonshiner extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  // UI Components
  late JoystickComponent joyStick;
  late Button interactButton;
  List<NPC> activeNpcs = []; // Track active NPCs in the current level
  late HUDMessage hudMessage;

  bool hasShownLevelOneIntro =
      false; // Track if LevelOne intro message has been shown

  // Game State Variables
  bool showControls = true;
  bool playSounds = true;
  double soundVolume = 1.0;

  bool currentlySpeakingNPC = false; // Track if an NPC is speaking

  String developerMessage =
      ''; // Shared variable to store the developer message

  // Player and Camera Components
  late CameraComponent cam;
  Player player = Player(character: 'Guy');

  // Level Management
  List<String> levelNames = ['Level-01', 'Level-02'];
  int currentLevelIndex = 0;

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();
    _initializeControls();

    FlameAudio.bgm.initialize(); // This will set up the background music system

    // Directly load the initial level and set up the camera
    _loadLevel(currentLevelIndex);
    return super.onLoad();
  }

  void showDeveloperMessage(String message) {
    print("showDeveloperMessage called with message: $message");

    // Remove any existing message to prevent duplicates
    children.removeWhere((component) => component is DeveloperMessageComponent);

    final developerMessageComponent = DeveloperMessageComponent(
      message: message,
    )..priority = 100; // Set a high priority to render above other components

    add(developerMessageComponent);
    developerMessageComponent
        .showWithTimeout(Duration(seconds: 4)); // Display for 4 seconds

    print("Developer message added to the game.");
  }

  // Method to hide the developer message overlay
  void hideDeveloperMessage() {
    overlays.remove('DeveloperMessage'); // Remove the overlay
  }

  void _setupCamera(Level level) {
    cam = CameraComponent.withFixedResolution(
      world: level, // Directly set the current level as the world
      width: 640,
      height: 360,
    )
      ..priority = 1
      ..viewfinder.anchor = Anchor.topLeft;
    add(cam);
  }

  void _loadLevel(int index) {
    // Remove existing components except joystick and interact button
    children.whereType<PositionComponent>().forEach((component) {
      if (component != joyStick && component != interactButton) {
        component.removeFromParent();
      }
    });

    // Initialize player and set position
    player = Player(character: 'Guy', position: Vector2(100, 100));

    late final level;

    // Create new level instance
    if (index == 0) {
      level = LevelOne(
        levelName: levelNames[index],
        player: player,
      );
    } else {
      level = Level(
        levelName: levelNames[index],
        player: player,
      );
    }

    // Set up the camera for the new level and add level to the game
    _setupCamera(level);
    add(level);

    playBackgroundMusicForLevel(levelNames[index]);
  }

  // Music Control for Level
  void playBackgroundMusicForLevel(String levelName) {
    final musicFileName = switch (levelName) {
      'Level-01' => 'the_farewell_ost.wav',
      'Level-02' => 'moonshine_ost.mp3',
      _ => 'default_music.mp3',
    };
    playBackgroundMusic(musicFileName);
  }

  void playBackgroundMusic(String fileName) async {
    try {
      // Stop any currently playing background music
      await FlameAudio.bgm.stop();

      // Play the audio file without the volume parameter
      await FlameAudio.bgm.play(fileName);
    } catch (e) {
      print("Error playing background music: $e");
    }
  }

  @override
  void update(double dt) {
    if (showControls) {
      _updateControls();
    }
    super.update(dt);
  }

  // Adding Controls to the Game
  void _initializeControls() {
    joyStick = JoystickComponent(
      priority: 2,
      knob: SpriteComponent(sprite: Sprite(images.fromCache('HUD/knob.png'))),
      knobRadius: 32,
      background:
          SpriteComponent(sprite: Sprite(images.fromCache('HUD/joystick.png'))),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    interactButton = Button();
    add(joyStick);
    add(interactButton);
  }

  // Updating Controls Based on Joystick Input
  void _updateControls() {
    double horizontalMovement = 0;
    double verticalMovement = 0;

    switch (joyStick.direction) {
      case JoystickDirection.left:
        horizontalMovement = -1;
        break;
      case JoystickDirection.right:
        horizontalMovement = 1;
        break;
      case JoystickDirection.up:
        verticalMovement = -1;
        break;
      case JoystickDirection.down:
        verticalMovement = 1;
        break;
      case JoystickDirection.downRight:
        horizontalMovement = 1;
        verticalMovement = 1;
        break;
      case JoystickDirection.downLeft:
        horizontalMovement = -1;
        verticalMovement = 1;
        break;
      case JoystickDirection.upRight:
        horizontalMovement = 1;
        verticalMovement = -1;
        break;
      case JoystickDirection.upLeft:
        horizontalMovement = -1;
        verticalMovement = -1;
        break;
      default:
        horizontalMovement = 0;
        verticalMovement = 0;
        break;
    }

    player.horizontalMovement = horizontalMovement;
    player.verticalMovement = verticalMovement;
  }

  // Loading Next and Previous Levels
  Future<void> loadNextLevel() async {
    // Add the fade effect component to the game
    final fadeEffect = FadeEffect(size);
    add(fadeEffect);

    // Start the fade-in animation
    fadeEffect.startFade();

    // Delay loading the next level until the fade-in completes
    Future.delayed(Duration(seconds: 1), () {
      currentLevelIndex = (currentLevelIndex + 1) % levelNames.length;
      _loadLevel(currentLevelIndex);

      // Remove the fade effect after the transition
      fadeEffect.removeFromParent();
    });
  }

  Future<void> loadPreviousLevel() async {
    // Only load the previous level if we aren't at the start
    if (currentLevelIndex > 0) {
      // Add the fade effect component to the game
      final fadeEffect = FadeEffect(size);
      add(fadeEffect);

      // Start the fade-in animation
      fadeEffect.startFade();

      // Delay loading the previous level until the fade-in completes
      Future.delayed(Duration(seconds: 1), () {
        currentLevelIndex--;
        _loadLevel(currentLevelIndex);

        // Remove the fade effect after the transition
        fadeEffect.removeFromParent();
      });
    }
  }
}
