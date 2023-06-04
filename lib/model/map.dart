import 'package:wumpus_world/model/agent.dart';

import '../core/data/enums.dart';

class Map {
  List<List<Area>> areas = [
    [Area(danger: Danger.safe), Area(), Area(), Area()],
    [Area(), Area(), Area(), Area()],
    [Area(), Area(), Area(), Area()],
    [Area(), Area(), Area(), Area()],
  ];

  // Area point(int x, int y) {
  //   return _areas[3 - x][y];
  // }

  Agent agent = Agent();

  void deathEvent() {
    agent = Agent();
  }
}

class Area {
  List<State> state = [];
  Danger danger;

  Area({this.danger = Danger.unKnown});
}
