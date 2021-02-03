import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

class ColorConverter extends TypeConverter<Color, int> {
  @override
  Color decode(int databaseValue) {
    return databaseValue == null
        ? null
        : Color(databaseValue);
  }

  @override
  int encode(Color value) {
    return value == null ? null : value.value;
  }
}