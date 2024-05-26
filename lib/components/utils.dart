bool checkCollision(player, block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX;
  final fixedY = block.isWall ? playerY + playerHeight / 2 : playerY;

  return (fixedY < blockY + blockHeight &&
      fixedY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}

bool checkEnemyCollision(enemy, block) {
  final hitbox = enemy.hitbox;
  final enemyX = enemy.position.x + hitbox.offsetX;
  final enemyY = enemy.position.y + hitbox.offsetY;
  final enemyWidth = hitbox.width;
  final enemyHeight = hitbox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX =
      enemy.scale.x < 0 ? enemyX - (hitbox.offsetX * 2) - enemyWidth : enemyX;
  final fixedY = block.isWall ? enemyY + enemyHeight / 2 : enemyY;

  return (fixedY < blockY + blockHeight &&
      fixedY + enemyHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + enemyWidth > blockX);
}
