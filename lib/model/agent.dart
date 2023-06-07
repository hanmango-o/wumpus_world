import 'dart:async';
import 'dart:math';
import 'dart:developer' as k;

import 'package:wumpus_world/core/function/functions.dart';

import '../core/data/enums.dart';
import 'board.dart';

class Agent {
  Point<int> pos;
  Direction dir;
  bool hasGold = false;
  int arrow = 2;
  Board board = Board.forAgent();

  Agent({this.pos = const Point<int>(3, 0), this.dir = Direction.east});

  Future<void> setDirection(
    Direction dir,
    StreamController<Agent> agentStream,
  ) async {
    this.dir = dir;
    agentStream.add(this);
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> setPosition(
    Point<int> pos,
    StreamController<Agent> agentStream,
  ) async {
    this.pos = pos;
    agentStream.add(this);
    await Future.delayed(const Duration(seconds: 1));
  }

  bool shoot(Point<int> target, Board originalBoard) {
    // 활쏘는 로직 함수 호출
    if (arrow > 0) {
      bool scream = originalBoard.removeState(target, State.wumpus);
      if (scream) {
        board.removeState(target, State.wumpus);
      }
      arrow--;
      // k.log('shoot arrow to : ' + target.toString());
      return true;
    }
    return false;
  }

  void death() {
    dir = Direction.east;
    pos = const Point(3, 0);
    arrow = 2;
  }

  Future<void> search(
    Board oBoard,
    StreamController<Board> mapStream,
  ) async {
    Tile oTile = oBoard.getTile(pos);

    if (oTile.state.isEmpty) {
      board.addState(pos.x, pos.y, State.safe, withAround: false);
    } else {
      for (var state in oTile.state) {
        board.addState(pos.x, pos.y, state, withAround: false);
      }
    }

    Tile cTile = board.getTile(pos);

    cTile.state.toSet().forEach((state) {
      switch (state) {
        case State.wumpus || State.pitch:
          death();
          break;
        case State.gold:
          hasGold = true;
          oBoard.removeState(pos, State.gold);
          board.removeState(pos, State.gold);
          mapStream.add(oBoard);
          break;
        default:
          board.updateDanger(pos.x, pos.y, dangerMap[state]!);
          break;
      }
    });
  }

  Future<void> move(
    Board oBoard,
    StreamController<Agent> agentStream,
    StreamController<Board> mapStream,
  ) async {
    (Danger, Point<int>) target = hasGold
        ? (Danger.gold, const Point(3, 0))
        : getPossiblePosFunc(board, pos);

    // k.log('target : ' + target.toString());
    List<Point<int>> path = getNavigatedPathFunc(pos, target.$2, board);
    // k.log(path.toString());

    for (int i = 0; i < path.length; i++) {
      await setDirection(getDirectionFunc(pos, path[i]), agentStream);
      if (target.$1 == Danger.wumpus && i == path.length - 1) {
        shoot(target.$2, oBoard);
        mapStream.add(oBoard);
      }
      await setPosition(path[i], agentStream);
    }
  }

  @override
  String toString() {
    return 'current position : ' + pos.toString();
  }
}
