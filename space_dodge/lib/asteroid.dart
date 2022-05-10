import 'package:rxdart/rxdart.dart';

class Asteroid {
  final double xPosition;
  final double yPosition;
  final int type;
  final int speed;

  Asteroid({
    required this.xPosition,
    required this.yPosition,
    required this.type,
    required this.speed,
  }) {
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

  ///Get the speed of the asteroid
  int getSpeed() {
    return _ufoSpeedController.value;
  }
}
