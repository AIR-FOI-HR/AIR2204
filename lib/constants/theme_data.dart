import 'package:deep_conference/constants/my_colors.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData deepTheme = ThemeData(
    fontFamily: 'Montserrat',
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: MyColors.color040306,
    cardColor: MyColors.color040306,
    appBarTheme: const AppBarTheme(
      backgroundColor: MyColors.color040306,
      iconTheme: IconThemeData(
        color: MyColors.colorFFFFFF,
      ),
      centerTitle: true,
      //titleTextStyle: TextStyle(fontSize: 24, color: MyColors.colorFFFFFF, fontFamily: 'Montserrat'),
    ),
    //icontheme does not apply on all icons throughout the app, check why
    iconTheme: const IconThemeData(color: MyColors.colorFFFFFF),
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w700), //appbar title text
      titleMedium: TextStyle(
          fontSize: 14, color: Colors.white, fontWeight: FontWeight.w700), //medium title text (date filtration buttons)
      labelMedium: TextStyle(fontSize: 14, color: Color(0xff9b9a9b), fontWeight: FontWeight.w700), //medium gray text
      bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w700), //big body text with overflow
    ),
  );
}
