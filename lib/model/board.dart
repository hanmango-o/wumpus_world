// ignore_for_file: empty_catches

import 'dart:math';

import 'package:wumpus_world/core/function/functions.dart';

import '../core/data/enums.dart';

class Board {
  List<List<Tile>> tiles =
      List.generate(4, (x) => List.generate(4, (y) => Tile(Position(x, y))));

  Board.forTest() {
    // addState(3, 1, State.wumpus);
    addState(3, 3, State.gold);
    addState(3, 1, State.pitch);
    addState(3, 2, State.pitch);
    addState(2, 0, State.pitch);
    addState(2, 3, State.pitch);
  }

  Board() {
    int goldRow = 3;
    int goldCol = 0;

    while ((goldRow == 3 && goldCol == 0)) {
      goldRow = Random().nextInt(4);
      goldCol = Random().nextInt(4);
    }
    addState(goldRow, goldCol, State.gold);

    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if ((i == goldRow && j == goldCol) || (i == 3 && j == 0)) {
          continue;
        }
        int randnum = Random().nextInt(10);
        if (randnum == 1) {
          //wumpus 생성
          addState(i, j, State.wumpus);
        } else if (randnum == 2) {
          //pitch 생성
          addState(i, j, State.pitch);
        }
      }
    }
  }

  Board.forAgent() {
    tiles[3][0].danger = [Danger.safe];
  }

  Tile getTile(Position position) => tiles[position.x][position.y];

  List<Tile> getAroundTiles(Position pos) {
    List<Tile> tiles = [];

    for (List<int> d in dxdy) {
      try {
        tiles.add(this.tiles[pos.x + d[0]][pos.y + d[1]]);
      } catch (e) {}
    }

    return tiles;
  }

  void addState(int x, int y, State state, {bool withAround = true}) {
    tiles[x][y].state.add(state);
    if (stateMap.containsKey(state) && withAround) {
      setAroundStateFunc(x, y, stateMap[state]!, this);
    }
  }

  bool removeState(Position pos, State state, {bool only = true}) {
    bool isRemove = tiles[pos.x][pos.y].state.remove(state);
    if (isRemove) {
      setAroundStateFunc(pos.x, pos.y, stateMap[state]!, this, remove: true);
    }

    return isRemove;
  }

  void updateDanger(int x, int y, Danger danger, {bool remove = false}) {
    if (checkNotExistWumPitFunc(x, y, tiles)) {
      tiles[x][y].danger = [Danger.safe];
    }
    setAroundDangerFunc(x, y, danger, tiles, remove: remove);
  }

  // void removeDanger(Position pos, Danger danger) {
  //   tiles[pos.x][pos.y].danger.remove(danger);
  //   setAroundDangerFunc(pos.x, pos.y, danger, tiles, remove: true);
  // }

//   @override
//   String toString() {
//     return '''
// ${tiles[0][0]} | ${tiles[0][1]} | ${tiles[0][2]} | ${tiles[0][3]}
// ${tiles[1][0]} | ${tiles[1][1]} | ${tiles[1][2]} | ${tiles[1][3]}
// ${tiles[2][0]} | ${tiles[2][1]} | ${tiles[2][2]} | ${tiles[2][3]}
// ${tiles[3][0]} | ${tiles[3][1]} | ${tiles[3][2]} | ${tiles[3][3]}
// ''';
//   }
}

class Tile {
  List<State> state = [];
  List<Danger> danger = [Danger.unKnown];

  Position pos;

  Tile(this.pos);

  @override
  String toString() {
    return 'State : $state, Danger : $danger';
  }
}

class Position extends Point<int> {
  const Position(super.x, super.y);

  @override
  String toString() {
    return '(${y + 1}, ${4 - x})';
  }
}
