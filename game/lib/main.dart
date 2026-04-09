import 'package:dartlin/dartlin.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Path;
import 'package:isomash/components/mode_display.dart';
import 'package:isomash/components/path.dart';
import 'package:isomash/components/stacked_isometric_tile_map_component.dart';
import 'package:isomash/components/toolbar.dart';
import 'package:isomash/objects/character.dart';
import 'package:isomash/objects/isometric_object.dart';
import 'package:isomash/objects/selector.dart';

void main() {
  final game = MyGame();
  runApp(GameWidget(game: game));
}

enum Mode { build, path }

extension on Mode {
  Mode next() => Mode.values[(index + 1) % Mode.values.length];
}

const _zooms = [0.25, 0.5, 1.0, 2.0, 4.0, 10.0];

class MyGame extends FlameGame
    with
        MouseMovementDetector,
        ScrollDetector,
        TapDetector,
        PanDetector,
        KeyboardEvents,
        SecondaryTapDetector {
  late final StackedIsometrictTileMapComponent map;
  late final Selector selector;
  late final Character player;
  late final Path path;
  late final Toolbar toolbar;

  Mode mode = Mode.build;

  Vector2? dragStart;

  @override
  Future<void> onLoad() async {
    world.add(map = await StackedIsometrictTileMapComponent.generate());

    world.add(
      player = Character(
        const Block(0, 0),
        await loadSprite('simple-character.png'),
      ),
    );
    world.add(selector = Selector(player.block, map.tileset.getSprite(3, 3)));
    world.add(path = Path());

    camera.viewport.add(toolbar = Toolbar(map.tileset)..priority = 10);
    camera.viewport.add(ModeDisplay());

    final center = map.getBlockCenterPosition(player.block);
    camera.moveTo(center);
    camera.viewfinder.zoom = 2.0;
  }

  @override
  void onMouseMove(PointerHoverInfo details) {
    final widgetPos = details.eventPosition.widget;
    final pos = camera.globalToLocal(widgetPos);
    final block = map.getBlock(pos);
    if (map.containsBlock(block)) {
      selector.block = block;
    }
  }

  @override
  void onScroll(PointerScrollInfo event) {
    final currentZoomIdx = _zooms.indexOf(camera.viewfinder.zoom);
    final idx = (currentZoomIdx - event.scrollDelta.global.y.sign.toInt())
        .clamp(0, _zooms.length - 1);
    camera.viewfinder.zoom = _zooms[idx];
  }

  @override
  void onTapUp(TapUpInfo details) {
    final widgetPos = details.eventPosition.widget;
    final pos = camera.globalToLocal(widgetPos);
    final block = map.getBlock(pos);
    switch (mode) {
      case Mode.build:
        if (map.containsBlock(block)) {
          map.setBlockValue(block, -1);
        }
      case Mode.path:
        path.start = block;
    }
  }

  @override
  void onSecondaryTapDown(TapDownInfo details) {
    final widgetPos = details.eventPosition.widget;
    final pos = camera.globalToLocal(widgetPos);
    final block = map.getBlock(pos);
    switch (mode) {
      case Mode.build:
        if (map.containsBlock(block)) {
          map.setBlockValue(block, toolbar.selectedCell);
        }
      case Mode.path:
        path.end = block;
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    camera.moveBy(info.delta.global * -1 / camera.viewfinder.zoom);
  }

  void _rotate(int n) {
    map.rotate(n);
    children
        .whereType<IsometricObject>()
        .forEach((c) => map.rotateObject(c, n));
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keys) {
    final isKeyDown = event is KeyDownEvent;
    if (!isKeyDown) {
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.keyQ) {
      _rotate(-1);
    } else if (event.logicalKey == LogicalKeyboardKey.keyE) {
      _rotate(1);
    } else if (event.logicalKey == LogicalKeyboardKey.keyZ) {
      final idx = _zooms.indexOf(camera.viewfinder.zoom) + 1;
      camera.viewfinder.zoom = _zooms[idx % _zooms.length];
    } else {
      final keyLabel = event.character;
      if (keyLabel?.toUpperCase() == 'M') {
        mode = mode.next();
      } else {
        keyLabel?.let(int.tryParse)?.let(toolbar.select);
      }
    }
    return KeyEventResult.handled;
  }
}
