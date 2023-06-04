import 'dart:math';

import '../core/data/enums.dart';
import 'board.dart';

class Agent {
  Point<int> position;
  Direction direction;
  bool hasGold = false;
  bool death = false;
  int arrow = 2;
  Board board = Board.forAgent();

  Agent({
    this.direction = Direction.east,
    this.position = const Point(3, 0),
  });

  void shoot() {
    // 활쏘는 로직 함수 호출
    arrow--;
  }

  void reBorn() {
    direction = Direction.east;
    position = const Point(3, 0);
  }

  Future<void> search(Board originalBoard) async {
    // 현재 위치한 타일의 state를 기반으로 상하좌우의 danger 계산
    // 계산된 danger에서 safe로 이동
    Tile originalTile = originalBoard.tile(position);

    if (originalTile.state.isEmpty) {
      board.addState(position.x, position.y, State.safe);
    } else {
      originalTile.state.forEach((state) {
        board.addState(position.x, position.y, state);
      });
    }

    Tile currentTile = board.tile(position);

    currentTile.state.toSet().forEach((state) {
      switch (state) {
        case State.safe:
          board.updateDanger(position.x, position.y, Danger.safe);
          break;
        case State.wumpus:
          reBorn();
        case State.pitch:
        case State.gold:
        case State.breeze:
          board.updateDanger(position.x, position.y, Danger.pitch);
          break;
        case State.glitter:
          board.updateDanger(position.x, position.y, Danger.gold);
          break;
        case State.stench:
          board.updateDanger(position.x, position.y, Danger.wumpus);
          break;
      }
    });
  }

  void move(Point<int> pos) {
    position = pos;
  }

  @override
  String toString() {
    return 'current position : ' + position.toString();
  }
}
