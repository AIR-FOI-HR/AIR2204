import 'package:flutter/material.dart';
import '../../constants/my_colors.dart';

class MyIconTextLabel extends StatelessWidget {
  const MyIconTextLabel({
    super.key,
    required this.icon,
    required this.textStyle,
    required this.text,
    this.iconColor = MyColors.color9B9A9B,
    this.spacing = 5,
    this.iconSize = 14,
  });

  final String text;
  final IconData icon;
  final double spacing, iconSize;
  final Color iconColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
        Text(
          text,
          style: textStyle,
        ),
      ],
    );
  }
}
