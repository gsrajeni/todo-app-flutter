// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MyDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorMyDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$MyDatabaseBuilder databaseBuilder(String name) =>
      _$MyDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$MyDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$MyDatabaseBuilder(null);
}

class _$MyDatabaseBuilder {
  _$MyDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$MyDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$MyDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<MyDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$MyDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$MyDatabase extends MyDatabase {
  _$MyDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TodoDao _todoDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TodoDataModel` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `description` TEXT, `title` TEXT, `timestamp` INTEGER, `isDeleted` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TodoDao get todoDao {
    return _todoDaoInstance ??= _$TodoDao(database, changeListener);
  }
}

class _$TodoDao extends TodoDao {
  _$TodoDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _todoDataModelInsertionAdapter = InsertionAdapter(
            database,
            'TodoDataModel',
            (TodoDataModel item) => <String, dynamic>{
                  'id': item.id,
                  'description': item.description,
                  'title': item.title,
                  'timestamp': _dateTimeConverter.encode(item.timestamp),
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted ? 1 : 0)
                },
            changeListener),
        _todoDataModelDeletionAdapter = DeletionAdapter(
            database,
            'TodoDataModel',
            ['id'],
            (TodoDataModel item) => <String, dynamic>{
                  'id': item.id,
                  'description': item.description,
                  'title': item.title,
                  'timestamp': _dateTimeConverter.encode(item.timestamp),
                  'isDeleted':
                      item.isDeleted == null ? null : (item.isDeleted ? 1 : 0)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TodoDataModel> _todoDataModelInsertionAdapter;

  final DeletionAdapter<TodoDataModel> _todoDataModelDeletionAdapter;

  @override
  Future<List<TodoDataModel>> findAllTodos() async {
    return _queryAdapter.queryList(
        'SELECT * FROM TodoDataModel ORDER BY id DESC',
        mapper: (Map<String, dynamic> row) => TodoDataModel(
            id: row['id'] as int,
            description: row['description'] as String,
            title: row['title'] as String,
            timestamp: _dateTimeConverter.decode(row['timestamp'] as int),
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0));
  }

  @override
  Stream<TodoDataModel> findTodosById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM TodoDataModel WHERE id = ?',
        arguments: <dynamic>[id],
        queryableName: 'TodoDataModel',
        isView: false,
        mapper: (Map<String, dynamic> row) => TodoDataModel(
            id: row['id'] as int,
            description: row['description'] as String,
            title: row['title'] as String,
            timestamp: _dateTimeConverter.decode(row['timestamp'] as int),
            isDeleted: row['isDeleted'] == null
                ? null
                : (row['isDeleted'] as int) != 0));
  }

  @override
  Future<void> insertTodo(TodoDataModel todo) async {
    await _todoDataModelInsertionAdapter.insert(todo, OnConflictStrategy.abort);
  }

  @override
  Future<void> removeTodoById(TodoDataModel todo) async {
    await _todoDataModelDeletionAdapter.delete(todo);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
