import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rxdart/rxdart.dart';

import '../ad_manager.dart';
import '../asteroid.dart';
import '../constants.dart';
import '../logic.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({required this.height, required this.width});
  final double height;
  final double width;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final FocusNode _focusNode = FocusNode();
  late Logic game = Logic(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    context: context,
  );

  // Touch control state for visual feedback
  bool _leftControlPressed = false;
  bool _rightControlPressed = false;

  final BannerAd myBanner = BannerAd(
    size: const AdSize(width: 320, height: 50),
    adUnitId: AdManager.bannerAdUnitId,
    listener: const BannerAdListener(),
    request: const AdRequest(),
  );

  @override
  void dispose() {
    _focusNode.dispose();
    myBanner.dispose();
    game.dispose();
    super.dispose();
  }

  @override
  void initState() {
    myBanner.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    game.updateWidthAndBaseFactor(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    );

    void _handleKeyEvent(RawKeyEvent event) {
      if (event.runtimeType.toString() == 'RawKeyDownEvent') {
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          game.moveLeft();
        } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          game.moveRight();
        }
      } else if (event.runtimeType.toString() == 'RawKeyUpEvent') {
        // Stop movement when key is released for more responsive controls
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
            event.logicalKey == LogicalKeyboardKey.arrowRight) {
          game.stopMovement();
        }
      }
    }

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _handleKeyEvent,
        child: SafeArea(
          child: StreamBuilder<List<Asteroid>>(
            stream: game.asteroids,
            builder: (context, snapshot) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(_focusNode);
                },
                behavior: HitTestBehavior.deferToChild,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(
                        'assets/images/space background.png',
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.repeat,
                      ),
                    ),
                    StreamBuilder<List<double>>(
                      stream: Rx.combineLatest3(
                        game.rocketPosition,
                        game.rocketHover,
                        game.rocketTilt,
                        (pos, hover, tilt) => [pos, hover, tilt],
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }

                        final position = snapshot.data![0];
                        final hoverOffset = snapshot.data![1];
                        final tiltAngle = snapshot.data![2];

                        return AnimatedPositioned(
                          duration: Duration(
                            milliseconds: GamePhysics.gameTickRate,
                          ),
                          top: game.hb() * 16 + hoverOffset,
                          left: position,
                          child: Transform.rotate(
                            angle: tiltAngle,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Engine glow effect (subtle animation)
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 100),
                                  height: game.wb() * 2.5,
                                  width: game.wb() * 0.5,
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.blue.withOpacity(0.3),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                                // Main rocket
                                SizedBox(
                                  height: game.wb() * 2,
                                  width: game.wb() * 2,
                                  child: Image.asset(
                                    'assets/images/rocket.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    ...?snapshot.data,
                    StreamBuilder<int>(
                      stream: game.highScore,
                      builder: (context, snapshot) {
                        return Positioned(
                          top: 50.0,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'High Score: ${snapshot.data ?? 0}',
                              style: TextStyle(color: Colors.white60),
                            ),
                          ),
                        );
                      },
                    ),
                    StreamBuilder<int>(
                      stream: game.score,
                      builder: (context, snapshot) {
                        return Positioned(
                          top: 90.0,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Score: ${snapshot.data ?? 0}',
                              style: TextStyle(color: Colors.white60),
                            ),
                          ),
                        );
                      },
                    ),
                    StreamBuilder<int>(
                      stream: game.level,
                      builder: (context, snapshot) {
                        return Positioned(
                          top: 70.0,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Level: ${snapshot.data ?? 0}',
                              style: TextStyle(color: Colors.white60),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      left: 0.0,
                      top: 50.0,
                      child: GestureDetector(
                        onPanStart: (_) {
                          setState(() => _leftControlPressed = true);
                          game.moveLeft();
                        },
                        onPanUpdate: (_) => game.moveLeft(),
                        onPanEnd: (_) {
                          setState(() => _leftControlPressed = false);
                          game.stopMovement();
                        },
                        onPanCancel: () {
                          setState(() => _leftControlPressed = false);
                          game.stopMovement();
                        },
                        onTapDown: (_) {
                          setState(() => _leftControlPressed = true);
                          game.moveLeft();
                        },
                        onTapUp: (_) {
                          setState(() => _leftControlPressed = false);
                          game.stopMovement();
                        },
                        onTapCancel: () {
                          setState(() => _leftControlPressed = false);
                          game.stopMovement();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          color:
                              _leftControlPressed
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.transparent,
                          width: widget.width / 2,
                          height:
                              widget.height - 60, // Avoid overlapping with ad
                          child: Center(
                            child: Icon(
                              Icons.arrow_left,
                              color: Colors.white.withOpacity(0.3),
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      top: 50.0,
                      child: GestureDetector(
                        onPanStart: (_) {
                          setState(() => _rightControlPressed = true);
                          game.moveRight();
                        },
                        onPanUpdate: (_) => game.moveRight(),
                        onPanEnd: (_) {
                          setState(() => _rightControlPressed = false);
                          game.stopMovement();
                        },
                        onPanCancel: () {
                          setState(() => _rightControlPressed = false);
                          game.stopMovement();
                        },
                        onTapDown: (_) {
                          setState(() => _rightControlPressed = true);
                          game.moveRight();
                        },
                        onTapUp: (_) {
                          setState(() => _rightControlPressed = false);
                          game.stopMovement();
                        },
                        onTapCancel: () {
                          setState(() => _rightControlPressed = false);
                          game.stopMovement();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          color:
                              _rightControlPressed
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.transparent,
                          width: widget.width / 2,
                          height:
                              widget.height - 60, // Avoid overlapping with ad
                          child: Center(
                            child: Icon(
                              Icons.arrow_right,
                              color: Colors.white.withOpacity(0.3),
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 0,
                      child: Container(
                        width: widget.width,
                        height: 50,
                        color: kPrimaryColor.withOpacity(0.5),
                        child: AdWidget(ad: myBanner),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
