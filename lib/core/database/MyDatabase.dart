// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:todo/core/database/typeConverters/DateTimeConverter.dart';
import 'package:todo/model/todo/TodoDao.dart';
import 'package:todo/model/todo/TodoDataModel.dart';


part 'MyDatabase.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [TodoDataModel])
abstract class MyDatabase extends FloorDatabase {
  TodoDao get todoDao;
}