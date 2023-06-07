import 'dart:math';

import 'package:wumpus_world/core/function/functions.dart';

import '../core/data/enums.dart';

class Board {
  List<List<Tile>> tiles =
      List.generate(4, (x) => List.generate(4, (y) => Tile(Point<int>(x, y))));

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

  Tile getTile(Point<int> position) => tiles[position.x][position.y];

  List<Tile> getAroundTiles(Point<int> pos) {
    List<Tile> tiles = [];

    dxdy.forEach((d) {
      try {
        tiles.add(this.tiles[pos.x + d[0]][pos.y + d[1]]);
      } catch (e) {}
    });

    return tiles;
  }

  void addState(int x, int y, State state, {bool withAround = true}) {
    tiles[x][y].state.add(state);
    if (stateMap.containsKey(state)) {
      setAroundStateFunc(x, y, stateMap[state]!, this);
    }
  }

  bool removeState(Point<int> pos, State state) {
    bool isRemove = tiles[pos.x][pos.y].state.remove(state);
    if (isRemove) {
      setAroundStateFunc(pos.x, pos.y, stateMap[state]!, this, remove: true);
    }

    return isRemove;
  }

  void updateDanger(int x, int y, Danger danger) {
    tiles[x][y].danger = [Danger.safe];
    setAroundDangerFunc(x, y, danger, tiles);
  }
}

class Tile {
  List<State> state = [];
  List<Danger> danger = [Danger.unKnown];

  Point<int> pos;

  Tile(this.pos);
}
