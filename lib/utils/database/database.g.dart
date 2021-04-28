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

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

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
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
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
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PasswordDao _passwordDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `Password` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `login` TEXT, `value` TEXT, `url` TEXT, `comment` TEXT, `color` INTEGER, `updated` INTEGER, `isFavorite` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PasswordDao get passwordDao {
    return _passwordDaoInstance ??= _$PasswordDao(database, changeListener);
  }
}

class _$PasswordDao extends PasswordDao {
  _$PasswordDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _passwordInsertionAdapter = InsertionAdapter(
            database,
            'Password',
            (Password item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'login': item.login,
                  'value': item.value,
                  'url': item.url,
                  'comment': item.comment,
                  'color': _colorConverter.encode(item.color),
                  'updated': _dateTimeConverter.encode(item.updated),
                  'isFavorite':
                      item.isFavorite == null ? null : (item.isFavorite ? 1 : 0)
                },
            changeListener),
        _passwordUpdateAdapter = UpdateAdapter(
            database,
            'Password',
            ['id'],
            (Password item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'login': item.login,
                  'value': item.value,
                  'url': item.url,
                  'comment': item.comment,
                  'color': _colorConverter.encode(item.color),
                  'updated': _dateTimeConverter.encode(item.updated),
                  'isFavorite':
                      item.isFavorite == null ? null : (item.isFavorite ? 1 : 0)
                },
            changeListener),
        _passwordDeletionAdapter = DeletionAdapter(
            database,
            'Password',
            ['id'],
            (Password item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'login': item.login,
                  'value': item.value,
                  'url': item.url,
                  'comment': item.comment,
                  'color': _colorConverter.encode(item.color),
                  'updated': _dateTimeConverter.encode(item.updated),
                  'isFavorite':
                      item.isFavorite == null ? null : (item.isFavorite ? 1 : 0)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Password> _passwordInsertionAdapter;

  final UpdateAdapter<Password> _passwordUpdateAdapter;

  final DeletionAdapter<Password> _passwordDeletionAdapter;

  @override
  Future<List<Password>> findAllPasswords() async {
    return _queryAdapter.queryList('SELECT * FROM Password',
        mapper: (Map<String, dynamic> row) => Password(
            row['name'] as String,
            row['login'] as String,
            row['value'] as String,
            row['url'] as String,
            row['comment'] as String,
            _dateTimeConverter.decode(row['updated'] as int),
            _colorConverter.decode(row['color'] as int),
            row['isFavorite'] == null ? null : (row['isFavorite'] as int) != 0,
            row['id'] as int));
  }

  @override
  Stream<Password> findPasswordById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Password WHERE id = ?',
        arguments: <dynamic>[id],
        queryableName: 'Password',
        isView: false,
        mapper: (Map<String, dynamic> row) => Password(
            row['name'] as String,
            row['login'] as String,
            row['value'] as String,
            row['url'] as String,
            row['comment'] as String,
            _dateTimeConverter.decode(row['updated'] as int),
            _colorConverter.decode(row['color'] as int),
            row['isFavorite'] == null ? null : (row['isFavorite'] as int) != 0,
            row['id'] as int));
  }

  @override
  Future<void> insertPassword(Password password) async {
    await _passwordInsertionAdapter.insert(password, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePassword(Password password) async {
    await _passwordUpdateAdapter.update(password, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePassword(Password password) async {
    await _passwordDeletionAdapter.delete(password);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _colorConverter = ColorConverter();