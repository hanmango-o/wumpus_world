import 'dart:math';
import 'dart:developer' as k;

import '../core/data/enums.dart';

class Board {
  List<List<Tile>> tiles =
      List.generate(4, (x) => List.generate(4, (x) => Tile()));

  final List<List<int>> _dxdy = [
    [-1, 0],
    [1, 0],
    [0, -1],
    [0, 1],
  ];

  Tile tile(Point<int> position) => tiles[position.x][position.y];

  bool _notExistWumpusAndPitch(int x, int y) =>
      !tiles[x][y].state.contains(State.wumpus) &&
      !tiles[x][y].state.contains(State.pitch);

  void _setAroundState(int x, int y, State state) {
    _dxdy.forEach((d) {
      try {
        tiles[x + d[0]][y + d[1]].state.add(state);
      } catch (e) {}
    });
  }

  void _setAroundDanger(int x, int y, Danger danger) {
    //상하좌우 danger

    _dxdy.forEach((d) {
      k.log('ddd');
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

  void addState(int x, int y, State state) {
    k.log('message');
    switch (state) {
      case State.wumpus:
        tiles[x][y].state.add(State.wumpus);
        _setAroundState(x, y, State.stench);
        break;
      case State.pitch:
        tiles[x][y].state.add(State.pitch);
        _setAroundState(x, y, State.breeze);
        break;
      case State.gold:
        tiles[x][y].state.add(State.gold);
        _setAroundState(x, y, State.glitter);
        break;
      default:
        k.log('asdfasdf');
        tiles[x][y].state.add(state);
        break;
    }
  }

  void removeState() {}

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
        if (randnum == 1 && _notExistWumpusAndPitch(i, j)) {
          //wumpus 생성
          addState(i, j, State.wumpus);
        } else if (randnum == 2 && _notExistWumpusAndPitch(i, j)) {
          //pitch 생성
          addState(i, j, State.pitch);
        } else if (randnum == 3 &&
            notExistGold &&
            _notExistWumpusAndPitch(i, j)) {
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
}
