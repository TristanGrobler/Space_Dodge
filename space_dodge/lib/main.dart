import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Space Dodge'),
        centerTitle: true,
      ),
      body: Stack(
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
            child: Icon(
              Icons.chevron_left,
              size: 50.0,
            ),
          ),
          Positioned(
            right: 30.0,
            bottom: 30.0,
            child: Icon(
              Icons.chevron_right,
              size: 50.0,
            ),
          ),
        ],
      ),
    );
  }
}
