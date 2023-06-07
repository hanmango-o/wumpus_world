import 'dart:async';
import 'dart:math';

import '../core/data/enums.dart';
import '../model/agent.dart';
import '../model/board.dart';

abstract class Controller {
  // StreamController<Point<int>> posStream = StreamController();
  StreamController<Agent> agentStream = StreamController();
  StreamController<Board> mapStream = StreamController();

  final Agent agent = Agent();
  final Board map = Board();

  Controller() {
    agentStream.add(agent);
    // dirStream.add(agent.dir);
    mapStream.add(map);
  }

  Future<void> startGame();
}

class GameController extends Controller {
  @override
  Future<void> startGame() async {
    while (!agent.hasGold) {
      await agent.search(map, mapStream);
      await agent.move(map, agentStream, mapStream);
    }
  }
}
