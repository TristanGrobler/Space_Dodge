import 'dart:async';

import 'package:flutter/material.dart';
import 'package:space_dodge/prefs.dart';
import 'package:space_dodge/screens/menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.initialise();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, BoxConstraints constraints) {
          return MenuScreen(
            height: constraints.maxHeight - 100,
            width: constraints.maxWidth,
          );
        },
      ),
    ),
  );
}
