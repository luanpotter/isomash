import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:isomash/components/static_map.dart';
import 'package:isomash/components/tile_map_rotator.dart';
import 'package:isomash/objects/isometric_object.dart';

class StackedIsometrictTileMapComponent extends Component {
  SpriteSheet tileset;

  StackedIsometrictTileMapComponent({
    required this.tileset,
  });

  static Future<StackedIsometrictTileMapComponent> generate() async {
    const tileHeight = 16.0;
    final tileset = SpriteSheet(
      image: await Flame.images.load('tile.png'),
      srcSize: Vector2.all(32.0),
    );

    final layers = StaticMap.layers();

    final map = StackedIsometrictTileMapComponent(tileset: tileset);
    for (final (idx, layer) in layers.indexed) {
      await map.add(
        IsometricTileMapComponent(
          tileset,
          layer,
          tileHeight: tileHeight,
          position: Vector2(0, -tileHeight * idx),
        ),
      );
    }
    return map;
  }

  List<IsometricTileMapComponent> get _maps =>
      children.whereType<IsometricTileMapComponent>().toList();

  IsometricTileMapComponent _findMapForBlock(Block block) {
    return _maps.reversed.firstWhere(
      (map) => map.blockValue(block) != -1,
      orElse: () => _maps.first,
    );
  }

  Vector2 getBlockCenterPosition(Block block) {
    final map = _findMapForBlock(block);
    return map.position + map.getBlockCenterPosition(block);
  }

  Block getBlock(Vector2 pos) {
    for (final map in _maps.reversed) {
      final block = map.getBlock(pos);
      if (map.containsBlock(block) && map.blockValue(block) != -1) {
        return block;
      }
    }
    return _maps.first.getBlock(pos);
  }

  bool containsBlock(Block block) {
    return _maps.first.containsBlock(block);
  }

  void setBlockValue(Block pos, int block) {
    _findMapForBlock(pos).setBlockValue(pos, block);
  }

  Vector2 getBlockRenderPosition(Block block) {
    final map = _findMapForBlock(block);
    return map.position + map.getBlockRenderPosition(block);
  }

  Vector2 getBlockRenderPositionInts(int i, int j) {
    return getBlockRenderPosition(Block(i, j));
  }

  void rotate(int n) {
    _maps.forEach((map) => map.rotate(n));
  }

  void rotateObject(IsometricObject obj, int n) {
    obj.block = _maps.first.rotateBlock(obj.block, n);
  }
}
