import 'package:dartlin/dartlin.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Path;
import 'package:isomash/components/path.dart';
import 'package:isomash/components/stacked_isometric_tile_map_component.dart';
import 'package:isomash/components/toolbar.dart';
import 'package:isomash/objects/isometric_object.dart';
import 'package:isomash/objects/selector.dart';

void main() {
  final game = MyGame();
  runApp(GameWidget(game: game));
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
  late final Path path;
  late final Toolbar toolbar;

  Vector2? dragStart;

  @override
  Future<void> onLoad() async {
    add(map = await StackedIsometrictTileMapComponent.generate());

    add(toolbar = Toolbar(map.tileset));
    add(selector = Selector(const Block(0, 0), map.tileset.getSprite(3, 3)));

    add(path = Path());

    final center = map.getBlockCenterPosition(const Block(0, 0));
    camera.setRelativeOffset(Anchor.center);
    camera.snapTo(center);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.save();
    final center = map.getBlockCenterPosition(const Block(0, 0));
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
    final idx =
        _zooms.indexOf(camera.zoom) - event.scrollDelta.game.y.sign.toInt();
    if (idx >= 0 && idx < _zooms.length) {
      camera.zoom = _zooms[idx];
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

  void _rotate(int n) {
    map.rotate(n);
    children
        .whereType<IsometricObject>()
        .forEach((c) => map.rotateObject(c, n));
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keys) {
    final isKeyDown = event is RawKeyDownEvent;
    if (!isKeyDown) {
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.keyQ) {
      _rotate(-1);
    } else if (event.logicalKey == LogicalKeyboardKey.keyE) {
      _rotate(1);
    } else if (event.logicalKey == LogicalKeyboardKey.keyZ) {
      final idx = _zooms.indexOf(camera.zoom) + 1;
      camera.zoom = _zooms[idx % _zooms.length];
    } else {
      final keyLabel = event.data.keyLabel;
      int.tryParse(keyLabel)?.let(toolbar.select);
    }
    return KeyEventResult.handled;
  }
}
