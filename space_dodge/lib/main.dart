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

  bool collided = false;

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

    double ufoUpdate(double ufoPosition, double speed, double baseFactor) {
      var updateRandom = Random();
      if (ufoPosition - (heightBase * 18) < (widthBase + 1) &&
          ufoPosition - (heightBase * 18) > -(widthBase + 1) &&
          rocketPosition - (widthBase * baseFactor) < (widthBase + 1) &&
          rocketPosition - (widthBase * baseFactor) > -(widthBase + 1)) {
        ufoPosition = updateRandom.nextInt(500).toDouble() * -1;
        collided = true;
        return ufoPosition;
      } else if (ufoPosition < heightBase * 18) {
        ufoPosition += speed;
        return ufoPosition;
      } else {
        score += 1;
        ufoPosition = updateRandom.nextInt(500).toDouble() * -1;
        return ufoPosition;
      }
    }

    // defines a timer
    everySecond = Timer.periodic(Duration(milliseconds: 50), (Timer t) {
      ufoPosition1 = ufoUpdate(ufoPosition1, 5, 2);
      ufoPosition2 = ufoUpdate(ufoPosition2, 8, 4);
      ufoPosition3 = ufoUpdate(ufoPosition3, 7, 6);
      ufoPosition4 = ufoUpdate(ufoPosition4, 6, 8);
      ufoPosition5 = ufoUpdate(ufoPosition5, 8, 10);
      ufoPosition6 = ufoUpdate(ufoPosition6, 5, 12);
      ufoPosition7 = ufoUpdate(ufoPosition7, 6, 14);
      ufoPosition8 = ufoUpdate(ufoPosition8, 8, 16);
      ufoPosition9 = ufoUpdate(ufoPosition9, 6, 18);

      //Refresh the UI
      if (collided == true) {
        collided = false;
        print('Score zerod');
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

    Widget ufoWidget(double ufo, double leftFactor) {
      return Positioned(
        top: ufo,
        left: widthBase * leftFactor,
        child: SizedBox(
          height: widthBase * 2,
          width: widthBase * 2,
          child: Image.asset(
            'images/ufo.png',
            fit: BoxFit.cover,
          ),
        ),
      );
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
          ufoWidget(ufoPosition1, 2),
          ufoWidget(ufoPosition2, 4),
          ufoWidget(ufoPosition3, 6),
          ufoWidget(ufoPosition4, 8),
          ufoWidget(ufoPosition5, 10),
          ufoWidget(ufoPosition6, 12),
          ufoWidget(ufoPosition8, 14),
          ufoWidget(ufoPosition9, 16),
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
