// dao/person_dao.dart

import 'package:floor/floor.dart';

import 'CategoryDataModel.dart';

@dao
abstract class CategoryDao {
  @Query('SELECT * FROM CategoryDataModel ORDER BY name ASC')
  Future<List<CategoryDataModel>> findAllCategory();

  @Query('SELECT * FROM CategoryDataModel WHERE id = :id')
  Stream<CategoryDataModel> findCategoryById(int id);

  @insert
  Future<void> insertCategory(CategoryDataModel todo);

  @delete
  Future<void> removeCategory(CategoryDataModel todo);

  @update
  Future <void> updateCategory(CategoryDataModel postModel);
}