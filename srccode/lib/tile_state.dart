import 'dart:math';

enum TileState {
  EMPTY,
  BLUELIGHTSABER,
  REDLIGHTSABER,
  NONE,
}

List<List<TileState>> chunk(List<TileState> list, int size) {
  return List.generate(
      (list.length / size).ceil(), //to take care of decimals,
      (index) =>
          list.sublist(index * size, min(index * size + size, list.length)));
}
