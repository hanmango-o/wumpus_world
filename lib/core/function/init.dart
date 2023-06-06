import 'package:wumpus_world/model/board.dart';

import '../../model/agent.dart';

// original 맵을 만들고 에이전트 설정하는 함수, 처음 호출
(Board, Agent) init() {
  Board board = Board();
  Agent agent = Agent();

  return (board, agent);
}

const List<List<int>> dxdy = [
  [-1, 0],
  [1, 0],
  [0, -1],
  [0, 1],
];
// List<Point<int>> navigateSafePath(Point<int> start, Point<int> destination) {
//     List<Point<int>> visited = [];
//     List<Point<int>> pointQueue = [start];
//     List<List<Point<int>>> pathQueue = [[]];
//     List<Point<int>> safePath = []; // 안전한 경로

//     while (pointQueue.isNotEmpty) {//큐가 비어있지 않고, 경로를 아직 못 찾았을 때
      
//       Point<int> currentPoint = pointQueue[0];
//       List<Point<int>> currentPath = pathQueue[0];
//       pointQueue.removeAt(0);
//       pathQueue.removeAt(0);

//       if(currentPoint == destination){
//         safePath = currentPath;
//         break;
//       }

//       visited.add(currentPoint); //현재 좌표 방문처리

//       _dxdy.forEach((d) {
//         //사방 탐색
//         try {
//           Point<int> nextPoint =
//               Point(currentPoint.x + d[0], currentPoint.y + d[1]); //다음 탐색할 좌표
//           if (visited.contains(nextPoint)) {
//             //다음 좌표가 방문한 좌표면 고려하지 않음
//             throw (e);
//           }
//           Tile nextTile = board.tiles[nextPoint.x][nextPoint.y]; //다음 좌표의 타일
//           if (nextTile.danger.contains(Danger.safe)) {
//             //타일의 Danger가 safe이면
//             List<Point<int>> nextPath = List.from(currentPath);
//             nextPath.add(nextPoint); //현재 경로에 다음 좌표를 추가해 경로 생성
//             pointQueue.add(nextPoint);
//             pathQueue.add(nextPath);
//           }
//         } catch (e) {}
//       });
//     }
    
//     return safePath;
//   }