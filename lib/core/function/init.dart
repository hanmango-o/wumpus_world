import 'package:wumpus_world/model/board.dart';

import '../../model/agent.dart';

// original 맵을 만들고 에이전트 설정하는 함수, 처음 호출
(Board, Agent) init() {
  Board board = Board();
  Agent agent = Agent();

  return (board, agent);
}
