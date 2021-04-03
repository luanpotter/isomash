import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'components/character.dart';
import 'components/selector.dart';

void main() {
  final game = MyGame();
  runApp(GameWidget(game: game));
}

class MyGame extends BaseGame with MouseMovementDetector, ScrollDetector {
  late final IsometricTileMapComponent map;
  late final Selector selector;
  late final Character player;

  final Block playerPosition = Block(0, 0);

  @override
  Future<void> onLoad() async {
    final tileset = SpriteSheet(
      image: await images.load('tileset.png'),
      srcSize: Vector2.all(32.0),
    );

    final matrix = [
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
      [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
    ];
    add(map = IsometricTileMapComponent(tileset, matrix));

    add(player = Character(await loadSprite('simple-character.png')));
    player.block = Block(5, 7);

    add(selector = Selector(tileset.getSprite(3, 3)));
    selector.block = player.block;

    final center = map.getBlockPosition(playerPosition);
    camera.setRelativeOffset(Anchor.center.toVector2());
    camera.moveTo(center);
    camera.snap();
  }

  @override
  void onMouseMove(PointerHoverEvent details) {
    final pos = camera.screenToWorld(details.position.toVector2());
    final block = map.getBlock(pos);
    if (map.containsBlock(block)) {
      selector.block = block;
    }
  }

  @override
  void onScroll(PointerScrollEvent event) {
    print(event.scrollDelta);
  }
}
