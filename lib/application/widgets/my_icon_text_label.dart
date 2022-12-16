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
    this.iconSize = 12,
  });

  final String text;
  final IconData icon;
  final double spacing, iconSize;
  final Color iconColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          text,
          style: textStyle,
        ),
      ],
    );
  }
}
