import 'package:flutter/material.dart';
import 'package:wumpus_world/core/data/assets.dart';
import 'package:wumpus_world/core/data/enums.dart';
import 'package:wumpus_world/view/widgets/arrow_element.dart';

import '../../model/agent.dart';

class AgentElement extends StatelessWidget {
  Agent agent;

  AgentElement({super.key, required this.agent});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.green,
      child: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Visibility(
                  visible: agent.dir == Direction.north,
                  child: Container(
                    width: constraints.maxWidth,
                    child: CustomPaint(
                      size: Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      ),
                      painter: ArrowNorthShape(),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Visibility(
                        visible: agent.dir == Direction.west,
                        child: Container(
                          height: constraints.maxHeight,
                          child: CustomPaint(
                            size: Size(
                              constraints.maxWidth,
                              constraints.maxHeight,
                            ),
                            painter: ArrowWestShape(),
                          ),
                        ),
                      ),
                    ),
                    Image.asset(
                      Images.AGENT,
                      height: constraints.maxHeight,
                    ),
                    Flexible(
                      flex: 2,
                      child: Visibility(
                        visible: agent.dir == Direction.east,
                        child: Container(
                          height: constraints.maxHeight,
                          child: CustomPaint(
                            size: Size(
                              constraints.maxWidth,
                              constraints.maxHeight,
                            ),
                            painter: ArrowEastShape(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Visibility(
                  visible: agent.dir == Direction.south,
                  child: Container(
                    height: constraints.maxHeight,
                    child: CustomPaint(
                      size: Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      ),
                      painter: ArrowSouthShape(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
