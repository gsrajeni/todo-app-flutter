import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color.dart';

class MyStyle {
  static TextStyle titleStyle(Color color) {
    return TextStyle(
        color: color,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold);
  }

  static TextStyle headlineStyle(Color color) {
    return TextStyle(
        color: color,
        fontSize: 24.sp,
        fontWeight: FontWeight.bold);
  }

  static TextStyle bodyStyle(Color color) {
    return TextStyle(
        color: color,
        fontSize: 16.sp,
        fontWeight: FontWeight.normal);
  }

  static TextStyle subtitleStyle(Color color,
      {FontStyle fontStyle, FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(
        color: color,
        fontSize: 13.sp,
        fontWeight: fontWeight,
        fontStyle: fontStyle);
  }

  static TextStyle buttonStyle(Color color) {
    return TextStyle(
        color: color,
        fontSize: 14.sp,
        fontWeight: FontWeight.bold);
  }

  static TextStyle captionStyle(Color color,
      {FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(
        color: color, fontSize: 10.sp, fontWeight: fontWeight);
  }

  static Decoration MyDecoration(
      {Color startColor = MyColor.white,
      Color endColor = MyColor.primaryColor,
      double opacity = 0.8}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: <Color>[
          endColor.withOpacity(opacity),
          startColor,
        ],
      ),
    );
  }

  static Decoration getSelectedGradientDecoration(
      int index, int selected_device) {
    Color startColor = MyColor.white;
    Color endColor = MyColor.primaryColor;
    double opacity = 0.8;
    if (index == selected_device) {
      startColor = MyColor.secondaryColor;
      endColor = MyColor.secondaryColor;
      opacity = 1;
    }
    return MyStyle.MyDecoration(
        startColor: startColor, endColor: endColor, opacity: opacity);
  }

  static BoxDecoration getCardShadow() {
    return BoxDecoration(boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10)
    ]);
  }

  static TextStyle banglaStyle(TextStyle style) {
    return style.copyWith(fontFamily: 'Borshon');
  }

  static double height(double d) {
    return d.h;
  }

  static double width(double d) {
    return d.w;
  }
}
