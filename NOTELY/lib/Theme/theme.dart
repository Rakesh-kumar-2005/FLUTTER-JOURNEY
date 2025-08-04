import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.white, // BackGround color
    primary: Colors.black, // text color
    secondary: Colors.red, // other color
    onSecondary: Colors.black26, // Divider color with low opacity
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.black, // background color
    primary: Colors.white, // text color
    secondary: Colors.red, // other colors
    onSecondary: Colors.white30, // Divider color with low opacity
  ),
);
