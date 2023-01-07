import 'package:flutter/material.dart';
import 'package:srccode/tiles.dart';
import 'package:srccode/tile_state.dart';

void main() {
  runApp(MyApp());
}

//ignore: use_key_in_widget_constructors
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ignore: prefer_final_fields
  // var boardState = List.filled(9, TileState.EMPTY);
  final navigatorKey = GlobalKey<NavigatorState>();
  var _boardState = List.filled(9, TileState.EMPTY);

  var _currentTurn = TileState.BLUELIGHTSABER;

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors

    return MaterialApp(
        //ignore: prefer_const_constructors
        home: Scaffold(
            body: Center(
      child: Stack(children: [Image.asset("images/board.png"), tiles()]),
    )));
  }

  Widget tiles() {
    return Builder(builder: (screen) {
      final playingArea = MediaQuery.of(screen).size.width;
      final tileArea = playingArea / 3;

      // ignore: sized_box_for_whitespace
      // ignore: sized_box_for_whitespace
      return Container(
          width: playingArea,
          height: playingArea,
          child: Column(
              children: chunk(_boardState, 3).asMap().entries.map((entry) {
            final chunkIndex = entry.key;
            final tileStateChunk = entry.value;

            return Row(
              children: tileStateChunk.asMap().entries.map((innerEntry) {
                final innerIndex = innerEntry.key;
                final tileState = innerEntry.value;
                final tileIndex = (chunkIndex * 3) + innerIndex;

                return BoardTiles(
                  tileState: tileState,
                  dimension: tileArea,
                  onPressed: () => _updateTileStateForIndex(tileIndex),
                );
              }).toList(),
            );
          }).toList()));
    });
  }

  void _updateTileStateForIndex(int selectedIndex) {
    if (_boardState[selectedIndex] == TileState.EMPTY) {
      setState(() {
        _boardState[selectedIndex] = _currentTurn;
        _currentTurn = _currentTurn == TileState.BLUELIGHTSABER
            ? TileState.REDLIGHTSABER
            : TileState.BLUELIGHTSABER;
      });
    }
    final winner = _findWinner();
    if (winner != TileState.NONE) {
      print('Winner is: $winner');
      _showWinnerDialog(winner);
    }
  }

  TileState _findWinner() {
    // ignore: prefer_function_declarations_over_variables
    TileState Function(int, int, int) winnerForMatch = (a, b, c) {
      if (_boardState[a] != TileState.EMPTY) {
        if ((_boardState[a] == _boardState[b]) &&
            (_boardState[b] == _boardState[c])) {
          return _boardState[a];
        }
      }
      return TileState.NONE;
    };

    final checks = [
      winnerForMatch(0, 1, 2),
      winnerForMatch(3, 4, 5),
      winnerForMatch(6, 7, 8),
      winnerForMatch(0, 3, 6),
      winnerForMatch(1, 4, 7),
      winnerForMatch(2, 5, 8),
      winnerForMatch(0, 4, 8),
      winnerForMatch(2, 4, 6),
    ];

    TileState winner;
    for (int i = 0; i < checks.length; i++) {
      if (checks[i] != TileState.NONE) {
        winner = checks[i];
        return winner;
      }
    }

    return TileState.NONE;
  }

  void _showWinnerDialog(TileState tileState) {
    // final context = navigatorKey.currentState.overlay.context;
    // showDialog(
    //     context: context,
    //     builder: (_) {
    //       return AlertDialog(
    //         title: Text('Winner'),
    //         content: Image.asset(tileState == TileState.BLUELIGHTSABER
    //             ? 'images/Blue transparent.png'
    //             : 'images/Red transparent.png'),
    //         actions: [
    //           ElevatedButton(
    //               onPressed: () {
    //                 _resetGame();
    //                 Navigator.of(context).pop();
    //               },
    //               child: Text('New Game'))
    //         ],
    //       );
    //     });
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Winner"),
            content: Image.asset(tileState == TileState.BLUELIGHTSABER
                ? 'images/Blue transparent.png'
                : 'images/Red transparent.png'),
            actions: [
              ElevatedButton(
                child: Text("Play Again"),
                onPressed: () {
                  _resetGame();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void _resetGame() {
    setState(() {
      _boardState = List.filled(9, TileState.EMPTY);
      _currentTurn = TileState.BLUELIGHTSABER;
    });
  }
}
