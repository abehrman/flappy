import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'olivia.dart';
import 'barrier.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -2.4; // strength of gravity
  double velocity = 2.5; // strength of jump

  bool gameHasStarted = false;

  double birdWidth = .1;
  double birdHeight = .1;

  // barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5; // out of 2
  List<List<double>> barrierHeight = [
    // out of 2, where 2 is the entire height of the screen
    // [topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6]
  ];

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 150), (timer) {
      // a real physical jump is an upside down parabola
      // so this is a simple quadratic equation
      // y = ut + 1/2at^2

      height = gravity * time * time + velocity * time;
      if (kDebugMode) {
        print("height: $height");
      }
      setState(() {
        birdY = initialPos - height;
        setBarriers();
      });

      if (kDebugMode) {
        print("height: $birdY");
      }

      // check if bird is dead
      if (birdIsDead()) {
        timer.cancel();
        gameHasStarted = false;
        _showDialog();
      }

      // keekp the time going
      time += 0.1;
    });
  }

  void setBarriers() {
    for (int i = 0; i < barrierX.length; i++) {
      barrierX[i] = barrierX[i] - .1;
      if (barrierX[0] < -1) {
        barrierX = [2, 2 + 1.5];
      }
    }
  }

  void resetGame() {
    Navigator.pop(context); // dismisses the alert dialog
    setState(() {
      birdY = 0;
      barrierX = [2, 2 + 1.5];
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.brown,
              title: Center(
                child: const Text(
                  "G A M E  O V E R",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: resetGame,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      padding: EdgeInsets.all(7),
                      color: Colors.white,
                      child: const Text(
                        "PLAY AGAIN",
                        style: TextStyle(color: Colors.brown),
                      ),
                    ),
                  ),
                )
              ]);
        });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  bool birdIsDead() {
    if (birdY < -1 || birdY > 1) {
      return true;
    }

    // // check if bird hits barrier
    // for (int i = 0; i < barrierX.length; i++) {
    //   if (barrierX[i] <= birdWidth &&
    //       barrierX[i] + barrierWidth >= -birdWidth &&
    //       (birdY <= -1 + barrierHeight[i][0] ||
    //           birdY + birdHeight >= 1 - barrierHeight[i][1])) {
    //     return true;
    //   }
    // }

    return false;
  }

  bool modifyBirdColor() {
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: gameHasStarted ? jump : startGame,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Homepage"),
          ),
          body: Column(
            children: [
              Expanded(
                  flex: 3,
                  child: Container(
                      color: Colors.blue,
                      child: Center(
                        child: Stack(
                          children: [
                            MyBird(
                                birdY: birdY,
                                birdWidth: birdWidth,
                                birdHeight: birdHeight,
                                modifyBirdColor: modifyBirdColor()),

                            // Top barrier 0
                            MyBarrier(
                              barrierX: barrierX[0],
                              barrierWidth: barrierWidth,
                              barrierHeight: barrierHeight[0][0],
                              isThisBottomBarrier: false,
                            ),

                            // Bottom barrier 0
                            MyBarrier(
                              barrierX: barrierX[0],
                              barrierWidth: barrierWidth,
                              barrierHeight: barrierHeight[0][1],
                              isThisBottomBarrier: true,
                            ),

                            Container(
                                alignment: Alignment(0, -0.5),
                                child: Text(
                                  gameHasStarted ? '' : 'T A P   T O   P L A Y',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                      ))),
              Expanded(
                child: Container(
                  color: Colors.brown,
                ),
              ),
            ],
          ),
        ));
  }
}
