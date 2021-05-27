// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PasswordDao? _passwordDaoInstance;

  CategoryDao? _categoryDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
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
            'CREATE TABLE IF NOT EXISTS `Password` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `login` TEXT NOT NULL, `value` TEXT NOT NULL, `url` TEXT, `comment` TEXT, `category` TEXT, `color` INTEGER NOT NULL, `updated` INTEGER NOT NULL, `isFavorite` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Category` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `icon` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PasswordDao get passwordDao {
    return _passwordDaoInstance ??= _$PasswordDao(database, changeListener);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }
}

class _$PasswordDao extends PasswordDao {
  _$PasswordDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _passwordInsertionAdapter = InsertionAdapter(
            database,
            'Password',
            (Password item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'login': item.login,
                  'value': item.value,
                  'url': item.url,
                  'comment': item.comment,
                  'category': _categoryConverter.encode(item.category),
                  'color': _colorConverter.encode(item.color),
                  'updated': _dateTimeConverter.encode(item.updated),
                  'isFavorite': item.isFavorite ? 1 : 0
                }),
        _passwordUpdateAdapter = UpdateAdapter(
            database,
            'Password',
            ['id'],
            (Password item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'login': item.login,
                  'value': item.value,
                  'url': item.url,
                  'comment': item.comment,
                  'category': _categoryConverter.encode(item.category),
                  'color': _colorConverter.encode(item.color),
                  'updated': _dateTimeConverter.encode(item.updated),
                  'isFavorite': item.isFavorite ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Password> _passwordInsertionAdapter;

  final UpdateAdapter<Password> _passwordUpdateAdapter;

  @override
  Future<List<Password>> findAllPasswords() async {
    return _queryAdapter.queryList('SELECT * FROM Password',
        mapper: (Map<String, Object?> row) => Password(
            row['name'] as String,
            row['login'] as String,
            row['value'] as String,
            row['url'] as String?,
            row['comment'] as String?,
            _dateTimeConverter.decode(row['updated'] as int),
            _colorConverter.decode(row['color'] as int),
            _categoryConverter.decode(row['category'] as String?),
            (row['isFavorite'] as int) != 0,
            row['id'] as int?));
  }

  @override
  Future<Password?> findPasswordById(int id) async {
    return _queryAdapter.query('SELECT * FROM Password WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Password(
            row['name'] as String,
            row['login'] as String,
            row['value'] as String,
            row['url'] as String?,
            row['comment'] as String?,
            _dateTimeConverter.decode(row['updated'] as int),
            _colorConverter.decode(row['color'] as int),
            _categoryConverter.decode(row['category'] as String?),
            (row['isFavorite'] as int) != 0,
            row['id'] as int?),
        arguments: [id]);
  }

  @override
  Future<void> deletePassword(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Password WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<int> insertPassword(Password password) {
    return _passwordInsertionAdapter.insertAndReturnId(
        password, OnConflictStrategy.abort);
  }

  @override
  Future<int> updatePassword(Password password) {
    return _passwordUpdateAdapter.updateAndReturnChangedRows(
        password, OnConflictStrategy.abort);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _categoryInsertionAdapter = InsertionAdapter(
            database,
            'Category',
            (Category item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'icon': item.icon
                }),
        _categoryUpdateAdapter = UpdateAdapter(
            database,
            'Category',
            ['id'],
            (Category item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'icon': item.icon
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Category> _categoryInsertionAdapter;

  final UpdateAdapter<Category> _categoryUpdateAdapter;

  @override
  Future<List<Category>> findAllCategories() async {
    return _queryAdapter.queryList('SELECT * FROM Category',
        mapper: (Map<String, Object?> row) => Category(
            row['name'] as String, row['icon'] as int, row['id'] as int?));
  }

  @override
  Future<Category?> findCategoryById(int id) async {
    return _queryAdapter.query('SELECT * FROM Category WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Category(
            row['name'] as String, row['icon'] as int, row['id'] as int?),
        arguments: [id]);
  }

  @override
  Future<Category?> findCategoryByName(String name) async {
    return _queryAdapter.query('SELECT * FROM Category WHERE name = ?1',
        mapper: (Map<String, Object?> row) => Category(
            row['name'] as String, row['icon'] as int, row['id'] as int?),
        arguments: [name]);
  }

  @override
  Future<void> deleteCategory(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Category WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertCategory(Category category) async {
    await _categoryInsertionAdapter.insert(category, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateCategory(Category category) {
    return _categoryUpdateAdapter.updateAndReturnChangedRows(
        category, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _colorConverter = ColorConverter();
final _categoryConverter = CategoryConverter();
