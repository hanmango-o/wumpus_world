import 'dart:async';
import '../model/agent.dart';
import '../model/board.dart';

abstract class Controller {
  StreamController<Agent> agentStream = StreamController.broadcast();
  StreamController<Board> mapStream = StreamController();
  StreamController<List<Agent>> historyStream = StreamController();

  late Agent agent;
  late Board map;
  List<Agent> history = [];

  Controller() {
    agent = Agent();
    // map = Board();
    map = Board.forTest();
    agentStream.add(agent);
    mapStream.add(map);
    historyStream.add(history);
  }

  Future<void> start();
  Future<void> reset();
}

class GameController extends Controller {
  @override
  Future<void> start() async {
    try {
      while (!agent.hasGold) {
        if (agent.giveUp) break;
        await agent.search(map, mapStream, agentStream);
        await agent.move(map, agentStream, mapStream);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> reset() async {
    agent = Agent();
    map = Board();
    agentStream.add(agent);
    mapStream.add(map);
    historyStream.add(history);
  }
}
