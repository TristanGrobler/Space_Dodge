import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var random = Random();
  double rocketPosition = 400;
  late double ufoPosition1;
  late double ufoPosition2;
  late double ufoPosition3;
  late double ufoPosition4;
  late double ufoPosition5;
  late double ufoPosition6;
  late double ufoPosition7;
  late double ufoPosition8;

  late Timer everySecond;
  int score = 0;

  @override
  void initState() {
    super.initState();
    ufoPosition1 = (random.nextInt(400).toDouble() * -1) - 100;
    ufoPosition2 = (random.nextInt(400).toDouble() * -1) - 100;
    ufoPosition3 = (random.nextInt(400).toDouble() * -1) - 100;
    ufoPosition4 = (random.nextInt(400).toDouble() * -1) - 100;
    ufoPosition5 = (random.nextInt(400).toDouble() * -1) - 100;
    ufoPosition6 = (random.nextInt(400).toDouble() * -1) - 100;
    ufoPosition7 = (random.nextInt(400).toDouble() * -1) - 100;
    ufoPosition8 = (random.nextInt(400).toDouble() * -1) - 100;

    // defines a timer
    everySecond = Timer.periodic(const Duration(milliseconds: 50), (Timer t) {
      bool collided = false;
      //Update position of UFO 1
      if (ufoPosition1 - 900 < 51 &&
          ufoPosition1 - 900 > -51 &&
          rocketPosition - 100 < 51 &&
          rocketPosition - 100 > -51) {
        collided = true;
        ufoPosition1 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition1 < 1000) {
        ufoPosition1 += 5;
      } else {
        score += 1;
        ufoPosition1 = random.nextInt(500).toDouble() * -1;
      }
      //Update position of UFO 2
      if (ufoPosition2 - 900 < 51 &&
          ufoPosition2 - 900 > -51 &&
          rocketPosition - 200 < 51 &&
          rocketPosition - 200 > -51) {
        collided = true;
        ufoPosition2 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition2 < 1000) {
        ufoPosition2 += 8;
      } else {
        score += 1;
        ufoPosition2 = random.nextInt(500).toDouble() * -1;
      }
      //Update position of UFO 3
      if (ufoPosition3 - 900 < 51 &&
          ufoPosition3 - 900 > -51 &&
          rocketPosition - 300 < 51 &&
          rocketPosition - 300 > -51) {
        collided = true;
        ufoPosition3 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition3 < 1000) {
        ufoPosition3 += 9;
      } else {
        score += 1;
        ufoPosition3 = random.nextInt(500).toDouble() * -1;
      }
      //Update position of UFO 4
      if (ufoPosition4 - 900 < 51 &&
          ufoPosition4 - 900 > -51 &&
          rocketPosition - 400 < 51 &&
          rocketPosition - 400 > -51) {
        collided = true;
        ufoPosition4 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition4 < 1000) {
        ufoPosition4 += 6;
      } else {
        score += 1;
        ufoPosition4 = random.nextInt(500).toDouble() * -1;
      }
      //Update position of UFO 5
      if (ufoPosition5 - 900 < 51 &&
          ufoPosition5 - 900 > -51 &&
          rocketPosition - 500 < 51 &&
          rocketPosition - 500 > -51) {
        collided = true;
        ufoPosition5 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition5 < 1000) {
        ufoPosition5 += 8;
      } else {
        score += 1;
        ufoPosition5 = random.nextInt(500).toDouble() * -1;
      }
      //Update position of UFO 6
      if (ufoPosition6 - 900 < 51 &&
          ufoPosition6 - 900 > -51 &&
          rocketPosition - 600 < 51 &&
          rocketPosition - 600 > -51) {
        collided = true;
        ufoPosition6 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition6 < 1000) {
        ufoPosition6 += 5;
      } else {
        score += 1;
        ufoPosition6 = random.nextInt(500).toDouble() * -1;
      }
      //Update position of UFO 7
      if (ufoPosition7 - 900 < 51 &&
          ufoPosition7 - 900 > -51 &&
          rocketPosition - 700 < 51 &&
          rocketPosition - 700 > -51) {
        collided = true;
        ufoPosition7 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition7 < 1000) {
        ufoPosition7 += 6;
      } else {
        score += 1;
        ufoPosition7 = random.nextInt(500).toDouble() * -1;
      }
      //Update position of UFO 8
      if (ufoPosition8 - 900 < 51 &&
          ufoPosition8 - 900 > -51 &&
          rocketPosition - 800 < 51 &&
          rocketPosition - 800 > -51) {
        collided = true;
        ufoPosition8 = random.nextInt(500).toDouble() * -1;
      } else if (ufoPosition8 < 1000) {
        ufoPosition8 += 5;
      } else {
        score += 1;
        ufoPosition8 = random.nextInt(500).toDouble() * -1;
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
      if (rocketPosition > 50) {
        rocketPosition -= 50;
      }
      setState(() {});
    }

    moveRight() {
      if (rocketPosition < 750) {
        rocketPosition += 50;
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
            top: 900,
            left: rocketPosition,
            child: SizedBox(
              height: 100.0,
              width: 100.0,
              child: Image.asset(
                'images/rocket.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: ufoPosition1,
            left: 100,
            child: SizedBox(
              height: 100.0,
              width: 100.0,
              child: Image.asset(
                'images/ufo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: ufoPosition2,
            left: 200,
            child: SizedBox(
              height: 100.0,
              width: 100.0,
              child: Image.asset(
                'images/ufo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: ufoPosition3,
            left: 300,
            child: SizedBox(
              height: 100.0,
              width: 100.0,
              child: Image.asset(
                'images/ufo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: ufoPosition4,
            left: 400,
            child: SizedBox(
              height: 100.0,
              width: 100.0,
              child: Image.asset(
                'images/ufo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: ufoPosition5,
            left: 500,
            child: SizedBox(
              height: 100.0,
              width: 100.0,
              child: Image.asset(
                'images/ufo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: ufoPosition6,
            left: 600,
            child: SizedBox(
              height: 100.0,
              width: 100.0,
              child: Image.asset(
                'images/ufo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: ufoPosition7,
            left: 700,
            child: SizedBox(
              height: 100.0,
              width: 100.0,
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
