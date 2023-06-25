typedef TileMap = List<List<int>>;

class StaticMap {
  StaticMap._();

  static List<TileMap> layers() {
    return [
      _base,
      _column,
      _column,
      _column,
      _column,
      _top,
    ];
  }

  static final List<int> _nothing = List.filled(5, -1);

  static final TileMap _base = [
    _nothing,
    _nothing,
    [0, 0, 0, 0, 0],
    _nothing,
    _nothing,
    _nothing,
  ];

  static final TileMap _column = [
    _nothing,
    _nothing,
    [-1, -1, -1, -1, 0],
    _nothing,
    _nothing,
    _nothing,
  ];

  static final TileMap _top = [
    _nothing,
    _nothing,
    [-1, -1, -1, 1, 0],
    [-1, -1, -1, 1, 0],
    [-1, -1, -1, 1, 0],
    [-1, -1, -1, 1, 0],
  ];
}
