import 'dart:async';
import 'dart:math';

import 'package:wumpus_world/core/function/functions.dart';

import '../core/data/enums.dart';
import 'board.dart';

class Agent {
  Position pos;
  Direction dir;
  bool hasGold = false;
  bool giveUp = false;
  int arrow = 2;
  List<(Event, Point<int>)> events = [];

  Board board = Board.forAgent();

  Agent({this.pos = const Position(3, 0), this.dir = Direction.east});

  Future<void> setDirection(
    Direction dir,
    StreamController<Agent> agentStream,
  ) async {
    this.dir = dir;
    agentStream.add(this);
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> setPosition(
    Position pos,
    StreamController<Agent> agentStream,
  ) async {
    this.pos = pos;
    agentStream.add(this);
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<bool> shoot(
    Position target,
    Board originalBoard,
    StreamController<Agent> agentStream,
  ) async {
    bool scream = false;
    // 활쏘는 로직 함수 호출
    if (arrow > 0) {
      arrow--;
      scream = originalBoard.removeState(target, State.wumpus);
      events.add((Event.shoot, target));
      agentStream.add(this);

      await Future.delayed(const Duration(seconds: 1));

      if (scream) {
        if (board.tiles[target.x][target.y].state.isEmpty) {
          board.tiles[target.x][target.y].state.add(State.wumpus);
        }

        board.removeState(target, State.wumpus);
        events.add((Event.scream, target));
        agentStream.add(this);
      }
    }
    return scream;
  }

  void death() {
    dir = Direction.east;
    pos = const Position(3, 0);
    arrow = 2;
  }

  Future<void> search(
    Board oBoard,
    StreamController<Board> mapStream,
    StreamController<Agent> agentStream,
  ) async {
    Tile oTile = oBoard.getTile(pos);
    Tile cTile = board.getTile(pos);

    if (oTile.state.isEmpty) {
      board.addState(pos.x, pos.y, State.safe, withAround: false);
    } else {
      for (State state in oTile.state) {
        board.addState(pos.x, pos.y, state, withAround: false);
      }
    }
    cTile = board.getTile(pos);

    cTile.state.toSet().forEach((state) async {
      switch (state) {
        case State.wumpus || State.pitch:
          events.add((Event.death, pos));
          death();
          agentStream.add(this);
          await Future.delayed(Duration(seconds: 1));
          break;
        case State.gold:
          hasGold = true;
          oBoard.removeState(pos, State.gold);
          board.removeState(pos, State.gold);
          events.add((Event.gold, pos));
          agentStream.add(this);
          mapStream.add(oBoard);
          await Future.delayed(Duration(seconds: 1));
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
    (Danger, Position) target = hasGold
        ? (Danger.gold, const Position(3, 0))
        : getPossiblePosFunc(board, pos);

    events.add((Event.move, target.$2));
    agentStream.add(this);

    if (target.$1 == Danger.unKnown) {
      giveUp = true;
      return;
    }

    List<Position> path = getNavigatedPathFunc(pos, target.$2, board);

    if (hasGold) {
      board.tiles.forEach((List<Tile> row) {
        row.forEach((tile) {
          if (tile.danger.contains(Danger.safe)) {
            tile.state.add(State.safe);
          }
        });
      });
    }

    agentStream.add(this);

    for (int i = 0; i < path.length; i++) {
      await setDirection(getDirectionFunc(pos, path[i]), agentStream);
      if (target.$1 == Danger.wumpus && i == path.length - 1) {
        bool scream = await shoot(target.$2, oBoard, agentStream);
        // print(scream);
        // print(board.getTile(Position(0, 0)).toString());
        // print(pos);
        // k.log(pos.toString());
        // k.log(board.getTile(pos).toString());

        // k.log(board.getTile(pos).state.contains(State.stench).toString());
        if (scream && !board.getTile(pos).state.contains(State.stench)) {
          // print('aaaa');]
          // stenchfㅡㄹ 없애고
          board.updateDanger(pos.x, pos.y, Danger.wumpus, remove: true);
        }
        mapStream.add(oBoard);
        await Future.delayed(const Duration(seconds: 1));
      }
      await setPosition(path[i], agentStream);
    }
  }
}
