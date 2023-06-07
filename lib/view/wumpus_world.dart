import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wumpus_world/controller/controller.dart';
import 'package:wumpus_world/model/board.dart';

import '../model/agent.dart';

class WumpusWorld extends StatefulWidget {
  const WumpusWorld({super.key});

  @override
  State<WumpusWorld> createState() => _WumpusWorldState();
}

class _WumpusWorldState extends State<WumpusWorld> {
  late Controller controller;
  List<Agent> history = [];

  @override
  void initState() {
    controller = GameController();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 3,
                  child: FittedBox(
                    child: Container(
                      color: Colors.amber,
                      child: Stack(
                        children: [
                          StreamBuilder<Board>(
                            stream: controller.mapStream.stream,
                            initialData: controller.map,
                            builder: (context, snapshot) {
                              // print(snapshot.data!.tiles);
                              return Column(
                                children: [
                                  _renderTile(snapshot.data!.tiles[0]),
                                  _renderTile(snapshot.data!.tiles[1]),
                                  _renderTile(snapshot.data!.tiles[2]),
                                  _renderTile(snapshot.data!.tiles[3]),
                                ],
                              );
                            },
                          ),
                          StreamBuilder<Agent>(
                            stream: controller.agentStream.stream,
                            initialData: controller.agent,
                            builder: (context, snapshot) {
                              return AnimatedPositioned(
                                width: 50,
                                height: 50,
                                left: 52 + 52.0 * snapshot.data!.pos.y * 3,
                                top: 52 + 52.0 * snapshot.data!.pos.x * 3,

                                duration: const Duration(microseconds: 300),
                                // curve: Curves.fastOutSlowIn,
                                child: ColoredBox(
                                  color: Colors.green,
                                  child: Center(
                                    child: Text(
                                      snapshot.data!.dir.toString(),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Flexible(
                //   flex: 1,
                //   child: Container(
                //     // color: Colors.amber,
                //     height: 640,
                //     child: StreamBuilder(
                //       initialData: controller.agent,
                //       stream: controller.agentStream.stream,
                //       builder: (context, snapshot) {
                //         history.add(snapshot.data!);
                //         print(history.toString());
                //         return ListView(
                //           children: history
                //               .map((agent) => Text(agent.toString()))
                //               .toList(),
                //         );
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await controller.startGame();
                _showDialog();
              },
              child: Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('I got a gold!!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                setState(() {
                  controller = GameController();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
