import 'package:flutter/material.dart';

import '../colors/app_colors.dart';

class CustomTheme{
  static const appColors = AppColors();

  CustomTheme._();

  static ThemeData get lightTheme {
      return ThemeData(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(),
        primarySwatch: appColors.getMaterialColor,
        fontFamily: "AvenirNext",
         textTheme: const TextTheme(
      bodyText1: TextStyle(
        fontSize: 36,
      ),
      bodyText2: TextStyle(
                fontSize: 14,
      ),
    ).apply(
      bodyColor: appColors.white, 
      displayColor: appColors.white, 
    ),
      );
  }
}