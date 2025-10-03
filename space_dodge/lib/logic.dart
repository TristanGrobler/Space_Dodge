import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:space_dodge/asteroid.dart';
import 'package:space_dodge/prefs.dart';
import 'package:space_dodge/screens/game_over_dialog.dart';
import 'package:space_dodge/constants.dart';

class Logic {
  final double width;
  final double height;
  final BuildContext context;

  Logic({required this.width, required this.height, required this.context}) {
    updateWidthAndBaseFactor(width, height);
    startGame();
  }

  //Declare variables for Game Logic.
  final _random = Random();
  late double _widthBase;
  late double _heightBase;
  late Timer _timer;
  bool collided = false;
  int baseTime = GamePhysics.gameTickRate; // Use physics constant

  // Enhanced physics variables
  double _rocketVelocityX = 0.0;
  bool _rocketMovingLeft = false;
  bool _rocketMovingRight = false;
  double _windForce = 0.0; // Dynamic wind for gameplay variety

  // Animation variables
  double _animationTime = 0.0; // For hover animation
  double _rocketTilt = 0.0; // Current tilt angle

  //Declare controllers
  final _rocketPositionController = BehaviorSubject<double>();
  final _scoreController = BehaviorSubject<int>();
  final _highScoreController = BehaviorSubject<int>();
  final _levelController = BehaviorSubject<int>();
  final _asteroidsController = BehaviorSubject<List<Asteroid>>();
  final _musicPlayer = AudioPlayer();

  // Animation controllers
  final _rocketHoverController = BehaviorSubject<double>();
  final _rocketTiltController = BehaviorSubject<double>();

  //Methods to retrieve stream values
  Stream<double> get rocketPosition => _rocketPositionController.stream;
  Stream<int> get score => _scoreController.stream;
  Stream<int> get highScore => _highScoreController.stream;
  Stream<int> get level => _levelController.stream;
  Stream<List<Asteroid>> get asteroids => _asteroidsController.stream;

  // Animation streams
  Stream<double> get rocketHover => _rocketHoverController.stream;
  Stream<double> get rocketTilt => _rocketTiltController.stream;

  ///Start the game.
  startGame() {
    _highScoreController.sink.add(Prefs.highScore);
    double startPosition = width / 2 - _widthBase;
    _rocketPositionController.sink.add(startPosition);
    _scoreController.sink.add(0);
    _levelController.sink.add(0);

    // Reset physics
    _rocketVelocityX = 0.0;
    _rocketMovingLeft = false;
    _rocketMovingRight = false;

    // Initialize animation values
    _animationTime = 0.0;
    _rocketTilt = 0.0;
    _rocketHoverController.sink.add(0.0);
    _rocketTiltController.sink.add(0.0);

    List<Asteroid> _startList = [];
    for (var i = 0; i < 8; i++) {
      _startList.add(
        Asteroid(
          xPosition: _widthBase * (i + 1) * 2,
          yPosition: getUFOStartPosition(),
          type: _random.nextInt(3),
          speed:
              _random.nextDouble() *
                  (GamePhysics.asteroidMaxSpeed -
                      GamePhysics.asteroidMinSpeed) +
              GamePhysics.asteroidMinSpeed,
          baseFactor: _widthBase * 2,
          velocityX:
              (_random.nextDouble() - 0.5) *
              0.2, // Reduced horizontal velocity for slower movement
          velocityY:
              _random.nextDouble() * 0.3 +
              0.2, // Reduced initial downward velocity
        ),
      );
    }
    _asteroidsController.sink.add(_startList);
    initialiseTimer(baseTime);
    startMusic();
  }

  startMusic() async {
    await _musicPlayer.setAsset('assets/music/space_track.mp3');
    await _musicPlayer.setLoopMode(LoopMode.one);
    await _musicPlayer.play();
  }

  stopMusic() {
    _musicPlayer.stop();
  }

  crashMusic() async {
    await _musicPlayer.setAsset('assets/music/space_die.wav');
    await _musicPlayer.setLoopMode(LoopMode.off);
    _musicPlayer.play();
  }

  initialiseTimer(int milliseconds) {
    _timer = Timer.periodic(Duration(milliseconds: milliseconds), (
      Timer t,
    ) async {
      // Update rocket physics
      _updateRocketPhysics();

      // Update rocket animation
      _updateRocketAnimation();

      // Update wind effects occasionally
      if (_random.nextDouble() < 0.02) {
        // 2% chance per frame
        _windForce = (_random.nextDouble() - 0.5) * GamePhysics.windForce;
      }

      // Call for each item in list to be updated with new physics.
      for (var i = 0; i < _asteroidsController.value.length; i++) {
        asteroidUpdate(_asteroidsController.value[i]);
      }

      // Check to see if more asteroids need to be added
      if (_asteroidsController.value.length < 8 + (_levelController.value)) {
        List<Asteroid> _tempList = _asteroidsController.value;
        _tempList.add(
          Asteroid(
            xPosition: _widthBase * _random.nextInt(9) * 2,
            yPosition: getUFOStartPosition(),
            type: _random.nextInt(3),
            speed:
                _random.nextDouble() *
                    (GamePhysics.asteroidMaxSpeed -
                        GamePhysics.asteroidMinSpeed) +
                GamePhysics.asteroidMinSpeed,
            baseFactor: _widthBase * 2,
            velocityX: (_random.nextDouble() - 0.5) * 0.2,
            velocityY: _random.nextDouble() * 0.3 + 0.2,
          ),
        );
        _asteroidsController.sink.add(_tempList);
      }

      //Check if collision occured using improved collision detection.
      if (checkCollisions()) {
        crashMusic();
        _timer.cancel();
        if (_highScoreController.value < _scoreController.value) {
          Prefs.highScore = _scoreController.value;
          _highScoreController.sink.add(
            _scoreController.value,
          ); // Update the stream
        }
        bool restart = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return GameOverDialog(
              context: context,
              level: _levelController.value,
              score: _scoreController.value,
            );
          },
        );
        collided = false;
        _scoreController.sink.add(0);
        _levelController.sink.add(1);
        if (restart == true) {
          startGame();
        } else if (restart == false) {
          Navigator.of(context).pop();
        }
      }
      if (_scoreController.value / 50 > _levelController.value) {
        _levelController.sink.add(_levelController.value + 1);
        _timer.cancel();
        baseTime =
            (baseTime > 10) ? baseTime - 1 : 10; // Minimum 10ms for performance
        initialiseTimer(baseTime);
      }
    });
  }

  /// Update rocket physics for smooth movement
  void _updateRocketPhysics() {
    double currentX = _rocketPositionController.value;

    // Apply acceleration towards target
    if (_rocketMovingLeft || _rocketMovingRight) {
      double direction = _rocketMovingLeft ? -1.0 : 1.0;
      _rocketVelocityX += direction * GamePhysics.rocketAcceleration;
      _rocketVelocityX = PhysicsUtils.clamp(
        _rocketVelocityX,
        -GamePhysics.rocketMaxSpeed,
        GamePhysics.rocketMaxSpeed,
      );
    } else {
      // Apply friction when not moving
      _rocketVelocityX *= GamePhysics.rocketFriction;
      if (_rocketVelocityX.abs() < 0.1) _rocketVelocityX = 0.0;
    }

    // Apply wind effects
    _rocketVelocityX += _windForce;

    // Update position
    double newX = currentX + _rocketVelocityX;

    // Keep within bounds
    newX = PhysicsUtils.clamp(newX, _widthBase * 2, _widthBase * 16);

    // Stop velocity if hitting boundaries
    if (newX == _widthBase * 2 || newX == _widthBase * 16) {
      _rocketVelocityX = 0.0;
    }

    _rocketPositionController.sink.add(newX);
  }

  /// Update rocket animation for flying effects
  void _updateRocketAnimation() {
    // Update animation time
    _animationTime +=
        GamePhysics.gameTickRate / 1000.0; // Convert ms to seconds

    // Calculate hover effect (subtle up/down floating)
    double hoverOffset =
        sin(_animationTime * GamePhysics.rocketHoverSpeed) *
        GamePhysics.rocketHoverAmplitude;
    _rocketHoverController.sink.add(hoverOffset);

    // Calculate tilt based on movement direction
    double targetTilt = 0.0;
    if (_rocketMovingLeft) {
      targetTilt = -GamePhysics.rocketTiltAngle;
    } else if (_rocketMovingRight) {
      targetTilt = GamePhysics.rocketTiltAngle;
    }

    // Smooth tilt transition
    _rocketTilt = PhysicsUtils.lerp(_rocketTilt, targetTilt, 0.1);
    _rocketTiltController.sink.add(_rocketTilt);
  }

  /// Enhanced collision detection using circular collision with spatial optimization
  bool checkCollisions() {
    double rocketCenterX = _rocketPositionController.value + _widthBase;
    double rocketCenterY = _heightBase * 16 + _widthBase;
    double rocketRadius = _widthBase * GamePhysics.rocketSize;

    // Spatial optimization: only check asteroids near the rocket
    List<Asteroid> nearbyAsteroids =
        _asteroidsController.value.where((asteroid) {
          double asteroidCenterY = asteroid.getCenterY();
          double asteroidCenterX = asteroid.getCenterX();

          // Quick distance check - only check collision if asteroid is in reasonable proximity
          double quickDistance =
              (rocketCenterY - asteroidCenterY).abs() +
              (rocketCenterX - asteroidCenterX).abs();
          return quickDistance <
              (_widthBase * 6); // Approximate proximity check
        }).toList();

    // Perform precise collision detection only on nearby asteroids
    for (Asteroid asteroid in nearbyAsteroids) {
      if (PhysicsUtils.circularCollision(
        rocketCenterX,
        rocketCenterY,
        rocketRadius,
        asteroid.getCenterX(),
        asteroid.getCenterY(),
        asteroid.getCollisionRadius(),
      )) {
        return true;
      }
    }
    return false;
  }

  /// Enhanced asteroid update with improved physics
  asteroidUpdate(Asteroid asteroid) {
    // Update asteroid physics
    asteroid.updatePhysics();

    // Apply wind effects to asteroids as well
    double currentVX = asteroid.getVelocityX();
    currentVX += _windForce * 0.5; // Reduced wind effect on asteroids
    asteroid.setVelocityX(currentVX);

    double y = asteroid.getYPosition();
    double x = asteroid.getXPosition();

    // Check if asteroid is off screen (reset)
    if (y > _heightBase * 21 ||
        x < -_widthBase * 2 ||
        x > width + _widthBase * 2) {
      _scoreController.sink.add(_scoreController.value + 1);

      // Reset asteroid position and properties
      asteroid.setYPosition(getUFOStartPosition());
      asteroid.setXPosition(_widthBase * _random.nextInt(9) * 2);
      asteroid.setType(_random.nextInt(3));
      asteroid.setSpeed(
        _random.nextDouble() *
                (GamePhysics.asteroidMaxSpeed - GamePhysics.asteroidMinSpeed) +
            GamePhysics.asteroidMinSpeed,
      );
      asteroid.setVelocityX((_random.nextDouble() - 0.5) * 0.2);
      asteroid.setVelocityY(_random.nextDouble() * 0.3 + 0.2);
    }
  }

  ///Get the start position of the UFO above the top of screen
  double getUFOStartPosition() {
    return (_random.nextInt(height.toInt()).toDouble() * -1) - 100;
  }

  ///Update the width and base factor which forms the foundation for the "ratio"
  ///elements build in essence.
  updateWidthAndBaseFactor(double width, double height) {
    _widthBase = width / 20;
    _heightBase = height / 20;
  }

  ///Move the rocket to the left with physics-based movement
  moveLeft() {
    _rocketMovingLeft = true;
    _rocketMovingRight = false;
  }

  ///Move the rocket to the right with physics-based movement
  moveRight() {
    _rocketMovingRight = true;
    _rocketMovingLeft = false;
  }

  ///Stop rocket movement
  stopMovement() {
    _rocketMovingLeft = false;
    _rocketMovingRight = false;
  }

  ///Returns the height base factor
  double hb() {
    return _heightBase;
  }

  ///Returns the height base factor
  double wb() {
    return _widthBase;
  }

  /// Dispose game logic
  dispose() {
    _asteroidsController.close();
    _scoreController.close();
    _levelController.close();
    _rocketHoverController.close();
    _rocketTiltController.close();
    _timer.cancel();
    _musicPlayer.dispose();
  }
}
