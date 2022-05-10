import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:space_dodge/asteroid.dart';

import 'logic.dart';

void main() {
  runApp(
    MaterialApp(
      home: LayoutBuilder(
        builder: (context, BoxConstraints constraints) {
          return MyApp(
            height: constraints.maxHeight - 100,
            width: constraints.maxWidth,
          );
        },
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({required this.height, required this.width});
  final double height;
  final double width;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FocusNode _focusNode = FocusNode();
  late Logic game = Logic(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
  );

  @override
  void dispose() {
    _focusNode.dispose();
    game.dispose();
    super.dispose();
  }

  @override
  void initState() {
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
            return 'images/ufo.png';
          case 1:
            return 'images/asteroid_1.png';
          case 2:
            return 'images/asteroid_2.png';
          default:
            return 'images/ufo.png';
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
      body: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _handleKeyEvent,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: SafeArea(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.asset(
                    'images/space background.png',
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
                        left: snapshot.data == null ? -100 : snapshot.data,
                        child: SizedBox(
                          height: game.wb() * 2,
                          width: game.wb() * 2,
                          child: Image.asset(
                            'images/rocket.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                StreamBuilder<Asteroid>(
                  stream: game.ufo1Position,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder<List>(
                          stream: snapshot.data!.ufoData,
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return ufoWidget(
                                  snap.data![0], snap.data![1], snap.data![2]);
                            } else {
                              return Container();
                            }
                          });
                    } else {
                      return Container();
                    }
                  },
                ),
                StreamBuilder<Asteroid>(
                  stream: game.ufo2Position,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder<List>(
                          stream: snapshot.data!.ufoData,
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return ufoWidget(
                                  snap.data![0], snap.data![1], snap.data![2]);
                            } else {
                              return Container();
                            }
                          });
                    } else {
                      return Container();
                    }
                  },
                ),
                StreamBuilder<Asteroid>(
                  stream: game.ufo3Position,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder<List>(
                          stream: snapshot.data!.ufoData,
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return ufoWidget(
                                  snap.data![0], snap.data![1], snap.data![2]);
                            } else {
                              return Container();
                            }
                          });
                    } else {
                      return Container();
                    }
                  },
                ),
                StreamBuilder<Asteroid>(
                  stream: game.ufo4Position,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder<List>(
                          stream: snapshot.data!.ufoData,
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return ufoWidget(
                                  snap.data![0], snap.data![1], snap.data![2]);
                            } else {
                              return Container();
                            }
                          });
                    } else {
                      return Container();
                    }
                  },
                ),
                StreamBuilder<Asteroid>(
                  stream: game.ufo5Position,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder<List>(
                          stream: snapshot.data!.ufoData,
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return ufoWidget(
                                  snap.data![0], snap.data![1], snap.data![2]);
                            } else {
                              return Container();
                            }
                          });
                    } else {
                      return Container();
                    }
                  },
                ),
                StreamBuilder<Asteroid>(
                  stream: game.ufo6Position,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder<List>(
                          stream: snapshot.data!.ufoData,
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return ufoWidget(
                                  snap.data![0], snap.data![1], snap.data![2]);
                            } else {
                              return Container();
                            }
                          });
                    } else {
                      return Container();
                    }
                  },
                ),
                StreamBuilder<Asteroid>(
                  stream: game.ufo7Position,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder<List>(
                          stream: snapshot.data!.ufoData,
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return ufoWidget(
                                  snap.data![0], snap.data![1], snap.data![2]);
                            } else {
                              return Container();
                            }
                          });
                    } else {
                      return Container();
                    }
                  },
                ),
                StreamBuilder<Asteroid>(
                  stream: game.ufo8Position,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder<List>(
                          stream: snapshot.data!.ufoData,
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return ufoWidget(
                                  snap.data![0], snap.data![1], snap.data![2]);
                            } else {
                              return Container();
                            }
                          });
                    } else {
                      return Container();
                    }
                  },
                ),
                StreamBuilder<int>(
                  stream: game.score,
                  builder: (context, snapshot) {
                    return Positioned(
                      top: 20.0,
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
                      top: 0.0,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
