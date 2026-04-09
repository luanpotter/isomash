import 'dart:ui';

import 'package:flame/components.dart';
import 'package:isomash/main.dart';

final _text = TextPaint();
final _position = Vector2.zero();

class ModeDisplay extends Component with HasGameReference<MyGame> {
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _text.render(canvas, 'Mode: ${game.mode}', _position);
  }
}
