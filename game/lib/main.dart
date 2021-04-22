import 'dart:html' show document;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart' show runApp;

import 'components/character.dart';
import 'components/path.dart';
import 'components/selector.dart';

void main() {
  document.onContextMenu.listen((event) => event.preventDefault());

  final game = MyGame();
  runApp(GameWidget(game: game));
}

class MyGame extends BaseGame
    with MouseMovementDetector, ScrollDetector, TapDetector, PanDetector {
  late final IsometricTileMapComponent map;
  late final Selector selector;
  late final Character player;
  late final Path path;

  Vector2? dragStart;

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
    camera.snapTo(center);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.save();
    camera.apply(canvas);
    final center = map.getBlockPosition(player.block);
    canvas.renderPoint(center);
    canvas.restore();
  }

  @override
  void onMouseMove(PointerHoverInfo details) {
    final pos = details.eventPosition.game;
    final block = map.getBlock(pos);
    if (map.containsBlock(block)) {
      selector.block = block;
    }
  }

  @override
  void onScroll(PointerScrollInfo event) {
    final zooms = [0.25, 0.5, 1.0, 2.0, 4.0, 10.0];
    final idx = zooms.indexOf(camera.zoom) - event.scrollDelta.y.sign.toInt();
    camera.zoom = zooms[idx % zooms.length];
  }

  @override
  void onTapUp(TapUpInfo details) {
    final pos = details.eventPosition.game;
    final block = map.getBlock(pos);
    if (map.containsBlock(block)) {
      path.start = player.block;
      path.end = block;
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    camera.translateBy(info.delta / camera.zoom * -1);
    camera.snap();
  }
}
