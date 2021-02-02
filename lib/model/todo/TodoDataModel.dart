import 'package:floor/floor.dart';


@entity
class TodoDataModel{
  @PrimaryKey(autoGenerate: true)
  int id;
  String description;
  String title;
  DateTime timestamp;
  bool isDeleted;

  TodoDataModel(
      {this.id,
      this.description,
      this.title,
      this.timestamp,
      this.isDeleted});
}