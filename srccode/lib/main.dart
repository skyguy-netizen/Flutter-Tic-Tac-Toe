// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:srccode/tiles.dart';
import 'package:srccode/tile_state.dart';

// void main() {
//   runApp(MyApp());
// }

main() {
  runApp(MaterialApp(home: MyApp()));
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

  int blueLightSaberScore = 0;
  int redLightSaberScore = 0;

  @override
  Widget buildScoreBoard() {
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 255, 255, 255),
      body: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Player Red',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 0, 0)),
                      ),
                      Text(
                        blueLightSaberScore.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 255, 0, 0)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Player Blue',
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 13, 255))),
                      Text(
                        redLightSaberScore.toString(),
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 0, 13, 255)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors

    return MaterialApp(
        //ignore: prefer_const_constructors
        home: Scaffold(
            // appBar: AppBar(title: Text("ScoreCard") actions: buildScoreBoard(),),
            body: (Center(
      child: Stack(children: [
        Align(alignment: AlignmentDirectional.topEnd, child: buildScoreBoard()),
        Align(
            alignment: AlignmentDirectional.center,
            child: Image.asset("images/board.png")),
        Align(alignment: AlignmentDirectional.center, child: tiles()),
      ]),
    ))));
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

    bool draw = true;
    for (int i = 0; i < _boardState.length; i++) {
      if (_boardState[i] == TileState.EMPTY) {
        draw = false;
      }
    }
    if (draw == true) {
      _showDrawDialog();
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
            title: (tileState == TileState.BLUELIGHTSABER
                ? Text("Winner is Blue Lightsaber")
                : Text("Winner is Red Lightsaber")),
            // content: Image.asset(tileState == TileState.BLUELIGHTSABER
            //     ? 'images/Blue transparent.png'
            //     : 'images/Red transparent.png'),
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

  void _showDrawDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Its A Draw!!"),
            // content: Image.asset(tileState == TileState.BLUELIGHTSABER
            //     ? 'images/Blue transparent.png'
            //     : 'images/Red transparent.png'),
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
}
