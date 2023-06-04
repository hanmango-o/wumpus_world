import 'dart:math';

import '../core/data/enums.dart';
import '../model/map.dart';

class Agent {
  Point position;
  Direction direction;
  bool hasGold = false;
  bool death = false;
  int arrow = 2;
  Map map = Map();

  Agent({
    this.direction = Direction.east,
    this.position = const Point(0, 0),
  });

  void shoot() {
    // 활쏘는 로직 함수 호출
    arrow--;
  }

  void search() {}
}
