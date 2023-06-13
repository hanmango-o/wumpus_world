/// 각 Area가 가지는 상태를 의미한다.
///
/// 상태는 [List]형태로 관리되며, 중복될 수 있다.
/// Original map이 생성될 때, 각 Area의 State가 정해지며
/// 한번 정해진 State는 몇몇 경우를 제외하고 변경되지 않는다.
///
/// 아래는 State가 변경되는 경우이다.
///
/// - 화살을 통해 [wumpus]를 죽일 경우
///   : [wumpus]와 그 주변 [stench]가 제거된다.
///
/// - [gold]를 획득한 경우
///   : [gold]와 그 주변 [glitter]가 제거된다.
///
/// **See also :**
///
///   - Agent는 [Danger]를 통한 추론을 통해 State값을 파악한다.
///   - [wumpus]의 경우 ~~ 로직을 통해 화살로 죽일 수 있는 경우를 알 수 있다.
enum State {
  /// 안전한 땅이라는 의미이다.
  ///
  /// 아무것도 존재하지 않는 땅을 의미한다.
  safe,

  /// 괴물이 있는 땅을 의미한다.
  wumpus,

  /// 괴물이 풍기는 냄새를 의미한다.
  ///
  /// [wumpus]가 존재하는 땅의 상하좌우에 존재한다.
  stench,

  /// 웅덩이가 있는 땅을 의미한다.
  pitch,

  /// 웅덩이에서 불어오는 바람을 의미한다.
  ///
  /// [pitch]가 존재하는 땅의 상하좌우에 존재한다.
  breeze,

  /// 황금이 있는 땅을 의미한다.
  gold,

  /// 황금에서 나오는 빛을 의미한다.
  ///
  /// [gold]가 존재하는 땅의 상하좌우에 존재한다.
  // glitter,
}

/// Agent가 바라보는 방향을 의미한다.
enum Direction {
  north,
  south,
  west,
  east,
}

/// 땅의 위험도를 의미한다.
///
/// 각 땅은 고유의 Danger를 가진다.
enum Danger {
  /// 안전한 땅이라는 의미이다.
  ///
  /// [State.safe] 상태의 땅이 가지는 위험도이다.
  safe,

  /// 바람
  pitch,

  /// 냄새
  wumpus,

  gold,

  /// 아직 방문하지 않은 땅을 의미한다.
  ///
  /// [State]
  unKnown,
}

enum Event {
  move,
  shoot,
  scream,
  gold,
  death,
}
