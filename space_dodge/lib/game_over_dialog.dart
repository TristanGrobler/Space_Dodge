import 'package:flutter/material.dart';
import 'package:space_dodge/constants.dart';

AlertDialog GameOverDialog({required context, required score, required level}) {
  return AlertDialog(
    backgroundColor: kPrimaryColor.withOpacity(0.7),
    contentPadding: EdgeInsets.all(50.0),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'GAME OVER',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          'Score: $score',
          style: TextStyle(
            fontSize: 18.0,
            color: kSecondaryColor,
          ),
        ),
        Text(
          'Level: $level',
          style: TextStyle(
            fontSize: 18.0,
            color: kSecondaryColor,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        ClipRRect(
          child: GestureDetector(
            onTap: () => Navigator.pop(context, true),
            child: Card(
              color: kPrimaryColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: kAccentColor, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: Text(
                  'Restart',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
