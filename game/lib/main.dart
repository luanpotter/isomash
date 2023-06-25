import 'package:dartlin/dartlin.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'components/character.dart';
import 'components/path.dart';
import 'components/selector.dart';
import 'components/toolbar.dart';

void main() {
  final game = MyGame();
  runApp(GameWidget(game: game));
}

class MyGame extends FlameGame
    with
        MouseMovementDetector,
        ScrollDetector,
        TapDetector,
        PanDetector,
        KeyboardEvents,
        SecondaryTapDetector {
  late final IsometricTileMapComponent map;
  late final Selector selector;
  late final Character player;
  late final Path path;
  late final Toolbar toolbar;

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
    add(
      map = IsometricTileMapComponent(
        tileset,
        matrix,
        tileHeight: 8,
      ),
    );

    add(
      player = Character(
        const Block(5, 7),
        await loadSprite('simple-character.png'),
      ),
    );

    add(toolbar = Toolbar(tileset));
    add(selector = Selector(tileset.getSprite(3, 3)));
    selector.block = player.block;

    add(path = Path());

    final center = map.getBlockCenterPosition(player.block);
    camera.setRelativeOffset(Anchor.center);
    camera.snapTo(center);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.save();
    // camera.apply(canvas);
    final center = map.getBlockCenterPosition(player.block);
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
    final idx =
        zooms.indexOf(camera.zoom) - event.scrollDelta.game.y.sign.toInt();
    if (idx >= 0 && idx < zooms.length) {
      camera.zoom = zooms[idx];
    }
  }

  @override
  void onTapUp(TapUpInfo details) {
    final pos = details.eventPosition.game;
    final block = map.getBlock(pos);
    if (map.containsBlock(block)) {
      map.setBlockValue(block, -1);
    }
  }

  @override
  void onSecondaryTapDown(TapDownInfo details) {
    final pos = details.eventPosition.game;
    final block = map.getBlock(pos);
    if (map.containsBlock(block)) {
      map.setBlockValue(block, toolbar.selectedCell);
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    camera.translateBy(info.delta.global * -1 / camera.zoom);
    camera.snap();
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keys) {
    final isKeyDown = event is RawKeyDownEvent;
    if (!isKeyDown) {
      return KeyEventResult.handled;
    }

    final keyLabel = event.data.keyLabel;
    int.tryParse(keyLabel)?.let(toolbar.select);
    return KeyEventResult.handled;
  }
}
