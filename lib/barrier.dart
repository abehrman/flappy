import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final barrierWidth;
  final barrierHeight;
  final barrierX;
  final bool isThisBottomBarrier;

  MyBarrier(
      {this.barrierHeight,
      this.barrierWidth,
      required this.isThisBottomBarrier,
      this.barrierX});

  @override
  Widget build(BuildContext context) {
    double xalign = (2 * barrierX + barrierWidth) / (2 - barrierWidth);

    if (kDebugMode) {
      print("xalign: $xalign");
    }

    return Container(
      alignment: Alignment(xalign, isThisBottomBarrier ? 1 : -1),
      child: Container(
          color: Colors.green,
          width: MediaQuery.of(context).size.width * barrierWidth / 2,
          height:
              MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2),
    );
  }
}
