import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  final birdY;
  final double birdWidth;
  final double birdHeight;
  final bool modifyBirdColor;

  MyBird(
      {this.birdY,
      required this.birdWidth,
      required this.birdHeight,
      required this.modifyBirdColor});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("y: $birdY");
    }
    return Container(
        alignment: Alignment(0, (2 * birdY + birdHeight) / (2 - birdHeight)),
        child: Image.asset('lib/images/olivia_ski.png',
            width: MediaQuery.of(context).size.width * birdWidth / 2,
            height: MediaQuery.of(context).size.height * 3 / 4 * birdHeight / 2,
            fit: BoxFit.fill,
            color: Colors.red,
            colorBlendMode:
                modifyBirdColor ? BlendMode.modulate : BlendMode.dst));
  }
}
