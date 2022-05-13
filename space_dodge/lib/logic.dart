import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:space_dodge/asteroid.dart';
import 'package:space_dodge/game_over_dialog.dart';
import 'package:space_dodge/prefs.dart';

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

  //Declare controllers
  final _ufo1PositionController = BehaviorSubject<Asteroid>();
  final _ufo2PositionController = BehaviorSubject<Asteroid>();
  final _ufo3PositionController = BehaviorSubject<Asteroid>();
  final _ufo4PositionController = BehaviorSubject<Asteroid>();
  final _ufo5PositionController = BehaviorSubject<Asteroid>();
  final _ufo6PositionController = BehaviorSubject<Asteroid>();
  final _ufo7PositionController = BehaviorSubject<Asteroid>();
  final _ufo8PositionController = BehaviorSubject<Asteroid>();
  final _rocketPositionController = BehaviorSubject<double>();
  final _scoreController = BehaviorSubject<int>();
  final _highScoreController = BehaviorSubject<int>();
  final _levelController = BehaviorSubject<int>();
  final _asteroidsController = BehaviorSubject<List<Asteroid>>();

  //Methods to retrieve stream values
  Stream<Asteroid> get ufo1Position => _ufo1PositionController.stream;
  Stream<Asteroid> get ufo2Position => _ufo2PositionController.stream;
  Stream<Asteroid> get ufo3Position => _ufo3PositionController.stream;
  Stream<Asteroid> get ufo4Position => _ufo4PositionController.stream;
  Stream<Asteroid> get ufo5Position => _ufo5PositionController.stream;
  Stream<Asteroid> get ufo6Position => _ufo6PositionController.stream;
  Stream<Asteroid> get ufo7Position => _ufo7PositionController.stream;
  Stream<Asteroid> get ufo8Position => _ufo8PositionController.stream;
  Stream<double> get rocketPosition => _rocketPositionController.stream;
  Stream<int> get score => _scoreController.stream;
  Stream<int> get highScore => _highScoreController.stream;
  Stream<int> get level => _levelController.stream;
  Stream<List<Asteroid>> get asteroids => _asteroidsController.stream;

  ///Start the game.
  startGame() {
    _highScoreController.sink.add(Prefs.highScore);
    _rocketPositionController.sink.add(width / 2 - _widthBase);
    _ufo1PositionController.sink.add(Asteroid(
      xPosition: _widthBase * 2,
      yPosition: getUFOStartPosition(),
      type: _random.nextInt(3),
      speed: _random.nextInt(5) + 5,
    ));
    _ufo2PositionController.sink.add(Asteroid(
      xPosition: _widthBase * 4,
      yPosition: getUFOStartPosition(),
      type: _random.nextInt(3),
      speed: _random.nextInt(5) + 5,
    ));
    _ufo3PositionController.sink.add(Asteroid(
      xPosition: _widthBase * 6,
      yPosition: getUFOStartPosition(),
      type: _random.nextInt(3),
      speed: _random.nextInt(5) + 5,
    ));
    _ufo4PositionController.sink.add(Asteroid(
      xPosition: _widthBase * 8,
      yPosition: getUFOStartPosition(),
      type: _random.nextInt(3),
      speed: _random.nextInt(5) + 5,
    ));
    _ufo5PositionController.sink.add(Asteroid(
      xPosition: _widthBase * 10,
      yPosition: getUFOStartPosition(),
      type: _random.nextInt(3),
      speed: _random.nextInt(5) + 5,
    ));
    _ufo6PositionController.sink.add(Asteroid(
      xPosition: _widthBase * 12,
      yPosition: getUFOStartPosition(),
      type: _random.nextInt(3),
      speed: _random.nextInt(5) + 5,
    ));
    _ufo7PositionController.sink.add(Asteroid(
      xPosition: _widthBase * 14,
      yPosition: getUFOStartPosition(),
      type: _random.nextInt(3),
      speed: _random.nextInt(5) + 5,
    ));
    _ufo8PositionController.sink.add(Asteroid(
      xPosition: _widthBase * 16,
      yPosition: getUFOStartPosition(),
      type: _random.nextInt(3),
      speed: _random.nextInt(5) + 5,
    ));

    _scoreController.sink.add(0);
    _levelController.sink.add(0);
    initialiseTimer(50);
  }

  initialiseTimer(int milliseconds) {
    _timer =
        Timer.periodic(Duration(milliseconds: milliseconds), (Timer t) async {
      ufoUpdate(_ufo1PositionController);
      ufoUpdate(_ufo2PositionController);
      ufoUpdate(_ufo3PositionController);
      ufoUpdate(_ufo4PositionController);
      ufoUpdate(_ufo5PositionController);
      ufoUpdate(_ufo6PositionController);
      ufoUpdate(_ufo7PositionController);
      ufoUpdate(_ufo8PositionController);

      //Refresh the UI
      if (collided == true) {
        _timer.cancel();
        if (_highScoreController.value < _scoreController.value) {
          Prefs.highScore = _scoreController.value;
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
            });
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
        initialiseTimer(milliseconds - 5);
      }
    });
  }

  /// Calculates the new UFO position and if it has collided with the rocket
  ufoUpdate(BehaviorSubject<Asteroid> bs) {
    double y = bs.value.getYPosition();
    double x = bs.value.getXPosition();
    int speed = bs.value.getSpeed();
    var updateRandom = Random();
    if (y - (_heightBase * 16) < (_widthBase + 1) &&
        y - (_heightBase * 16) > -(_widthBase + 1) &&
        _rocketPositionController.value - (x) < (_widthBase + 1) &&
        _rocketPositionController.value - (x) > -(_widthBase + 1)) {
      y = updateRandom.nextInt(500).toDouble() * -1;
      collided = true;
      bs.value.setYPosition(y);
    } else if (y < _heightBase * 21) {
      y += speed;
      bs.value.setYPosition(y);
    } else {
      _scoreController.sink.add(_scoreController.value + 1);
      y = updateRandom.nextInt(500).toDouble() * -1;
      bs.value.setYPosition(y);
      bs.value.setType(updateRandom.nextInt(3));
      bs.value.setSpeed(_random.nextInt(5) + 5);
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

  ///Move the rocket to the left
  moveLeft() {
    if (_rocketPositionController.value > _widthBase * 2) {
      _rocketPositionController.sink
          .add(_rocketPositionController.value - _widthBase);
    }
  }

  ///Move the rocket to the right
  moveRight() {
    if (_rocketPositionController.value < _widthBase * 16) {
      _rocketPositionController.sink
          .add(_rocketPositionController.value + _widthBase);
    }
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
    // _ufo1PositionController.close();
    // _ufo2PositionController.close();
    // _ufo3PositionController.close();
    // _ufo4PositionController.close();
    // _ufo5PositionController.close();
    // _ufo6PositionController.close();
    // _ufo7PositionController.close();
    // _ufo8PositionController.close();
    // _ufo8PositionController.close();
    _asteroidsController.close();
    _scoreController.close();
    _levelController.close();
    _timer.cancel();
  }
}
