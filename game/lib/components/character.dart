import 'package:flame/components.dart';

import '../main.dart';

class Character extends SpriteComponent with HasGameRef<MyGame> {
  Block? block;

  Character(Sprite sprite) : super(sprite: sprite, size: sprite.srcSize);

  @override
  void update(double dt) {
    super.update(dt);

    final block = this.block;
    if (block != null) {
      position = gameRef!.map.getBlockPosition(block);
    }
  }

  @override
  int get priority => 2;
}
