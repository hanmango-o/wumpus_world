import 'package:flutter/material.dart';
import 'package:wumpus_world/model/board.dart';

import '../model/agent.dart';

class WumpusWorld extends StatefulWidget {
  const WumpusWorld({super.key});

  @override
  State<WumpusWorld> createState() => _WumpusWorldState();
}

class _WumpusWorldState extends State<WumpusWorld> {
  late Board board;
  late Agent agent;

  @override
  void initState() {
    board = Board();
    agent = Agent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wumpus World'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _renderTile(board.tiles[0]),
            _renderTile(board.tiles[1]),
            _renderTile(board.tiles[2]),
            _renderTile(board.tiles[3]),
            Divider(),
            _renderTile2(agent.board.tiles[0]),
            _renderTile2(agent.board.tiles[1]),
            _renderTile2(agent.board.tiles[2]),
            _renderTile2(agent.board.tiles[3]),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  agent.search(board);
                  agent.move();
                });
              },
              child: Text('Start Game'),
            )
          ],
        ),
      ),
    );
  }

  Widget _renderTile(List<Tile> list) {
    return Row(
      children: list
          .map(
            (tile) => Container(
              margin: EdgeInsets.all(5.0),
              height: 150,
              width: 150,
              color: Colors.blue,
              child: Text(tile.state.toString()),
            ),
          )
          .toList(),
    );
  }

  Widget _renderTile2(List<Tile> list) {
    return Row(
      children: list
          .map(
            (tile) => Container(
              margin: EdgeInsets.all(5.0),
              height: 150,
              width: 150,
              color: Colors.amber,
              child: Column(
                children: [
                  Text(tile.danger.toString()),
                  Text(tile.state.toString()),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
