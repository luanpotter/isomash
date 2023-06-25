import 'dart:ui';

import 'package:dartlin/dartlin.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../main.dart';

const _toolbarBoxSize = 64.0;
const _toolbarLength = 9;

final _normalBorder = Paint()
  ..color = const Color(0xFFCCCCCC)
  ..style = PaintingStyle.stroke;
final _selectedBorder = Paint()
  ..color = const Color(0xFFFFAAAA)
  ..style = PaintingStyle.stroke;

class Toolbar extends PositionComponent with HasGameRef<MyGame> {
  SpriteSheet tileset;
  int selectedCell = 0;

  Toolbar(this.tileset) {
    size = Vector2(_toolbarLength * _toolbarBoxSize, _toolbarBoxSize);
  }

  @override
  PositionType positionType = PositionType.viewport;

  void select(int keyPressed) {
    final selectedCell = keyPressed - 1;
    if (range(0, to: _toolbarLength).contains(selectedCell)) {
      this.selectedCell = selectedCell;
    }
  }

  @override
  void render(Canvas c) {
    super.render(c);

    repeat(_toolbarLength, (idx) {
      final p = Vector2(_toolbarBoxSize * idx, 0);
      final size = Vector2.all(_toolbarBoxSize);
      final rect = (p & size).deflate(4.0);
      c.drawRect(rect, selectedCell == idx ? _selectedBorder : _normalBorder);
      tileset.getSpriteById(idx).renderRect(c, rect);
    });
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    position = Vector2(gameSize.x / 2, gameSize.y - 8);
    anchor = Anchor.bottomCenter;
  }
}
