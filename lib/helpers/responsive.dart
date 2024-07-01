import 'package:flutter/material.dart';

/// Helper class to determine the screen size
class Responsive  {
  static const double mobileWidth = 1024;
  static const double tabletWidth = 1280;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletWidth &&
      MediaQuery.of(context).size.width >= mobileWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletWidth;
}
