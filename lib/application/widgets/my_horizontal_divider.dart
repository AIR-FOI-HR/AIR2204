import 'package:deep_conference/constants/my_colors.dart';
import 'package:flutter/material.dart';

class MyHorizontalDivider extends StatelessWidget {
  const MyHorizontalDivider(
      {super.key,
      this.color = MyColors.color772DFF,
      this.height = 1,
      this.indent = 40,
      this.endIndent = 40,
      this.thickness = 1});

  final Color color;
  final double height, indent, endIndent, thickness;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      color: color,
      indent: indent,
      endIndent: endIndent,
      thickness: thickness,
    );
  }
}
