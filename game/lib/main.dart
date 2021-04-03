import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show runApp;

import 'components/character.dart';
import 'components/path.dart';
import 'components/selector.dart';

void main() {
  final game = MyGame();
  runApp(GameWidget(game: game));
}

class MyGame extends BaseGame
    with MouseMovementDetector, ScrollDetector, TapDetector {
  late final IsometricTileMapComponent map;
  late final Selector selector;
  late final Character player;
  late final Path path;

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

    add(
      player = Character(
        Block(5, 7),
        await loadSprite('simple-character.png'),
      ),
    );

    add(selector = Selector(tileset.getSprite(3, 3)));
    selector.block = player.block;

    add(path = Path());

    final center = map.getBlockPosition(player.block);
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

  @override
  void onTapUp(TapUpDetails details) {
    final pos = camera.screenToWorld(details.localPosition.toVector2());
    final block = map.getBlock(pos);
    if (map.containsBlock(block)) {
      path.start = player.block;
      path.end = block;
    }
  }
}
