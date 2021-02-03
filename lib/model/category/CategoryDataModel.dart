import 'dart:ui';

import 'package:floor/floor.dart';

@entity
class CategoryDataModel{
  @PrimaryKey(autoGenerate: true)
  int id;
  String name;
  Color color;

  CategoryDataModel({this.id, this.name, this.color});
}