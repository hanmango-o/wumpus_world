import 'package:flutter/material.dart';
import 'package:wumpus_world/core/data/assets.dart';
import 'package:wumpus_world/core/data/enums.dart';
import 'package:wumpus_world/view/widgets/arrow_element.dart';

import '../../model/agent.dart';

class AgentElement extends StatelessWidget {
  final Agent agent;

  const AgentElement({super.key, required this.agent});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Visibility(
                visible: agent.dir == Direction.north,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: CustomPaint(
                    size: Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    ),
                    painter: ArrowNorthShape(agent),
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
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: CustomPaint(
                          size: Size(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          ),
                          painter: ArrowWestShape(agent),
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
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: CustomPaint(
                          size: Size(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          ),
                          painter: ArrowEastShape(agent),
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
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: CustomPaint(
                    size: Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    ),
                    painter: ArrowSouthShape(agent),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
