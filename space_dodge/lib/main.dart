import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: LayoutBuilder(builder: (context, BoxConstraints constraints) {
      return MyApp(
        height: constraints.maxHeight - 100,
        width: constraints.maxWidth,
      );
    }),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({required this.height, required this.width});
  final double height;
  final double width;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var random = Random();
  late double rocketPosition;
  late double ufoPosition1;
  late double ufoPosition2;
  late double ufoPosition3;
  late double ufoPosition4;
  late double ufoPosition5;
  late double ufoPosition6;
  late double ufoPosition7;
  late double ufoPosition8;
  late double ufoPosition9;

  late double widthBase;
  late double heightBase;

  late Timer everySecond;
  int score = 0;

  @override
  void initState() {
    super.initState();
    widthBase = widget.width / 20;
    heightBase = widget.height / 20;
    rocketPosition = widget.width / 2;
    ufoPosition1 = (random.nextInt(400).toDouble() * -1) - 100;
    ufoPosition2 = (random.nextInt(400).toDouble() * -1) - 100;
    ufoPosition3 = (random.nextInt(400).toDouble() * -1) - 100;
    ufoPosition4 = (random.nextInt(400).toDouble() * -1) - 100;
    ufoPosition5 = (random.nextInt(400).toDouble() * -1) - 100;
    ufoPosition6 = (random.nextInt(400).toDouble() * -1) - 100;
    ufoPosition7 = (random.nextInt(400).toDouble() * -1) - 100;
    ufoPosition8 = (random.nextInt(400).toDouble() * -1) - 100;
    ufoPosition9 = (random.nextInt(400).toDouble() * -1) - 100;

    // defines a timer
    everySecond = Timer.periodic(Duration(milliseconds: 50), (Timer t) {
      bool collided = false;
      //Update position of UFO 1
      if (ufoPosition1 - (heightBase * 18) < (widthBase + 1) &&
          ufoPosition1 - (heightBase * 18) > -(widthBase + 1) &&
          rocketPosition - (widthBase * 2) < (widthBase + 1) &&
          rocketPosition - (widthBase * 2) > -(widthBase + 1)) {
        collided = true;
        ufoPosition1 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition1 < heightBase * 18) {
        ufoPosition1 += 5;
      } else {
        score += 1;
        ufoPosition1 = random.nextInt(500).toDouble() * -1;
      }
      //Update position of UFO 2
      if (ufoPosition2 - (heightBase * 18) < (widthBase + 1) &&
          ufoPosition2 - (heightBase * 18) > -(widthBase + 1) &&
          rocketPosition - (widthBase * 4) < (widthBase + 1) &&
          rocketPosition - (widthBase * 4) > -(widthBase + 1)) {
        collided = true;
        ufoPosition2 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition2 < 18 * heightBase) {
        ufoPosition2 += 8;
      } else {
        score += 1;

        ufoPosition2 = random.nextInt(500).toDouble() * -1;
      }
      //Update position of UFO 3
      if (ufoPosition3 - (heightBase * 18) < (widthBase + 1) &&
          ufoPosition3 - (heightBase * 18) > -(widthBase + 1) &&
          rocketPosition - (widthBase * 4) < (widthBase + 1) &&
          rocketPosition - (widthBase * 4) > -(widthBase + 1)) {
        collided = true;
        ufoPosition3 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition3 < 18 * heightBase) {
        ufoPosition3 += 9;
      } else {
        score += 1;

        ufoPosition3 = random.nextInt(500).toDouble() * -1;
      }
      //Update position of UFO 4
      if (ufoPosition4 - (heightBase * 18) < (widthBase + 1) &&
          ufoPosition4 - (heightBase * 18) > -(widthBase + 1) &&
          rocketPosition - (widthBase * 8) < (widthBase + 1) &&
          rocketPosition - (widthBase * 8) > -(widthBase + 1)) {
        collided = true;
        ufoPosition4 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition4 < 1000) {
        ufoPosition4 += 6;
      } else {
        score += 1;

        ufoPosition4 = random.nextInt(500).toDouble() * -1;
      }
      //Update position of UFO 5
      if (ufoPosition5 - (heightBase * 18) < (widthBase + 1) &&
          ufoPosition5 - (heightBase * 18) > -(widthBase + 1) &&
          rocketPosition - (widthBase * 10) < (widthBase + 1) &&
          rocketPosition - (widthBase * 10) > -(widthBase + 1)) {
        collided = true;
        ufoPosition5 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition5 < 18 * heightBase) {
        ufoPosition5 += 8;
      } else {
        score += 1;

        ufoPosition5 = random.nextInt(500).toDouble() * -1;
      }
      //Update position of UFO 6
      if (ufoPosition6 - (heightBase * 18) < (widthBase + 1) &&
          ufoPosition6 - (heightBase * 18) > -(widthBase + 1) &&
          rocketPosition - (widthBase * 12) < (widthBase + 1) &&
          rocketPosition - (widthBase * 12) > -(widthBase + 1)) {
        collided = true;
        ufoPosition6 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition6 < 18 * heightBase) {
        ufoPosition6 += 5;
      } else {
        score += 1;

        ufoPosition6 = random.nextInt(500).toDouble() * -1;
      }
      //Update position of UFO 7
      if (ufoPosition7 - (heightBase * 18) < (widthBase + 1) &&
          ufoPosition7 - (heightBase * 18) > -(widthBase + 1) &&
          rocketPosition - (widthBase * 14) < (widthBase + 1) &&
          rocketPosition - (widthBase * 14) > -(widthBase + 1)) {
        collided = true;
        ufoPosition7 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition7 < 18 * heightBase) {
        ufoPosition7 += 6;
      } else {
        score += 1;

        ufoPosition7 = random.nextInt(500).toDouble() * -1;
      }
      //Update position of UFO 8
      if (ufoPosition8 - (heightBase * 18) < (widthBase + 1) &&
          ufoPosition8 - (heightBase * 18) > -(widthBase + 1) &&
          rocketPosition - (widthBase * 16) < (widthBase + 1) &&
          rocketPosition - (widthBase * 16) > -(widthBase + 1)) {
        collided = true;
        ufoPosition8 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition8 < 18 * heightBase) {
        ufoPosition8 += 5;
      } else {
        score += 1;

        ufoPosition8 = random.nextInt(500).toDouble() * -1;
      }
      //Update position of UFO 9
      if (ufoPosition9 - (heightBase * 18) < (widthBase + 1) &&
          ufoPosition9 - (heightBase * 18) > -(widthBase + 1) &&
          rocketPosition - (widthBase * 18) < (widthBase + 1) &&
          rocketPosition - (widthBase * 18) > -(widthBase + 1)) {
        collided = true;
        ufoPosition9 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition9 < 18 * heightBase) {
        ufoPosition9 += 5;
      } else {
        score += 1;

        ufoPosition9 = random.nextInt(500).toDouble() * -1;
      }
      //Refresh the UI
      if (collided == true) {
        score = 0;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    moveLeft() {
      if (rocketPosition > widthBase * 2) {
        rocketPosition -= widthBase;
      }
      setState(() {});
    }

    moveRight() {
      if (rocketPosition < widthBase * 18) {
        rocketPosition += widthBase;
      }
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Space Dodge'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'images/space background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 30.0,
            bottom: 30.0,
            child: GestureDetector(
              onTap: moveLeft,
              child: Container(
                color: Colors.white30,
                child: Icon(
                  Icons.chevron_left,
                  size: 50.0,
                ),
              ),
            ),
          ),
          Positioned(
            right: 30.0,
            bottom: 30.0,
            child: GestureDetector(
              onTap: moveRight,
              child: Container(
                color: Colors.white30,
                child: Icon(
                  Icons.chevron_right,
                  size: 50.0,
                ),
              ),
            ),
          ),
          Positioned(
            top: heightBase * 18,
            left: rocketPosition,
            child: SizedBox(
              height: widthBase * 2,
              width: widthBase * 2,
              child: Image.asset(
                'images/rocket.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: ufoPosition1,
            left: widthBase * 2,
            child: SizedBox(
              height: widthBase * 2,
              width: widthBase * 2,
              child: Image.asset(
                'images/ufo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: ufoPosition2,
            left: widthBase * 4,
            child: SizedBox(
              height: widthBase * 2,
              width: widthBase * 2,
              child: Image.asset(
                'images/ufo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: ufoPosition3,
            left: widthBase * 6,
            child: SizedBox(
              height: widthBase * 2,
              width: widthBase * 2,
              child: Image.asset(
                'images/ufo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: ufoPosition4,
            left: widthBase * 8,
            child: SizedBox(
              height: widthBase * 2,
              width: widthBase * 2,
              child: Image.asset(
                'images/ufo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: ufoPosition5,
            left: widthBase * 10,
            child: SizedBox(
              height: widthBase * 2,
              width: widthBase * 2,
              child: Image.asset(
                'images/ufo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: ufoPosition6,
            left: widthBase * 12,
            child: SizedBox(
              height: widthBase * 2,
              width: widthBase * 2,
              child: Image.asset(
                'images/ufo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: ufoPosition7,
            left: widthBase * 14,
            child: SizedBox(
              height: widthBase * 2,
              width: widthBase * 2,
              child: Image.asset(
                'images/ufo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: ufoPosition8,
            left: widthBase * 16,
            child: SizedBox(
              height: widthBase * 2,
              width: widthBase * 2,
              child: Image.asset(
                'images/ufo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: ufoPosition9,
            left: widthBase * 18,
            child: SizedBox(
              height: widthBase * 2,
              width: widthBase * 2,
              child: Image.asset(
                'images/ufo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Score: $score',
                style: TextStyle(color: Colors.white60),
              ),
            ),
          )
        ],
      ),
    );
  }
}
