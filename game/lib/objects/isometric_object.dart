import 'package:flame/components.dart';

import 'package:isomash/main.dart';

abstract class IsometricObject extends SpriteComponent with HasGameRef<MyGame> {
  static final Vector2 _zero = Vector2.zero();

  Block block;
  Vector2 get offset => _zero;

  IsometricObject({
    required super.sprite,
    required super.size,
    required this.block,
  });

  @override
  void update(double dt) {
    super.update(dt);

    position = gameRef.map.getBlockRenderPosition(block) - offset;
  }
}
