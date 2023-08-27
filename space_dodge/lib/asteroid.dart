import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class Asteroid extends StatefulWidget {
  final double xPosition;
  final double yPosition;
  final int type;
  final int speed;
  final double baseFactor;

  Asteroid({
    Key? key,
    required this.xPosition,
    required this.yPosition,
    required this.type,
    required this.speed,
    required this.baseFactor,
  }) : super(key: key) {
    _ufoXPositionController.sink.add(xPosition);
    _ufoYPositionController.sink.add(yPosition);
    _ufoTypeController.sink.add(type);
    _ufoSpeedController.sink.add(speed);
  }

  final _ufoXPositionController = BehaviorSubject<double>();
  final _ufoYPositionController = BehaviorSubject<double>();
  final _ufoTypeController = BehaviorSubject<int>();
  final _ufoSpeedController = BehaviorSubject<int>();

  Stream<List> get ufoData =>
      Rx.combineLatest3(ufoXPosition, ufoYPosition, ufoType, (x, y, t) {
        return [x, y, t];
      });

  Stream<double> get ufoXPosition => _ufoXPositionController.stream;
  Stream<double> get ufoYPosition => _ufoYPositionController.stream;
  Stream<int> get ufoType => _ufoTypeController.stream;

  ///Update the x position of the asteroid.
  void setXPosition(double x) {
    _ufoXPositionController.sink.add(x);
  }

  ///Update the y position of the asteroid.
  void setYPosition(double y) {
    _ufoYPositionController.sink.add(y);
  }

  ///Update the type of the asteroid.
  /// 0 == ufo
  /// 1 == asteroid_1
  /// 2 == asteroid_2
  void setType(int t) {
    _ufoTypeController.sink.add(t);
  }

  ///Update the speed factor of the asteroid
  void setSpeed(int s) {
    _ufoSpeedController.sink.add(s);
  }

  ///Get value of X position.
  double getXPosition() {
    return _ufoXPositionController.value;
  }

  ///Get value of Y position.
  double getYPosition() {
    return _ufoYPositionController.value;
  }

  ///Get the speed of the asteroid.
  int getSpeed() {
    return _ufoSpeedController.value;
  }

  @override
  State<Asteroid> createState() => _AsteroidState();
}

class _AsteroidState extends State<Asteroid> {
  ///Get image needed for asteroid.
  String getImageResource(int t) {
    switch (t) {
      case 0:
        return 'assets/images/ufo.png';
      case 1:
        return 'assets/images/asteroid_1.png';
      case 2:
        return 'assets/images/asteroid_2.png';
      default:
        return 'assets/images/ufo.png';
    }
  }

  /// Return widget of asteroid.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List>(
        stream: widget.ufoData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data![1] > 0
                ? AnimatedPositioned(
                    top: snapshot.data![1],
                    left: snapshot.data![0],
                    duration: const Duration(milliseconds: 50),
                    child: SizedBox(
                      height: widget.baseFactor,
                      width: widget.baseFactor,
                      child: Image.asset(
                        getImageResource(snapshot.data![2]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container();
          } else {
            return Container();
          }
        });
  }
}
