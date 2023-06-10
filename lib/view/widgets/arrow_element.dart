import 'package:flutter/material.dart';
import 'package:wumpus_world/core/data/enums.dart';

import '../../model/agent.dart';

abstract class ArrowPainter extends CustomPainter {
  late Paint painter;
  late Agent agent;
  Color color = Colors.green;

  ArrowPainter(Agent agent) {
    if (agent.events.isNotEmpty && agent.events.last.$1 == Event.shoot) {
      color = Colors.amber;
    }

    painter = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }
}

class ArrowEastShape extends ArrowPainter {
  ArrowEastShape(super.agent);

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height / 2);
    path.close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ArrowWestShape extends ArrowPainter {
  ArrowWestShape(super.agent);

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height / 2);
    path.close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ArrowNorthShape extends ArrowPainter {
  ArrowNorthShape(super.agent);

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2, 0);
    path.close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ArrowSouthShape extends ArrowPainter {
  ArrowSouthShape(super.agent);

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
