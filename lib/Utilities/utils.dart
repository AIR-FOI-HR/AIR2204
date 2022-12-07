import 'package:flutter/material.dart';

import '../constants/my_colors.dart';

class Utils {
  static showSnackBar(String? text, BuildContext context) {
    if (text == null) return;

    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: MyColors.color772DFF,
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
