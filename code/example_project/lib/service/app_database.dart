import 'package:example_project/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database database;
  static UserModel currentUser;

  static Future<void> initDatabase() async {
    String path = join(await getDatabasesPath(), 'database.db');

    print('Application database created at $path');
    deleteDatabase(path);
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        database.execute('CREATE TABLE User ('
            'id INTEGER PRIMARY KEY, '
            'username TEXT UNIQUE, '
            'password TEXT)');

        database.execute('CREATE TABLE Category ('
            'id INTEGER PRIMARY KEY, '
            'username TEXT, '
            'password TEXT, '
            'image BLOB)');

        database.execute('CREATE TABLE Product ('
            'id INTEGER PRIMARY KEY, '
            'name TEXT, '
            'description TEXT, '
            'sale REAL, '
            'categoryId REFERENCES Category(id))');

        [
          UserModel(null, 'root', 'pass'),
          UserModel(null, 'Guest', 'pass'),
        ].forEach((user) {
          database.insert(
            'user',
            {
              'username': user.username,
              'password': user.password,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        });
      },
    );
    return database;
  }
}
