import 'package:flutter/material.dart';

import 'color.dart';

class MyTheme {
  static AppBarTheme appBarTheme = AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      textTheme: TextTheme(
          title: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20)));
  static ButtonThemeData buttonThemeData = ButtonThemeData(
    buttonColor: MyColor.buttonColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    minWidth: double.infinity,
    height: 50,
    textTheme: ButtonTextTheme.primary,
  );

  static ThemeData getMyTheme(BuildContext context) {
    return ThemeData(
        dividerColor: MyColor.secondaryColor,
        textTheme: TextTheme(
            subhead: TextStyle(fontSize: 15), body1: TextStyle(fontSize: 18)),
        fontFamily: 'Ambient',
        appBarTheme: appBarTheme,
        disabledColor: MyColor.disabledColor,
        primaryColor: MyColor.primaryColor,
        buttonTheme: buttonThemeData);
  }
}
