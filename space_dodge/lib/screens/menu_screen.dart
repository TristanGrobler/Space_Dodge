import 'package:flutter/material.dart';
import 'package:space_dodge/prefs.dart';
import 'package:space_dodge/screens/game_screen.dart';

import '../constants.dart';

class MenuScreen extends StatelessWidget {
  final double height;
  final double width;
  const MenuScreen({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Image.asset(
              'assets/images/space background.png',
              fit: BoxFit.cover,
              height: height + 100,
              width: width,
            ),
          ),
          SafeArea(
            child: Container(
              color: kPrimaryColor.withOpacity(0.7),
              height: height + 100,
              width: width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          color: kSecondaryColor.withOpacity(0.5),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.asset(
                                'assets/images/icon.png',
                                fit: BoxFit.cover,
                                width: width / 2,
                                height: width / 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(width / 6),
                      child: Text(
                        'Space Adventure Hero',
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'High Score:',
                      style: TextStyle(
                        fontSize: 28.0,
                        color: kSecondaryColor,
                      ),
                    ),
                    Text(
                      Prefs.highScore.toString(),
                      style: TextStyle(
                        fontSize: 28.0,
                        color: kSecondaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    ClipRRect(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return GameScreen(height: height, width: width);
                            },
                          ),
                        ),
                        child: Card(
                          color: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: kAccentColor, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 10.0),
                            child: Text(
                              "Let's Fly",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Music Credits: '
                        'Space Fiction by Quarkstar (c) copyright 2018 Licensed '
                        'under a Creative Commons Attribution Noncommercial  (3.0) '
                        'license. http://dig.ccmixter.org/files/Quarkstar/57369 ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10.0, color: Colors.white60),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
