import 'dart:math';
import 'dart:developer' as k;

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
    arrow = 2;
  }

  Future<void> search(Board originalBoard) async {
    // 현재 위치한 타일의 state를 기반으로 상하좌우의 danger 계산
    // 계산된 danger에서 safe로 이동
    Tile originalTile = originalBoard.tile(position);

    if (originalTile.state.isEmpty) {
      board.addState(position.x, position.y, State.safe, withAround: false);
    } else {
      originalTile.state.forEach((state) {
        board.addState(position.x, position.y, state, withAround: false);
      });
    }

    Tile currentTile = board.tile(position);

    currentTile.state.toSet().forEach((state) {
      switch (state) {
        case State.safe:
          board.updateDanger(position.x, position.y, Danger.safe);
          break;
        case State.wumpus:
        case State.pitch:
          reBorn();
          break;
        case State.gold:
          hasGold = true;
          k.log('finish!');
          break;
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

  void move() {
    // 기본적으로 이동은 내가 바라보고 있는 방향으로 한칸 전진
    // 바라보고 있는 방향 변경(optional) > 전진의 구조
    // 이 메소드에서는 3가지 경우에 따라 갈려고 하는 좌표를 산출 : _getPossiblePos()
    // 이동은 별개의 메소드로 만들자 : _dfs()
    k.log('current position : ' + position.toString());

    Point<int> pos = _getPossiblePos();
    position = pos;
    k.log('move to : ' + position.toString());
  }

  Point<int> _getPossiblePos() {
    List<Tile> tiles = board.getAroundTile(position);

    // 0순위. 전체 지도에서 danger.gold 이면서 state.isempty 인 지역
    for (List<Tile> row in board.tiles) {
      for (Tile tile in row) {
        if (tile.danger.contains(Danger.gold) && tile.state.isEmpty) {
          return tile.pos;
        }
      }
    }

    // 1순위. 현재 내가 있는 위치에서 갈 수 있는 지역(사방) 중 danger.safe 이면서 state.isempty인 지역
    for (Tile tile in tiles) {
      if (tile.danger.contains(Danger.safe) && tile.state.isEmpty) {
        return tile.pos;
      }
    }
    // 2순위. 1순위에 해당하는 지역이 없을 경우, agent가 가지고 있는 지도 전체에서 danger.safe이면서 state.isempty인 지역
    for (List<Tile> row in board.tiles) {
      for (Tile tile in row) {
        if (tile.danger.contains(Danger.safe) && tile.state.isEmpty) {
          return tile.pos;
        }
      }
    }
    // 3순위. 2순위까지도 없을 경우, 현재 지도에서 danger.wumpus > danger.pitch 순으로 찾자
    // wumpus 를 찾는다.(danger에 속한 wumpus가 제일 많은 부분)
    // 화살을 쏜다.
    // 비명이 들리면 죽고 이동, 안들려도 이동
    Tile? wumpusTarget;
    Tile? pitchTarget;
    List<int> highProbability = [-1, 100]; // wumpus, pitch

    for (List<Tile> row in board.tiles) {
      for (Tile tile in row) {
        if (tile.danger.contains(Danger.wumpus) && tile.state.isEmpty) {
          int probability = countOccurrences(tile.danger, Danger.wumpus);
          if (highProbability[0] < probability) wumpusTarget = tile;
        }

        if (tile.danger.contains(Danger.pitch) && tile.state.isEmpty) {
          int probability = countOccurrences(tile.danger, Danger.pitch);
          if (highProbability[1] > probability) pitchTarget = tile;
        }
      }
    }

    return wumpusTarget != null ? wumpusTarget.pos : pitchTarget!.pos;
  }

  void _dfs(Point<int> to) {
    // Point<int> from = position;
  }

  int countOccurrences(List<Danger> values, Danger element) =>
      values.where((e) => e == element).length;

  @override
  String toString() {
    return 'current position : ' + position.toString();
  }
}
