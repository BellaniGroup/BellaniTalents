import 'package:flutter/material.dart';

import '../theme/custom_theme.dart';

class CommonStyle {
  static InputDecoration textFieldStyle({String hintTextStr = "", double size = 0}) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(0),
      hintText: hintTextStr,
      filled: true,
      disabledBorder: InputBorder.none,
      hintStyle: TextStyle(fontSize: 12, color: CustomTheme.appColors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: CustomTheme.appColors.primaryColor, width: 0.0),
    ),
    );
  }
}