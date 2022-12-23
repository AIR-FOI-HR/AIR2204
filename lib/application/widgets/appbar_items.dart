import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

Widget notificationBell() {
  return Padding(
    padding: const EdgeInsets.only(right: 8),
    child: InkWell(
      highlightColor: MyColors.color040306,
      splashColor: MyColors.color3A3A3A,
      radius: 50,
      borderRadius: BorderRadius.circular(50),
      onTap: () => {
        // implement notification screen
      },
      child: const SizedBox(width: 50, child: Icon(Icons.notifications, size: 25)),
    ),
  );
}

Widget backArrow(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 25),
    child: IconButton(
      icon: const Icon(
        Icons.arrow_back,
        size: 25,
        color: MyColors.color9B9A9B,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),
  );
}

Widget appBarGradient() {
  return Container(
    decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: <Color>[Color.fromARGB(120, 119, 45, 255), Color.fromARGB(80, 0, 0, 0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter)),
  );
}
