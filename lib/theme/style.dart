import 'package:flutter/material.dart';

Color mainColor = Colors.red[600];

ThemeData appTheme() {
  return ThemeData(
    primaryColor: mainColor,
    primaryTextTheme: TextTheme(
      headline1: TextStyle(color: Color.fromRGBO(200, 200, 200, 1)),
      headline2: TextStyle(color: Colors.white),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(
        color: Color.fromRGBO(200, 200, 200, 1),
        fontWeight: FontWeight.normal,
      ),
    ),
    accentColor: mainColor,
    hintColor: Color.fromRGBO(200, 200, 200, 1),
    dividerColor: Colors.white,
    buttonColor: Colors.white,
    scaffoldBackgroundColor: Color.fromRGBO(245, 245, 245, 1),
    iconTheme: IconThemeData(
      color: Colors.black45,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: mainColor,
      textTheme: ButtonTextTheme.normal,
    ),
    // canvasColor: Colors.black,
    brightness: Brightness.light,
  );
}
