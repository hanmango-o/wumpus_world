import 'package:flutter/material.dart';
import 'package:wumpus_world/controller/controller.dart';
import 'package:wumpus_world/core/data/assets.dart';
import 'package:wumpus_world/core/data/enums.dart' as e;
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
  late Controller game;
  List<Agent> history = [];
  bool playing = false;

  @override
  void initState() {
    game = GameController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wumpus World'),
        centerTitle: false,
        backgroundColor: Color.fromARGB(255, 75, 43, 220),
        // foregroundColor: Color.fromARGB(215, 135, 124, 75),
      ),
      body: Row(
        children: [
          Flexible(
            flex: 3,
            child: Container(
              height: double.infinity,
              // color: Color.fromARGB(255, 0, 0, 0),
              color: Color.fromARGB(255, 255, 255, 255),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: constraints.maxHeight,
                        width: constraints.maxHeight,
                        child: Stack(
                          children: [
                            StreamBuilder<Board>(
                              stream: game.mapStream.stream,
                              initialData: game.map,
                              builder: (context, snapshot) {
                                return GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
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
                              stream: game.agentStream.stream,
                              initialData: game.agent,
                              builder: (context, snapshot) {
                                return GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  children: snapshot.data!.board.tiles
                                      .expand((List<Tile> row) => row)
                                      .toList()
                                      .map((tile) {
                                    return TileElement(
                                      tile: tile,
                                      shadow: true,
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                            StreamBuilder<Agent>(
                              stream: game.agentStream.stream,
                              initialData: game.agent,
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
              // color: Color.fromARGB(255, 0, 0, 0),
              height: double.infinity,
              child: StreamBuilder(
                  stream: game.agentStream.stream,
                  initialData: game.agent,
                  builder: (context, snapshot) {
                    return LayoutBuilder(builder: (context, constraints) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: constraints.maxHeight / 100,
                              ),
                              Container(
                                color: Colors.grey[300],
                                height: constraints.maxHeight * 0.21,
                                child: Image.asset(
                                  Images.AGENT,
                                  width: constraints.maxWidth / 2.5,
                                  height: constraints.maxHeight / 4,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: constraints.maxHeight / 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: constraints.maxHeight / 10,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              color: Colors.grey[300],
                                              padding: EdgeInsets.all(8),
                                              width: constraints.maxHeight / 10,
                                              height:
                                                  constraints.maxHeight / 10,
                                              child: snapshot.data!.arrow > 0
                                                  ? Image.asset(Images.ARROW)
                                                  : Icon(
                                                      Icons.close,
                                                      color: Colors.grey,
                                                      size: constraints
                                                              .maxHeight /
                                                          25,
                                                    ),
                                            ),
                                            SizedBox(
                                              width:
                                                  constraints.maxHeight / 100,
                                            ),
                                            Container(
                                              color: Colors.grey[300],
                                              padding: EdgeInsets.all(8),
                                              width: constraints.maxHeight / 10,
                                              height:
                                                  constraints.maxHeight / 10,
                                              child: snapshot.data!.arrow > 1
                                                  ? Image.asset(Images.ARROW)
                                                  : Icon(
                                                      Icons.close,
                                                      color: Colors.grey,
                                                      size: constraints
                                                              .maxHeight /
                                                          25,
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight / 100,
                                      ),
                                      Container(
                                        height: constraints.maxHeight / 10,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              color: Colors.grey[300],
                                              padding: EdgeInsets.all(8),
                                              width: constraints.maxHeight / 5 +
                                                  10,
                                              height:
                                                  constraints.maxHeight / 10,
                                              child: snapshot.data!.hasGold
                                                  ? Image.asset(Images.GOLD)
                                                  : Icon(
                                                      Icons.close,
                                                      color: Colors.grey,
                                                      size: constraints
                                                              .maxHeight /
                                                          20,
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Divider(),
                          Expanded(
                            child: ListView(
                              children:
                                  snapshot.data!.events.reversed.map((event) {
                                switch (event.$1) {
                                  case e.Event.move:
                                    return Card(
                                      child: ListTile(
                                        leading: Icon(Icons.directions_walk),
                                        title: Text('Move to ${event.$2}'),
                                      ),
                                    );
                                  case e.Event.scream:
                                    return Card(
                                      child: ListTile(
                                        leading:
                                            Icon(Icons.noise_aware_rounded),
                                        title: Text(
                                            'Wumpus\'s scream in ${event.$2}'),
                                      ),
                                    );
                                  case e.Event.shoot:
                                    return Card(
                                      child: ListTile(
                                        leading:
                                            Icon(Icons.double_arrow_outlined),
                                        title: Text(
                                            'Shoot the arrow to ${event.$2}'),
                                      ),
                                    );
                                  case e.Event.gold:
                                    return Card(
                                      child: ListTile(
                                        leading:
                                            Icon(Icons.check_circle_outline),
                                        title:
                                            Text('Find Gold in ${event.$2})'),
                                      ),
                                    );
                                  case e.Event.death:
                                    return Card(
                                      child: ListTile(
                                        leading:
                                            Icon(Icons.check_circle_outline),
                                        title: Text('Death in ${event.$2})'),
                                      ),
                                    );
                                  default:
                                    return Card(
                                      child: ListTile(
                                        leading: Icon(Icons.directions_walk),
                                        title: Text('${event.$2}'),
                                      ),
                                    );
                                }
                              }).toList(),
                            ),
                          ),
                          Visibility(
                            visible: !playing,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OutlinedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(constraints.maxWidth, 50),
                                  foregroundColor:
                                      Color.fromARGB(255, 75, 43, 220),
                                ),
                                onPressed: () {
                                  setState(() {
                                    game.reset();
                                  });
                                },
                                child: const Text('Refresh'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 75, 43, 220),
                                fixedSize: Size(constraints.maxWidth, 50),
                              ),
                              onPressed: () async {
                                try {
                                  setState(() {
                                    playing = true;
                                  });
                                  await game.start();
                                  // controller.agent.board.tiles
                                  // log(controller.agent.board.toString());
                                  setState(() {
                                    playing = false;
                                  });
                                  _showDialog();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Error!! Plz retry game.'),
                                    ),
                                  );
                                  _showDialog();
                                }
                              },
                              child: playing
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text('Start Game'),
                            ),
                          ),
                        ],
                      );
                    });
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDialog() async {
    if (game.agent.giveUp) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Discovery failed'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('A map of shapes that the Agent cannot navigate.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 75, 43, 220),
                ),
                child: const Text('One more round'),
                onPressed: () {
                  setState(() {
                    game.reset();
                  });

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('I got a gold!!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Agent successfully has gold in wumpus world.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Color.fromARGB(255, 75, 43, 220),
              ),
              child: const Text('One more round'),
              onPressed: () {
                setState(() {
                  game.reset();
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
