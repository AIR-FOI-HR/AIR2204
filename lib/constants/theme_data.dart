import 'package:deep_conference/constants/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTheme {
  static ThemeData deepTheme = ThemeData(
    fontFamily: 'Montserrat',
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: MyColors.color040306,
    cardColor: MyColors.color040306,
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: MyColors.colorFFFFFF),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: MyColors.colorFFFFFF,
      ),
      centerTitle: true,
    ),
    iconTheme: const IconThemeData(color: MyColors.colorFFFFFF),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 24, color: MyColors.colorFFFFFF, fontWeight: FontWeight.w700), //appbar title text
      titleMedium: TextStyle(
          fontSize: 14,
          color: MyColors.colorFFFFFF,
          fontWeight: FontWeight.w700), //medium title text (date filtration buttons)
      labelMedium: TextStyle(fontSize: 14, color: MyColors.color9B9A9B, fontWeight: FontWeight.w700), //medium gray text
      bodyLarge: TextStyle(fontSize: 16, color: MyColors.colorFFFFFF, fontWeight: FontWeight.w700),
      bodyMedium: TextStyle(fontSize: 14, color: MyColors.colorFFFFFF, fontWeight: FontWeight.w600),
    ),
  );
}
