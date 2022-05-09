import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  bool collided = false;

  //int score = 0;

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
      setState(() {
        String _message =
            'Not a Q: Pressed 0x${event.logicalKey.keyId.toRadixString(16)}';
        print(_message);

        if (event.runtimeType.toString() == 'RawKeyDownEvent') {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            game.moveLeft();
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            game.moveRight();
          }
        }
      });
    }

    Widget ufoWidget(double? ufo, double leftFactor) {
      return AnimatedPositioned(
        top: ufo ?? -100,
        left: game.wb() * leftFactor,
        duration: Duration(milliseconds: 50),
        child: SizedBox(
          height: game.wb() * 2,
          width: game.wb() * 2,
          child: Image.asset(
            'images/ufo.png',
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    //FocusScope.of(context).requestFocus(_focusNode);

    return Scaffold(
      appBar: AppBar(
        title: Text('Space Dodge'),
        centerTitle: true,
      ),
      body: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _handleKeyEvent,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
            print('grabbed');
          },
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  'images/space background.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 30.0,
                bottom: 30.0,
                child: GestureDetector(
                  onTap: game.moveLeft,
                  child: Container(
                    color: Colors.white30,
                    child: Icon(
                      Icons.chevron_left,
                      size: 50.0,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 30.0,
                bottom: 30.0,
                child: GestureDetector(
                  onTap: game.moveRight,
                  child: Container(
                    color: Colors.white30,
                    child: Icon(
                      Icons.chevron_right,
                      size: 50.0,
                    ),
                  ),
                ),
              ),
              StreamBuilder<double>(
                  stream: game.rocketPosition,
                  builder: (context, snapshot) {
                    return Positioned(
                      top: game.hb() * 18,
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
              StreamBuilder<double>(
                  stream: game.ufo1Position,
                  builder: (context, snapshot) {
                    return ufoWidget(snapshot.data, 2);
                  }),
              StreamBuilder<double>(
                  stream: game.ufo2Position,
                  builder: (context, snapshot) {
                    return ufoWidget(snapshot.data, 4);
                  }),
              StreamBuilder<double>(
                  stream: game.ufo3Position,
                  builder: (context, snapshot) {
                    return ufoWidget(snapshot.data, 6);
                  }),
              StreamBuilder<double>(
                  stream: game.ufo4Position,
                  builder: (context, snapshot) {
                    return ufoWidget(snapshot.data, 8);
                  }),
              StreamBuilder<double>(
                  stream: game.ufo5Position,
                  builder: (context, snapshot) {
                    return ufoWidget(snapshot.data, 10);
                  }),
              StreamBuilder<double>(
                  stream: game.ufo6Position,
                  builder: (context, snapshot) {
                    return ufoWidget(snapshot.data, 12);
                  }),
              StreamBuilder<double>(
                  stream: game.ufo7Position,
                  builder: (context, snapshot) {
                    return ufoWidget(snapshot.data, 14);
                  }),
              StreamBuilder<double>(
                  stream: game.ufo8Position,
                  builder: (context, snapshot) {
                    return ufoWidget(snapshot.data, 16);
                  }),
              StreamBuilder<double>(
                  stream: game.ufo9Position,
                  builder: (context, snapshot) {
                    return ufoWidget(snapshot.data, 18);
                  }),
              StreamBuilder<int>(
                  stream: game.score,
                  builder: (context, snapshot) {
                    return Positioned(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Score: ${snapshot.data ?? 0}',
                          style: TextStyle(color: Colors.white60),
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
