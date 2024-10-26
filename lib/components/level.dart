import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:moonshiner_game/components/background_tile.dart';
import 'package:moonshiner_game/components/collision_block.dart';
import 'package:moonshiner_game/components/player.dart';
import 'package:moonshiner_game/moonshiner.dart';
import 'npc.dart';
import 'door.dart';
import 'itemTip.dart';
import 'backdoor.dart';
import 'wife.dart';

class Level extends World with HasGameRef<Moonshiner> {
  final String levelName;
  final Player player;
  List<NPC> npcs = [];
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  Level({
    required this.levelName,
    required this.player,
  });

  @override
  FutureOr<void> onLoad() async {
    await _loadLevel();
    return super.onLoad();
  }

  Future<void> _loadLevel() async {
    // Clear any previous level objects
    _clearPreviousLevel();

    // Load the new tiled map component
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);

    _setupBackground();
    _spawnObjects();
    _addCollisionBlocks();
  }

  void _clearPreviousLevel() {
    // Remove collision blocks
    collisionBlocks.forEach((block) => block.removeFromParent());
    collisionBlocks.clear();

    // Remove all NPCs and stop their timers
    npcs.forEach((npc) {
      npc.removeFromParent();
    });
    npcs.clear();

    // Remove the player and other unique components
    player.removeFromParent();
    children.whereType<Wife>().forEach((wife) => wife.removeFromParent());
  }

  void unload() {
    _clearPreviousLevel(); // Ensure all components are removed
    removeFromParent();
  }

  void _setupBackground() {
    final backgroundLayer = level.tileMap.getLayer("Background");

    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue("BackgroundColor") ?? 'Gray';
      final backgroundTile =
          BackgroundTile(color: backgroundColor, position: Vector2(0, 0));
      add(backgroundTile);
    }
  }

  void _spawnObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        final position = Vector2(spawnPoint.x, spawnPoint.y);
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = position;
            add(player);
            break;
          case 'Wife':
            final wife = Wife(player: player);
            wife.position = position;
            wife.dialogues = [
              "I’m worried... stay close.",
              "My head feels strange... is it safe here?"
            ];
            add(wife);
            break;
          case 'NPC':
            NPC npc;
            final npcType = spawnPoint.name;

            if (npcType == 'Priest') {
              npc = NPC(
                npcCharacter: 'Priest',
                dialogues: [
                  "The Lord sees all.",
                  "Bless you, my child.",
                  "Evil lurks in strange places."
                ],
                position: position,
              );
            } else if (npcType == 'Baker') {
              npc = NPC(
                npcCharacter: 'Baker',
                dialogues: [
                  "Fresh bread today!",
                  "A hard day’s work, but worth it.",
                  "Care for a slice?"
                ],
                position: position,
              );
            } else if (npcType == 'Old Lady') {
              npc = NPC(
                npcCharacter: 'Old Lady',
                dialogues: [
                  "In my day, things were different.",
                  "I’ve lived here my whole life.",
                  "Be careful, dear."
                ],
                position: position,
              );
            } else if (npcType == 'Journal Guy') {
              npc = NPC(
                npcCharacter: 'Journal Guy',
                dialogues: [
                  "News of the day! Get your news here!",
                  "Rumor has it, strange things are happening.",
                  "Can’t keep secrets in this town."
                ],
                position: position,
              );
            } else {
              npc = NPC(
                npcCharacter: 'Wanderer',
                dialogues: ["I'm just here, wandering around."],
                position: position,
              );
            }

            npc.collisionBlocks = collisionBlocks;
            npcs.add(npc);
            add(npc);
            break;
          case 'Door':
            final door = Door(
                position: position,
                size: Vector2(spawnPoint.width, spawnPoint.height));
            add(door);
            break;
          case 'BackDoor':
            final backdoor = Backdoor(
                position: position,
                size: Vector2(spawnPoint.width, spawnPoint.height));
            add(backdoor);
            break;
          case 'Objects':
            final itemTip = ItemTip(
                itemTip: spawnPoint.name,
                position: Vector2(spawnPoint.x, spawnPoint.y),
                size: Vector2(spawnPoint.width, spawnPoint.height));
            add(itemTip);
            break;
          default:
            break;
        }
      }
    }
  }

  void _addCollisionBlocks() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        final position = Vector2(collision.x, collision.y);
        final size = Vector2(collision.width, collision.height);
        CollisionBlock block;

        switch (collision.class_) {
          case 'Walls':
            block =
                CollisionBlock(position: position, size: size, isWall: true);
            break;
          case 'Ground':
            block =
                CollisionBlock(position: position, size: size, isGround: true);
            break;
          case 'Player':
          case 'Wife':
            block =
                CollisionBlock(position: position, size: size, isPlayer: true);
            break;
          default:
            block = CollisionBlock(position: position, size: size);
        }

        collisionBlocks.add(block);
        add(block);
      }
    }

    player.collisionBlocks = collisionBlocks;
    npcs.forEach((npc) => npc.collisionBlocks = collisionBlocks);
  }
}
