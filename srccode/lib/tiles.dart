import 'package:flutter/material.dart';
import 'tile_state.dart';

class BoardTiles extends StatelessWidget {
  final double dimension;
  final VoidCallback onPressed;
  final TileState tileState;
  BoardTiles(
      {Key? key,
      required this.dimension,
      required this.onPressed,
      required this.tileState})
      : super(key: key);

  @override
  Widget build(BuildContext screen) {
    return (Container(
            width: dimension,
            height: dimension,
            child: ElevatedButton(
              // style: flatButtonStyle,
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(0, 222, 222, 222),
              ),
              onPressed: onPressed,
              child: _imageForTile(),
            ))
        // child: Image.asset("images/blue transparent.png")
        );
  }

  Widget _imageForTile() {
    Widget widget = Container();

    switch (tileState) {
      case TileState.EMPTY:
        {
          widget = Container();
        }
        break;

      case TileState.BLUELIGHTSABER:
        {
          widget = Image.asset('images/blue transparent.png');
        }
        break;

      case TileState.REDLIGHTSABER:
        {
          widget = Image.asset('images/red transparent.png');
        }
        break;
      case TileState.NONE:
        {
          widget = Container();
        }
    }

    return widget;
  }
}
