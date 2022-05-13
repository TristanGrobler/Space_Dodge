import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
      }
    }

    Widget ufoWidget(double? ufoX, double? ufoY, int? type) {
      String _getImage() {
        switch (type) {
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

      return ufoY != null && ufoX != null && ufoY > 0
          ? AnimatedPositioned(
              top: ufoY,
              left: ufoX,
              duration: Duration(milliseconds: 50),
              child: SizedBox(
                height: game.wb() * 2,
                width: game.wb() * 2,
                child: Image.asset(
                  _getImage(),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Container();
    }

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _handleKeyEvent,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: SafeArea(
            child: StreamBuilder<List<Asteroid>>(
                stream: game.asteroids,
                builder: (context, snapshot) {
                  return Stack(
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
                      Positioned(
                        left: 0.0,
                        top: 50.0,
                        child: GestureDetector(
                          onTap: game.moveLeft,
                          child: Container(
                            color: Colors.transparent,
                            width: widget.width / 2,
                            height: widget.height,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0.0,
                        top: 50.0,
                        child: GestureDetector(
                          onTap: game.moveRight,
                          child: Container(
                            color: Colors.transparent,
                            width: widget.width / 2,
                            height: widget.height,
                          ),
                        ),
                      ),
                      StreamBuilder<double>(
                          stream: game.rocketPosition,
                          builder: (context, snapshot) {
                            print(snapshot.data);
                            return AnimatedPositioned(
                              duration: Duration(milliseconds: 50),
                              top: game.hb() * 16,
                              left:
                                  snapshot.data == null ? -100 : snapshot.data,
                              child: SizedBox(
                                height: game.wb() * 2,
                                width: game.wb() * 2,
                                child: Image.asset(
                                  'assets/images/rocket.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }),
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
                        top: 10,
                        left: 0,
                        child: Container(
                          width: widget.width,
                          height: 50,
                          color: kPrimaryColor.withOpacity(0.5),
                          child: AdWidget(
                            ad: myBanner,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
