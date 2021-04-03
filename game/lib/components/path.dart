import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';

import '../main.dart';

class Path extends Component with HasGameRef<MyGame> {
  late SpriteSheet paths;

  Block? start, end;

  @override
  Future<void> onLoad() async {
    paths = SpriteSheet(
      image: await gameRef.images.load('paths.png'),
      srcSize: Vector2.all(32.0),
    );
  }

  @override
  void render(Canvas c) {
    final start = this.start;
    final end = this.end;
    if (start == null || end == null) {
      return;
    }

    final x1 = min(start.x, end.x);
    final x2 = max(start.x, end.x);
    for (var i = x1; i <= x2; i++) {
      final pos = gameRef.map.getBlockPositionInts(i, start.y);
      if (i > x1) {
        paths.getSpriteById(1).render(c, position: pos);
      }
      if (i < x2) {
        paths.getSpriteById(3).render(c, position: pos);
      }
    }

    final y1 = min(start.y, end.y);
    final y2 = max(start.y, end.y);
    for (var i = y1; i <= y2; i++) {
      final pos = gameRef.map.getBlockPositionInts(end.x, i);
      if (i > y1) {
        paths.getSpriteById(0).render(c, position: pos);
      }
      if (i < y2) {
        paths.getSpriteById(2).render(c, position: pos);
      }
    }
  }
}
