import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moonshiner_game/components/background_tile.dart';
import 'package:moonshiner_game/components/collision_block.dart';
import 'package:moonshiner_game/components/player.dart';
import 'package:moonshiner_game/components/wife.dart';
import 'package:moonshiner_game/moonshiner.dart';

import 'door.dart';
import 'enemy.dart';
import 'itemTip.dart';
import 'backdoor.dart';

class Level extends World with HasGameRef<Moonshiner> {
  final String levelName;
  final Player player;
  final Enemy enemy;
  Level({required this.levelName, required this.player, required this.enemy});
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    _scrollingBackground();

    _spawningObjects();

    _addCollisions();

    return super.onLoad();
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer("Background");

    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue("BackgroundColor");
      final backgroundTile = BackgroundTile(
        color: backgroundColor ?? 'Gray',
        position: Vector2(0, 0),
      );
      add(backgroundTile);
    }
  }

  List<List<String>> enemyDialogues = [
    ["Dialogue 1 for Enemy 1", "Dialogue 2 for Enemy 1"],
    ["Dialogue 1 for Enemy 2", "Dialogue 2 for Enemy 2"],
    // Add more lists of dialogues for each enemy spawn point
  ];

  void _spawningObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.scale.x = 1;
            add(player);
            break;
          case 'Wife': // Add case for spawning the wife
            final wife = Wife(player: player);
            wife.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(wife);
            break;
          case 'Objects':
            final itemTip = ItemTip(
                itemTip: spawnPoint.name,
                position: Vector2(spawnPoint.x, spawnPoint.y),
                size: Vector2(spawnPoint.width, spawnPoint.height));
            add(itemTip);
            break;
          case 'Enemy':
            enemy.enemyCharacter = 'Ninja Frog';
            enemy.position = Vector2(spawnPoint.x, spawnPoint.y);

            add(enemy);
            break;
          case 'Door':
            final door = Door(
                position: Vector2(spawnPoint.x, spawnPoint.y),
                size: Vector2(spawnPoint.width, spawnPoint.height));
            add(door);
            break;
          case 'BackDoor':
            final backdoor = Backdoor(
                position: Vector2(spawnPoint.x, spawnPoint.y),
                size: Vector2(spawnPoint.width, spawnPoint.height));
            add(backdoor);
            break;
          default:
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Walls':
            final wall = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isWall: true,
            );
            collisionBlocks.add(wall);
            add(wall);
            break;
          case 'Ground':
            final ground = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isGround: true,
            );
            collisionBlocks.add(ground);
            add(ground);
            break;
          case 'Player':
            final player = CollisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height),
                isPlayer: true);
            collisionBlocks.add(player);
            add(player);
            break;
          case 'Wife': // Add collision block for the wife
            final wifeBlock = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlayer:
                  true, // Assuming the wife should interact with player collision blocks
            );
            collisionBlocks.add(wifeBlock);
            add(wifeBlock);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
    enemy.collisionBlocks = collisionBlocks;
  }
}
