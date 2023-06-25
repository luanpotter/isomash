import 'package:flame/components.dart';

import 'package:isomash/objects/isometric_object.dart';

class Selector extends IsometricObject {
  Selector(Block block, Sprite sprite)
      : super(sprite: sprite, size: sprite.srcSize, block: block);

  @override
  int get priority => 1;
}
