import 'dart:collection';
import 'dart:math';

import '../../model/board.dart';
import '../data/enums.dart';

const List<List<int>> dxdy = [
  [-1, 0],
  [1, 0],
  [0, -1],
  [0, 1],
];

Map<State, State> stateMap = {
  State.wumpus: State.stench,
  State.pitch: State.breeze,
  State.gold: State.glitter,
};

Map<State, Danger> dangerMap = {
  State.safe: Danger.safe,
  State.stench: Danger.wumpus,
  State.breeze: Danger.pitch,
  State.glitter: Danger.gold
};

(Danger, Point<int>) getPossiblePosFunc(Board board, Point<int> pos) {
  List<Tile> tiles = board.getAroundTiles(pos);

  // 0순위. 전체 지도에서 danger.gold 이면서 state.isempty 인 지역
  for (List<Tile> row in board.tiles) {
    for (Tile tile in row) {
      if (tile.danger.contains(Danger.gold) && tile.state.isEmpty) {
        // danger.wumpus도 같이 있을 경우 활 쏨 return (Danger.wumpus, tile.pos)
        if (tile.danger.contains(Danger.wumpus)) {
          return (Danger.wumpus, tile.pos);
        }

        return (Danger.gold, tile.pos);
      }
    }
  }

  // 1순위. 현재 내가 있는 위치에서 갈 수 있는 지역(사방) 중 danger.safe 이면서 state.isempty인 지역
  for (Tile tile in tiles) {
    if (tile.danger.contains(Danger.safe) && tile.state.isEmpty) {
      // k.log('dd');
      // k.log(tile.pos.toString());
      return (Danger.safe, tile.pos);
    }
  }
  // 2순위. 1순위에 해당하는 지역이 없을 경우, agent가 가지고 있는 지도 전체에서 danger.safe이면서 state.isempty인 지역
  for (List<Tile> row in board.tiles) {
    for (Tile tile in row) {
      if (tile.danger.contains(Danger.safe) && tile.state.isEmpty) {
        return (Danger.safe, tile.pos);
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
        int probability = countOccurrencesFunc(tile.danger, Danger.wumpus);
        if (highProbability[0] < probability) wumpusTarget = tile;
      }

      if (tile.danger.contains(Danger.pitch) && tile.state.isEmpty) {
        int probability = countOccurrencesFunc(tile.danger, Danger.pitch);
        if (highProbability[1] > probability) pitchTarget = tile;
      }
    }
  }

  if (wumpusTarget != null) {
    return (Danger.wumpus, wumpusTarget.pos);
  } else if (pitchTarget != null) {
    return (Danger.pitch, pitchTarget.pos);
  } else {
    print('이게 맞아?');
    return (Danger.safe, const Point(3, 0));
  }
}

Direction getDirectionFunc(Point<int> now, Point<int> next) {
  if (next.x - now.x < 0) {
    // 다음 x좌표가 현재보다 작은 경우는 북쪽
    return Direction.north;
  } else if (next.x - now.x > 0) {
    return Direction.south;
  } else if (next.y - now.y < 0) {
    return Direction.west;
  } else {
    return Direction.east;
  }
}

int countOccurrencesFunc(List<Danger> values, Danger element) =>
    values.where((e) => e == element).length;

List<Point<int>> getNavigatedPathFunc(
  Point<int> from,
  Point<int> to,
  Board board,
) {
  List<Point<int>> visited = []; //방문한 좌표
  List<Point<int>> path = [];
  Queue<(Point<int>, List<Point<int>>)> queue = Queue(); // 탐색에 사용할 큐

  queue.add((from, [])); // 큐에는 [탐색할 점, 현재까지의 경로] 가 들어간다

  while (queue.isNotEmpty) {
    //큐가 비어있지 않고, safePath가 비어있을 때(아직 못 찾은 경우)
    (Point<int>, List<Point<int>>) current = queue.removeFirst(); //큐의 맨 앞 원소 반환
    Point<int> currentPos = current.$1; // 현재 좌표
    List<Point<int>> currentPath = current.$2; //현재 좌표까지의 경로

    if (currentPos == to) {
      path = currentPath;
      break;
    }

    visited.add(currentPos); //현재 좌표 방문처리

    for (List<int> d in dxdy) {
      //사방 탐색
      try {
        Point<int> nextPos =
            Point(currentPos.x + d[0], currentPos.y + d[1]); //다음 탐색할 좌표

        if (visited.contains(nextPos)) {
          //다음 좌표가 방문한 좌표면 고려하지 않음
          throw (e);
        }
        Tile nextTile = board.tiles[nextPos.x][nextPos.y]; //다음 좌표의 타일

        if (nextTile.danger.contains(Danger.safe) || nextPos == to) {
          //타일의 Danger가 safe이면
          List<Point<int>> nextPath = List.from(currentPath);
          nextPath.add(nextPos); //현재 경로에 다음 좌표를 추가해 경로 생성
          queue.add((nextPos, nextPath)); // 큐에 삽입
        }
      } catch (e) {}
    }
  }
  return path;
}

void setAroundStateFunc(
  int x,
  int y,
  State state,
  Board board, {
  bool remove = false,
}) {
  dxdy.forEach((d) {
    try {
      if (remove) {
        board.tiles[x + d[0]][y + d[1]].state.remove(state);
      } else {
        board.tiles[x + d[0]][y + d[1]].state.add(state);
      }
    } catch (e) {}
  });
}

bool checkNotExistWumPitFunc(int x, int y, List<List<Tile>> tiles) =>
    !tiles[x][y].state.contains(State.wumpus) &&
    !tiles[x][y].state.contains(State.pitch);

void setAroundDangerFunc(int x, int y, Danger danger, List<List<Tile>> tiles) {
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