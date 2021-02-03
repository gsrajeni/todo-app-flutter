// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:todo/core/database/typeConverters/ColorConverter.dart';
import 'package:todo/core/database/typeConverters/DateTimeConverter.dart';
import 'package:todo/model/category/CategoryDao.dart';
import 'package:todo/model/category/CategoryDataModel.dart';
import 'package:todo/model/todo/TodoDao.dart';
import 'package:todo/model/todo/TodoDataModel.dart';


part 'MyDatabase.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter, ColorConverter])
@Database(version: 1, entities: [TodoDataModel, CategoryDataModel])
abstract class MyDatabase extends FloorDatabase {
  TodoDao get todoDao;
  CategoryDao get categoryDao;
}