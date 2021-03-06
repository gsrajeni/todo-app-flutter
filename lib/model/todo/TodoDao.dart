// dao/person_dao.dart

import 'package:floor/floor.dart';
import 'package:todo/model/todo/TodoDataModel.dart';

@dao
abstract class TodoDao {
  @Query('SELECT * FROM TodoDataModel ORDER BY id DESC')
  Future<List<TodoDataModel>> findAllTodos();

  @Query('SELECT * FROM TodoDataModel WHERE id = :id')
  Stream<TodoDataModel> findTodosById(int id);

  @insert
  Future<void> insertTodo(TodoDataModel todo);

  @delete
  Future<void> removeTodoById(TodoDataModel todo);

  @update
  Future<void> updateTodo(TodoDataModel todo);

  @Query("SELECT * FROM TodoDataModel WHERE timestamp >= :fromDate AND timestamp <= :toDate ORDER BY timestamp DESC")
  Future<List<TodoDataModel>> findAllTodosByDate(int fromDate, int toDate);
}