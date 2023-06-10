import 'package:flutter/material.dart';
import 'package:wumpus_world/core/data/enums.dart' as e;
import 'package:wumpus_world/core/data/assets.dart';

import '../../model/board.dart';

class TileElement extends StatefulWidget {
  final Tile tile;
  bool shadow;

  TileElement({
    super.key,
    required this.tile,
    this.shadow = false,
  });

  @override
  State<TileElement> createState() => _TileElementState();
}

class _TileElementState extends State<TileElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.shadow
          ? widget.tile.danger.contains(e.Danger.safe) ||
                  widget.tile.danger.contains(e.Danger.gold)
              ? null
              : Color.fromARGB(108, 0, 0, 0)
          : Color.fromARGB(255, 146, 124, 72),
      child: widget.shadow
          ? SizedBox()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.tile.state.toSet().map(
                (e.State tile) {
                  switch (tile) {
                    case e.State.wumpus:
                      return Flexible(child: Image.asset(Images.WUMPUS));
                    case e.State.pitch:
                      return Flexible(child: Image.asset(Images.PITCH));
                    case e.State.glitter:
                      return Flexible(child: Image.asset(Images.GLITTER));
                    case e.State.gold:
                      return Flexible(child: Image.asset(Images.GOLD));
                    case e.State.stench:
                      return Flexible(child: Image.asset(Images.STENCH));
                    case e.State.breeze:
                      return Flexible(child: Image.asset(Images.BREEZE));
                    default:
                      return SizedBox();
                  }
                },
              ).toList(),
            ),
    );
  }
}
