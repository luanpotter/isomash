import 'package:flame/components.dart';

import 'package:isomash/objects/isometric_object.dart';

class Character extends IsometricObject {
  static final Vector2 _offset = Vector2(-6, 9);

  @override
  Vector2 get offset => _offset;

  Character(Block block, Sprite sprite)
      : super(sprite: sprite, size: sprite.srcSize / 2, block: block);

  @override
  int get priority => 2;
}
