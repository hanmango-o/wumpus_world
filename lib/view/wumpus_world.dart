import 'dart:math';

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
    agent.posController.add(agent.position);
    agent.dirController.add(agent.direction);
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
            FittedBox(
              child: Container(
                color: Colors.amber,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        _renderTile(board.tiles[0]),
                        _renderTile(board.tiles[1]),
                        _renderTile(board.tiles[2]),
                        _renderTile(board.tiles[3]),
                      ],
                    ),
                    StreamBuilder<Point<int>>(
                      stream: agent.posController.stream,
                      initialData: Point(3, 0),
                      builder: (context, snapshot) {
                        // k.log(snapshot.data.toString());
                        return AnimatedPositioned(
                          width: 50,
                          height: 50,
                          left: 52 + 52.0 * snapshot.data!.y * 3,
                          top: 52 + 52.0 * snapshot.data!.x * 3,
                          // left: 155.0,
                          // right: 155.0,
                          // left: boardWidth / 16 + boardWidth * x / 4,
                          // top: boardWidth / 16 + boardWidth * y / 4,

                          duration: const Duration(seconds: 1),
                          // curve: Curves.fastOutSlowIn,
                          child: const ColoredBox(
                            color: Colors.green,
                            child: Center(child: Text('')),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            _renderTile2(agent.board.tiles[0]),
            _renderTile2(agent.board.tiles[1]),
            _renderTile2(agent.board.tiles[2]),
            _renderTile2(agent.board.tiles[3]),
            ElevatedButton(
              onPressed: () async {
                agent.search(board);
                await agent.move(board);
              },
              child: Text('Start Game'),
            ),
            // StreamBuilder(
            //   stream: agent.posController.stream,
            //   builder: (context, snapshot) {
            //     log(snapshot.data.toString());
            //     return Text(
            //       snapshot.data.toString(),
            //       style: TextStyle(color: Colors.red, fontSize: 30),
            //     );
            //   },
            // ),
            StreamBuilder(
              stream: agent.dirController.stream,
              builder: (context, snapshot) {
                return Text(
                  snapshot.data.toString(),
                  style: TextStyle(color: Colors.blue, fontSize: 30),
                );
              },
            ),
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
              margin: EdgeInsets.all(4.0),
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
