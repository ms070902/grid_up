import 'package:flutter/material.dart';
import 'package:nexus/extensions/string/remove_all.dart';

///convert #ff0000 0xffff to flutter color
extension AsHtmlColorToColor on String {
  Color htmlColorToColor() => Color(int.parse(
        removeAll(['0x', '#']).padLeft(8, 'ff'),
        radix: 16,
      ));
}
