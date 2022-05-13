import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:space_dodge/asteroid.dart';
import 'package:space_dodge/screens/game_over_dialog.dart';
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
  int baseTime = 50;

  //Declare controllers
  final _rocketPositionController = BehaviorSubject<double>();
  final _scoreController = BehaviorSubject<int>();
  final _highScoreController = BehaviorSubject<int>();
  final _levelController = BehaviorSubject<int>();
  final _asteroidsController = BehaviorSubject<List<Asteroid>>();
  final _musicPlayer = AudioPlayer();

  //Methods to retrieve stream values
  Stream<double> get rocketPosition => _rocketPositionController.stream;
  Stream<int> get score => _scoreController.stream;
  Stream<int> get highScore => _highScoreController.stream;
  Stream<int> get level => _levelController.stream;
  Stream<List<Asteroid>> get asteroids => _asteroidsController.stream;

  ///Start the game.
  startGame() {
    _highScoreController.sink.add(Prefs.highScore);
    _rocketPositionController.sink.add(width / 2 - _widthBase);
    _scoreController.sink.add(0);
    _levelController.sink.add(0);
    List<Asteroid> _startList = [];
    for (var i = 0; i < 8; i++) {
      _startList.add(
        Asteroid(
          xPosition: _widthBase * (i + 1) * 2,
          yPosition: getUFOStartPosition(),
          type: _random.nextInt(3),
          speed: _random.nextInt(5) + 5,
          baseFactor: _widthBase * 2,
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
    _timer =
        Timer.periodic(Duration(milliseconds: milliseconds), (Timer t) async {
      // Call for each item in list to be updated.
      for (var i = 0; i < _asteroidsController.value.length; i++) {
        ufoUpdate(_asteroidsController.value[i]);
      }
      // Check to see if more asteroids need to be added
      if (_asteroidsController.value.length < 8 + (_levelController.value)) {
        List<Asteroid> _tempList = _asteroidsController.value;
        _tempList.add(
          Asteroid(
            xPosition: _widthBase * _random.nextInt(9) * 2,
            yPosition: getUFOStartPosition(),
            type: _random.nextInt(3),
            speed: _random.nextInt(5) + 5,
            baseFactor: _widthBase * 2,
          ),
        );
        _asteroidsController.sink.add(_tempList);
      }

      //Check if collision occured.
      if (collided == true) {
        crashMusic();
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
        baseTime -= 1;
        initialiseTimer(baseTime);
      }
    });
  }

  /// Calculates the new UFO position and if it has collided with the rocket
  ufoUpdate(Asteroid asteroid) {
    double y = asteroid.getYPosition();
    double x = asteroid.getXPosition();
    int speed = asteroid.getSpeed();
    var updateRandom = Random();
    if (y - (_heightBase * 16) < (_widthBase + 1) &&
        y - (_heightBase * 16) > -(_widthBase + 1) &&
        _rocketPositionController.value - (x) < (_widthBase + 1) &&
        _rocketPositionController.value - (x) > -(_widthBase + 1)) {
      y = updateRandom.nextInt(500).toDouble() * -1;
      collided = true;
      asteroid.setYPosition(y);
    } else if (y < _heightBase * 21) {
      y += speed;
      asteroid.setYPosition(y);
    } else {
      _scoreController.sink.add(_scoreController.value + 1);
      y = updateRandom.nextInt(500).toDouble() * -1;
      asteroid.setYPosition(y);
      asteroid.setType(updateRandom.nextInt(3));
      asteroid.setSpeed(_random.nextInt(5) + 5);
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
    _asteroidsController.close();
    _scoreController.close();
    _levelController.close();
    _timer.cancel();
    _musicPlayer.dispose();
  }
}
