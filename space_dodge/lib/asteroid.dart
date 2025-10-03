import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:space_dodge/constants.dart';
import 'dart:math';

class Asteroid extends StatefulWidget {
  final double xPosition;
  final double yPosition;
  final int type;
  final double speed; // Changed to double for more precision
  final double baseFactor;
  final double velocityX; // Added horizontal velocity
  final double velocityY; // Added vertical velocity

  Asteroid({
    Key? key,
    required this.xPosition,
    required this.yPosition,
    required this.type,
    required this.speed,
    required this.baseFactor,
    this.velocityX = 0.0,
    this.velocityY = 0.0,
  }) : super(key: key) {
    _ufoXPositionController.sink.add(xPosition);
    _ufoYPositionController.sink.add(yPosition);
    _ufoTypeController.sink.add(type);
    _ufoSpeedController.sink.add(speed);
    _ufoVelocityXController.sink.add(velocityX);
    _ufoVelocityYController.sink.add(velocityY);
  }

  final _ufoXPositionController = BehaviorSubject<double>();
  final _ufoYPositionController = BehaviorSubject<double>();
  final _ufoTypeController = BehaviorSubject<int>();
  final _ufoSpeedController = BehaviorSubject<double>(); // Changed to double
  final _ufoVelocityXController = BehaviorSubject<double>();
  final _ufoVelocityYController = BehaviorSubject<double>();

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
  void setSpeed(double s) {
    _ufoSpeedController.sink.add(s);
  }

  ///Update the horizontal velocity of the asteroid
  void setVelocityX(double vx) {
    _ufoVelocityXController.sink.add(vx);
  }

  ///Update the vertical velocity of the asteroid
  void setVelocityY(double vy) {
    _ufoVelocityYController.sink.add(vy);
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
  double getSpeed() {
    return _ufoSpeedController.value;
  }

  ///Get the horizontal velocity of the asteroid.
  double getVelocityX() {
    return _ufoVelocityXController.value;
  }

  ///Get the vertical velocity of the asteroid.
  double getVelocityY() {
    return _ufoVelocityYController.value;
  }

  ///Get the collision radius of the asteroid based on its type
  double getCollisionRadius() {
    double baseRadius = baseFactor / 2;
    switch (type) {
      case 0: // UFO
        return baseRadius * 0.7 * GamePhysics.asteroidSize;
      case 1: // Asteroid 1
        return baseRadius * 0.8 * GamePhysics.asteroidSize;
      case 2: // Asteroid 2
        return baseRadius * 0.75 * GamePhysics.asteroidSize;
      default:
        return baseRadius * 0.7 * GamePhysics.asteroidSize;
    }
  }

  ///Get center x position for collision detection
  double getCenterX() {
    return getXPosition() + baseFactor / 2;
  }

  ///Get center y position for collision detection
  double getCenterY() {
    return getYPosition() + baseFactor / 2;
  }

  ///Update physics for this asteroid with performance optimizations
  void updatePhysics() {
    double currentVY = getVelocityY();
    double currentVX = getVelocityX();

    // Apply gravity/acceleration
    currentVY += GamePhysics.asteroidAcceleration;

    // Apply some random horizontal drift for more interesting movement (less frequent for performance)
    if (Random().nextDouble() < 0.005) {
      // 0.5% chance per frame (reduced from 1%)
      currentVX += (Random().nextDouble() - 0.5) * 0.5;
      currentVX = PhysicsUtils.clamp(currentVX, -2.0, 2.0);
    }

    // Update velocities
    setVelocityY(currentVY);
    setVelocityX(currentVX);

    // Update positions
    setXPosition(getXPosition() + currentVX);
    setYPosition(getYPosition() + currentVY);
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
                duration: Duration(milliseconds: GamePhysics.gameTickRate),
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
      },
    );
  }
}
