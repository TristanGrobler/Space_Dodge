import 'dart:async';
import 'dart:math';

import 'package:rxdart/rxdart.dart';

class Logic {
  final double width;
  final double height;

  Logic({required this.width, required this.height}) {
    startGame();
    updateWidthAndBaseFactor(width, height);
  }

  final _random = Random();
  late double _widthBase;
  late double _heightBase;
  late Timer everySecond;
  bool collided = false;

  //Declare controllers
  final _ufo1PositionController = BehaviorSubject<double>();
  final _ufo2PositionController = BehaviorSubject<double>();
  final _ufo3PositionController = BehaviorSubject<double>();
  final _ufo4PositionController = BehaviorSubject<double>();
  final _ufo5PositionController = BehaviorSubject<double>();
  final _ufo6PositionController = BehaviorSubject<double>();
  final _ufo7PositionController = BehaviorSubject<double>();
  final _ufo8PositionController = BehaviorSubject<double>();
  final _ufo9PositionController = BehaviorSubject<double>();
  final _ufo10PositionController = BehaviorSubject<double>();
  final _rocketPositionController = BehaviorSubject<double>();
  final _scoreController = BehaviorSubject<int>();
  final _levelController = BehaviorSubject<int>();

  //Methods to retrieve stream values
  Stream<double> get ufo1Position => _ufo1PositionController.stream;
  Stream<double> get ufo2Position => _ufo2PositionController.stream;
  Stream<double> get ufo3Position => _ufo3PositionController.stream;
  Stream<double> get ufo4Position => _ufo4PositionController.stream;
  Stream<double> get ufo5Position => _ufo5PositionController.stream;
  Stream<double> get ufo6Position => _ufo6PositionController.stream;
  Stream<double> get ufo7Position => _ufo7PositionController.stream;
  Stream<double> get ufo8Position => _ufo8PositionController.stream;
  Stream<double> get ufo9Position => _ufo9PositionController.stream;
  Stream<double> get ufo10Position => _ufo10PositionController.stream;
  Stream<double> get rocketPosition => _rocketPositionController.stream;
  Stream<int> get score => _scoreController.stream;
  Stream<int> get level => _levelController.stream;

  ///Start the game.
  startGame() {
    _rocketPositionController.sink.add(width / 2);
    _ufo1PositionController.sink.add(getUFOStartPosition());
    _ufo2PositionController.sink.add(getUFOStartPosition());
    _ufo3PositionController.sink.add(getUFOStartPosition());
    _ufo4PositionController.sink.add(getUFOStartPosition());
    _ufo5PositionController.sink.add(getUFOStartPosition());
    _ufo6PositionController.sink.add(getUFOStartPosition());
    _ufo7PositionController.sink.add(getUFOStartPosition());
    _ufo8PositionController.sink.add(getUFOStartPosition());
    _ufo9PositionController.sink.add(getUFOStartPosition());
    _scoreController.sink.add(0);
    _levelController.sink.add(0);
    initialiseTimer(50);
  }

  initialiseTimer(int milliseconds) {
    everySecond =
        Timer.periodic(Duration(milliseconds: milliseconds), (Timer t) {
      _ufo1PositionController.sink.add(
        ufoUpdate(_ufo1PositionController.value, 5, 2),
      );
      _ufo2PositionController.sink.add(
        ufoUpdate(_ufo2PositionController.value, 8, 4),
      );
      _ufo3PositionController.sink.add(
        ufoUpdate(_ufo3PositionController.value, 7, 6),
      );
      _ufo4PositionController.sink.add(
        ufoUpdate(_ufo4PositionController.value, 6, 8),
      );
      _ufo5PositionController.sink.add(
        ufoUpdate(_ufo5PositionController.value, 8, 10),
      );
      _ufo6PositionController.sink.add(
        ufoUpdate(_ufo6PositionController.value, 5, 12),
      );
      _ufo7PositionController.sink.add(
        ufoUpdate(_ufo7PositionController.value, 6, 14),
      );
      _ufo8PositionController.sink.add(
        ufoUpdate(_ufo8PositionController.value, 8, 16),
      );
      _ufo9PositionController.sink.add(
        ufoUpdate(_ufo9PositionController.value, 6, 18),
      );

      //Refresh the UI
      if (collided == true) {
        collided = false;
        print('Score zerod');
        _scoreController.sink.add(0);
        _levelController.sink.add(1);
        everySecond.cancel();
        startGame();
      }
      if (_scoreController.value / 50 > _levelController.value) {
        _levelController.sink.add(_levelController.value + 1);
        everySecond.cancel();
        initialiseTimer(milliseconds - 5);
      }
    });
  }

  /// Calculates the new UFO position and if it has collided with the rocket
  double ufoUpdate(double ufoPosition, double speed, double baseFactor) {
    var updateRandom = Random();
    if (ufoPosition - (_heightBase * 18) < (_widthBase + 1) &&
        ufoPosition - (_heightBase * 18) > -(_widthBase + 1) &&
        _rocketPositionController.value - (_widthBase * baseFactor) <
            (_widthBase + 1) &&
        _rocketPositionController.value - (_widthBase * baseFactor) >
            -(_widthBase + 1)) {
      ufoPosition = updateRandom.nextInt(500).toDouble() * -1;
      collided = true;
      return ufoPosition;
    } else if (ufoPosition < _heightBase * 18) {
      ufoPosition += speed;
      return ufoPosition;
    } else {
      _scoreController.sink.add(_scoreController.value + 1);
      ufoPosition = updateRandom.nextInt(500).toDouble() * -1;
      return ufoPosition;
    }
  }

  ///Get the start position of the UFO above the top of screen
  double getUFOStartPosition() {
    return (_random.nextInt(400).toDouble() * -1) - 100;
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
    if (_rocketPositionController.value < _widthBase * 18) {
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
    _ufo1PositionController.close();
    _ufo2PositionController.close();
    _ufo3PositionController.close();
    _ufo4PositionController.close();
    _ufo5PositionController.close();
    _ufo6PositionController.close();
    _ufo7PositionController.close();
    _ufo8PositionController.close();
    _ufo8PositionController.close();
    everySecond.cancel();
  }
}
