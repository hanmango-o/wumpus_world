import 'package:wumpus_world/model/map.dart';

import '../../model/agent.dart';

// original 맵을 만들고 에이전트 설정하는 함수, 처음 호출
(Map, Agent) init() {
  Map map = Map();
  Agent agent = Agent();

  return (map, agent);
}
