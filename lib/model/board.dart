import 'dart:math';

import 'package:wumpus_world/core/function/functions.dart';

import '../core/data/enums.dart';

class Board {
  List<List<Tile>> tiles =
      List.generate(4, (x) => List.generate(4, (y) => Tile(Point<int>(x, y))));

  Board() {
    bool notExistGold = true; //Gold 생성 여부
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if ((i == 3 && j == 0)) continue; //agent 시작 위치
        int randnum = Random().nextInt(10); //랜덤 난수 시작
        if (randnum == 1 && checkNotExistWumPitFunc(i, j, tiles)) {
          //wumpus 생성
          addState(i, j, State.wumpus);
        } else if (randnum == 2 && checkNotExistWumPitFunc(i, j, tiles)) {
          //pitch 생성
          addState(i, j, State.pitch);
        } /* else if (randnum == 3 && notExistGold && _notExistWumPit(i, j)) {
          //gold 생성
          addState(i, j, State.gold);
          notExistGold = false;

        }*/
      }
    }

    do {
      if (notExistGold == false) {
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 3; j++) {
            if (1 == Random().nextInt(10) &&
                checkNotExistWumPitFunc(i, j, tiles)) {
              addState(i, j, State.gold);
              notExistGold = true;
            }
          }
        }
      }
    } while (notExistGold == false);
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
      setAroundStateFunc(x, y, stateMap[state]!, tiles);
    }
  }

  bool removeState(Point<int> pos, State state) {
    bool isRemove = tiles[pos.x][pos.y].state.remove(state);
    if (isRemove) {
      setAroundStateFunc(pos.x, pos.y, stateMap[state]!, tiles, remove: true);
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
