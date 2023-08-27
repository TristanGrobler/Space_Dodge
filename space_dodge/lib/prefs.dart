import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const PREF_SPACE_SHIP = 'PREF_SPACE_SHIP';
  static const PREF_HIGH_SCORE = 'PREF_HIGH_SCORE';

  static SharedPreferences? _prefs;

  static Future<bool> initialise() async {
    _prefs = await SharedPreferences.getInstance();
    return true;
  }

  static int get highScore => _prefs?.getInt(PREF_HIGH_SCORE) ?? 0;
  static set highScore(int score) => _prefs!.setInt(PREF_HIGH_SCORE, score);
  static int get spaceShip => _prefs?.getInt(PREF_SPACE_SHIP) ?? 1;
  static set spaceShip(int spaceShip) => _prefs!.setInt(PREF_SPACE_SHIP, spaceShip);

}
