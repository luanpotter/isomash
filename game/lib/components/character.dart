import 'package:flame/components.dart';

import '../main.dart';

class Character extends SpriteComponent with HasGameRef<MyGame> {
  static final Vector2 offset = Vector2(3, 35);

  Block block;

  Character(this.block, Sprite sprite)
      : super(sprite: sprite, size: sprite.srcSize);

  @override
  void update(double dt) {
    super.update(dt);

    position = gameRef.map.getBlockPosition(block) - offset;
  }

  @override
  int get priority => 2;
}
