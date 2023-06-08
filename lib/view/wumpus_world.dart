import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wumpus_world/controller/controller.dart';
import 'package:wumpus_world/model/board.dart';
import 'package:wumpus_world/view/widgets/agent_element.dart';
import 'package:wumpus_world/view/widgets/tile_element.dart';

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
        title: const Text('Wumpus World'),
        centerTitle: false,
      ),
      body: Row(
        children: [
          Flexible(
            flex: 3,
            child: Container(
              height: double.infinity,
              color: Color.fromARGB(255, 255, 255, 255),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: constraints.maxHeight,
                        width: constraints.maxHeight,
                        child: Stack(
                          children: [
                            StreamBuilder<Board>(
                              stream: controller.mapStream.stream,
                              initialData: controller.map,
                              builder: (context, snapshot) {
                                // print(snapshot.data!.tiles);
                                return GridView.count(
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  children: snapshot.data!.tiles
                                      .expand((List<Tile> row) => row)
                                      .toList()
                                      .map((tile) {
                                    return TileElement(tile: tile);
                                  }).toList(),
                                );
                              },
                            ),
                            StreamBuilder<Agent>(
                              stream: controller.agentStream.stream,
                              initialData: controller.agent,
                              builder: (context, snapshot) {
                                return AnimatedPositioned(
                                  width: constraints.maxHeight / 5,
                                  height: constraints.maxHeight / 5,
                                  left: (constraints.maxHeight - 10) /
                                          4 *
                                          snapshot.data!.pos.y +
                                      (constraints.maxHeight - 10) / 8 -
                                      constraints.maxHeight / 10 +
                                      5 * snapshot.data!.pos.y,
                                  top: (constraints.maxHeight - 10) /
                                          4 *
                                          snapshot.data!.pos.x +
                                      (constraints.maxHeight - 10) / 8 -
                                      constraints.maxHeight / 10 +
                                      2.5 * snapshot.data!.pos.x,

                                  duration: const Duration(microseconds: 300),
                                  // curve: Curves.fastOutSlowIn,
                                  child: AgentElement(agent: snapshot.data!),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              height: double.infinity,
              // color: Colors.black,
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text('ddd'),
                            subtitle: Text('dd'),
                            leading: Icon(Icons.directions_walk),
                            trailing: Icon(Icons.ac_unit),
                          ),
                          ListTile(
                            title: Text('ddd'),
                            subtitle: Text('dd'),
                            // leading: Icon(CupertinoIcons.arrow),
                            trailing: Icon(Icons.ac_unit),
                          ),
                          Text('d'),
                          Text('d'),
                          Text('d'),
                          Text('d'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(constraints.maxWidth, 50),
                        ),
                        onPressed: () async {
                          await controller.startGame();
                          _showDialog();
                        },
                        child: Text('Start Game'),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
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
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
