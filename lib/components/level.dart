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
import 'package:moonshiner_game/moonshiner.dart';

import 'enemy.dart';
import 'itemTip.dart';

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

    const tileSize = 64;

    final numTilesY = (game.size.y / tileSize);
    final numTilesX = (game.size.x / tileSize);

    if (backgroundLayer != null) {
      final backgroundColor =
          backgroundLayer.properties.getValue("BackgroundColor");

      for (double y = 0; y < numTilesY; y++) {
        for (double x = 0; x < numTilesX; x++) {
          final backgroundTile = BackgroundTile(
            color: backgroundColor ?? 'Gray',
            position: Vector2(x * tileSize - tileSize, y * tileSize - tileSize),
          );
          add(backgroundTile);
        }
      }
    }
  }

  void _spawningObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
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
