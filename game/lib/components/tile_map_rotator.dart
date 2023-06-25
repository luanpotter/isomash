import 'package:flame/components.dart';

extension TileMapRotator on IsometricTileMapComponent {
  int get rowCount => matrix.length;
  int get colCount => matrix[0].length;

  List<List<int>> _makeMatrix(int rowCount, int colCount) {
    return List.generate(rowCount, (_) => List.filled(colCount, 0));
  }

  List<List<int>> _rotateCW(List<List<int>> matrix) {
    final result = _makeMatrix(colCount, rowCount);

    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < colCount; j++) {
        result[j][rowCount - 1 - i] = matrix[i][j];
      }
    }

    return result;
  }

  List<List<int>> _rotateCCW(List<List<int>> matrix) {
    final result = _makeMatrix(colCount, rowCount);

    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < colCount; j++) {
        result[colCount - 1 - j][i] = matrix[i][j];
      }
    }

    return result;
  }

  void rotate(int n) {
    final fn = n.sign == 1 ? _rotateCW : _rotateCCW;
    for (var i = 0; i < n.abs(); i++) {
      matrix = fn(matrix);
    }
  }

  Block rotateBlock(Block block, int n) {
    return _rotateBlockCCW(block, -n, rowCount, colCount);
  }

  Block _rotateBlockCCW(Block block, int n, int width, int height) {
    final normalizedN = _normalize(n);

    if (normalizedN == 0) {
      return block;
    }

    return _rotateBlockCCW(
      Block(block.y, height - 1 - block.x),
      normalizedN - 1,
      height,
      width,
    );
  }

  int _normalize(int n) {
    var mod = n % 4;
    if (mod < 0) {
      mod += 4;
    }
    return mod;
  }
}
