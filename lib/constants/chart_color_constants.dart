import 'package:flutter/material.dart';

class ChartColorConstants {
  static const List<MaterialColor> colors = [
    Colors.red,
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.grey,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.cyan,
    Colors.brown,
  ];

  final Map<int, MaterialColor> _colorMap = {};

  MaterialColor getColorForPension(int id) {
    MaterialColor? color = _colorMap[id];

    if (color == null) {
      color = colors[_colorMap.length % colors.length];
      _colorMap[id] = color;
    }

    return color;
  }
}
