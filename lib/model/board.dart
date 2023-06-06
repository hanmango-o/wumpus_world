import 'dart:math';

import 'package:wumpus_world/core/function/init.dart';

import '../core/data/enums.dart';

class Board {
  List<List<Tile>> tiles =
      List.generate(4, (x) => List.generate(4, (y) => Tile(Point<int>(x, y))));

  Tile tile(Point<int> position) => tiles[position.x][position.y];

  bool _notExistWumPit(int x, int y) =>
      !tiles[x][y].state.contains(State.wumpus) &&
      !tiles[x][y].state.contains(State.pitch);

  void _setAroundState(int x, int y, State state, {bool remove = false}) {
    dxdy.forEach((d) {
      try {
        if (remove) {
          tiles[x + d[0]][y + d[1]].state.remove(state);
        } else {
          tiles[x + d[0]][y + d[1]].state.add(state);
        }
      } catch (e) {}
    });
  }

  void _setAroundDanger(int x, int y, Danger danger) {
    //상하좌우 danger

    dxdy.forEach((d) {
      try {
        if (tiles[x + d[0]][y + d[1]].danger.contains(Danger.safe)) {
          throw e;
        } else if (tiles[x + d[0]][y + d[1]].danger.contains(Danger.unKnown)) {
          tiles[x + d[0]][y + d[1]].danger.clear();
        }
        tiles[x + d[0]][y + d[1]].danger.add(danger);
      } catch (e) {
        print(e);
      }
    });
  }

  List<Tile> getAroundTile(Point<int> pos) {
    List<Tile> tiles = [];

    dxdy.forEach((d) {
      try {
        tiles.add(this.tiles[pos.x + d[0]][pos.y + d[1]]);
      } catch (e) {}
    });

    return tiles;
  }

  void addState(int x, int y, State state, {bool withAround = true}) {
    switch (state) {
      case State.wumpus:
        tiles[x][y].state.add(State.wumpus);
        if (withAround) _setAroundState(x, y, State.stench);
        break;
      case State.pitch:
        tiles[x][y].state.add(State.pitch);
        if (withAround) _setAroundState(x, y, State.breeze);
        break;
      case State.gold:
        tiles[x][y].state.add(State.gold);
        if (withAround) _setAroundState(x, y, State.glitter);
        break;
      default:
        tiles[x][y].state.add(state);
        break;
    }
  }

  bool removeState(Point<int> pos, State state) {
    bool isRemove = tiles[pos.x][pos.y].state.remove(state);
    if (isRemove) {
      if (state == State.wumpus) {
        _setAroundState(pos.x, pos.y, State.stench, remove: true);
      } else {
        _setAroundState(pos.x, pos.y, State.glitter, remove: true);
      }
    }

    return isRemove;
  }

  void updateDanger(int x, int y, Danger danger) {
    tiles[x][y].danger = [Danger.safe];
    _setAroundDanger(x, y, danger);
  }

  Board() {
    bool notExistGold = true; //Gold 생성 여부
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if ((i == 3 && j == 0)) continue; //agent 시작 위치
        int randnum = Random().nextInt(10); //랜덤 난수 시작
        if (randnum == 1 && _notExistWumPit(i, j)) {
          //wumpus 생성
          addState(i, j, State.wumpus);
        } else if (randnum == 2 && _notExistWumPit(i, j)) {
          //pitch 생성
          addState(i, j, State.pitch);
        } else if (randnum == 3 && notExistGold && _notExistWumPit(i, j)) {
          //gold 생성
          addState(i, j, State.gold);
          notExistGold = false;
        }
      }
    }
  }

  Board.forAgent() {
    tiles[3][0].danger = [Danger.safe];
  }
}

class Tile {
  List<State> state = [];
  List<Danger> danger = [Danger.unKnown];

  Point<int> pos;

  Tile(this.pos);
}
