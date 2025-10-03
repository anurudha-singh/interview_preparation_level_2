import 'package:flutter/material.dart';

class SizeHelper {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  /// Initialize the SizeHelper with the current context
  /// Call this method in your main widget's build method
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;
  }

  /// Get percentage of screen width
  static double getWidthPercentage(double percentage) {
    return screenWidth * (percentage / 100);
  }

  /// Get percentage of screen height
  static double getHeightPercentage(double percentage) {
    return screenHeight * (percentage / 100);
  }

  /// Get safe area width percentage (excluding notches, status bar etc.)
  static double getSafeWidthPercentage(double percentage) {
    return (screenWidth - safeAreaHorizontal) * (percentage / 100);
  }

  /// Get safe area height percentage (excluding notches, status bar etc.)
  static double getSafeHeightPercentage(double percentage) {
    return (screenHeight - safeAreaVertical) * (percentage / 100);
  }

  /// Check if device is in portrait mode
  static bool get isPortrait => screenHeight > screenWidth;

  /// Check if device is in landscape mode
  static bool get isLandscape => screenWidth > screenHeight;

  /// Get device pixel ratio
  static double get devicePixelRatio => _mediaQueryData.devicePixelRatio;

  /// Get status bar height
  static double get statusBarHeight => _mediaQueryData.padding.top;

  /// Get bottom padding (for devices with home indicator)
  static double get bottomPadding => _mediaQueryData.padding.bottom;
}
