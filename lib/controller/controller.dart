import 'dart:async';
import '../model/agent.dart';
import '../model/board.dart';

abstract class Controller {
  // StreamController<Point<int>> posStream = StreamController();
  StreamController<Agent> agentStream = StreamController.broadcast();
  StreamController<Board> mapStream = StreamController();
  StreamController<List<Agent>> historyStream = StreamController();

  late Agent agent;
  late Board map;
  List<Agent> history = [];

  Controller() {
    agent = Agent();
    map = Board();
    agentStream.add(agent);
    // dirStream.add(agent.dir);
    mapStream.add(map);
    historyStream.add(history);
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
