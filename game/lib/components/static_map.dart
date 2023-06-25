typedef TileMap = List<List<int>>;

class StaticMap {
  StaticMap._();

  static List<TileMap> layers() {
    return [
      layer0,
      layer1,
      layer2,
      layer3,
      layer4,
    ];
  }

  static final List<int> _nothing = List.filled(5, -1);

  static TileMap layer0 = List.generate(5, (_) => List.filled(5, 0));

  static TileMap layer1 = [
    [3, 12, 8, 3, 3],
    [3, 12, 3, 3, 3],
    [3, 12, 2, 3, 3],
    [3, 12, 3, 3, 3],
    [3, 12, 3, 3, 3],
  ];

  static TileMap layer2 = [
    _nothing,
    _nothing,
    [-1, -1, -1, 8, 9],
    [9, -1, 8, 0, 0],
    [8, -1, 8, 8, 8],
  ];

  static TileMap layer3 = [
    _nothing,
    _nothing,
    _nothing,
    [-1, -1, -1, 0, 0],
    [8, -1, 8, 8, 8],
  ];

  static TileMap layer4 = [
    _nothing,
    _nothing,
    _nothing,
    [-1, -1, -1, 3, 3],
    [20, 21, 20, 3, 3],
  ];
}
