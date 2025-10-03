import 'package:flutter/cupertino.dart';
import 'dart:math';

Color kPrimaryColor = Color(0xff031b2e);
Color kSecondaryColor = Color(0xff025599);
Color kAccentColor = Color(0xffeb721f);

// Physics Constants
class GamePhysics {
  // Rocket physics
  static const double rocketAcceleration =
      0.4; // Reduced by 50% for better balance
  static const double rocketMaxSpeed =
      8.0; // Reduced from 12.0 for better control
  static const double rocketFriction = 0.85;
  static const double rocketSize = 1.0; // Multiplier for collision radius

  // Asteroid physics
  static const double asteroidMinSpeed = 0.3; // Reduced to 10% (was 3.0)
  static const double asteroidMaxSpeed = 1.2; // Reduced to 10% (was 12.0)
  static const double asteroidAcceleration = 0.01; // Reduced to 10% (was 0.1)
  static const double asteroidSize = 0.8; // Multiplier for collision radius
  static const double asteroidRotationSpeed = 2.0; // Visual effect

  // Game physics
  static const double gravity = 0.05;
  static const int gameTickRate =
      16; // milliseconds per frame for smoother physics
  static const double windForce = 0.02; // Slight horizontal force for realism

  // Collision detection
  static const double collisionTolerance =
      0.85; // Reduces hitbox slightly for better gameplay
  static const double spatialGridSize =
      100.0; // For spatial partitioning optimization

  // Visual effects
  static const int trailLength = 5; // Length of motion trail for objects
  static const double screenShakeIntensity = 3.0; // Screen shake on collision

  // Rocket animation
  static const double rocketHoverAmplitude = 3.0; // Vertical hover distance
  static const double rocketHoverSpeed = 2.0; // Speed of hover animation
  static const double rocketTiltAngle =
      0.1; // Max tilt angle when moving (radians)
  static const double rocketEngineFlicker = 0.3; // Engine effect intensity
}

// Utility class for physics calculations
class PhysicsUtils {
  // Calculate circular collision between two objects
  static bool circularCollision(
    double x1,
    double y1,
    double radius1,
    double x2,
    double y2,
    double radius2,
  ) {
    double dx = x1 - x2;
    double dy = y1 - y2;
    double distance = sqrt(dx * dx + dy * dy);
    return distance < (radius1 + radius2) * GamePhysics.collisionTolerance;
  }

  // Clamp a value between min and max
  static double clamp(double value, double min, double max) {
    return value < min ? min : (value > max ? max : value);
  }

  // Linear interpolation for smooth movement
  static double lerp(double start, double end, double t) {
    return start + (end - start) * t;
  }
}
