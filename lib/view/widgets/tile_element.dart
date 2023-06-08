import 'package:flutter/material.dart';
import 'package:wumpus_world/core/data/enums.dart' as E;
import 'package:wumpus_world/core/data/assets.dart';

import '../../model/board.dart';

class TileElement extends StatefulWidget {
  Tile tile;

  TileElement({
    super.key,
    required this.tile,
  });

  @override
  State<TileElement> createState() => _TileElementState();
}

class _TileElementState extends State<TileElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.tile.state.toSet().map(
          (E.State tile) {
            switch (tile) {
              case E.State.wumpus:
                return Flexible(child: Image.asset(Images.WUMPUS));
              case E.State.pitch:
                return Flexible(child: Image.asset(Images.PITCH));
              case E.State.glitter:
                return Flexible(child: Image.asset(Images.GLITTER));
              case E.State.gold:
                return Flexible(child: Image.asset(Images.GOLD));
              case E.State.stench:
                return Flexible(child: Image.asset(Images.STENCH));
              case E.State.breeze:
                return Flexible(child: Image.asset(Images.BREEZE));
              default:
                return const SizedBox();
            }
          },
        ).toList(),
      ),
    );
  }
}
