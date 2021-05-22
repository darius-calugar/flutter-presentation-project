import 'package:example_project/model/category_model.dart';
import 'package:example_project/model/product_model.dart';
import 'package:example_project/model/user_model.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database database;

  static Future<void> initDatabase() async {
    String path = join(await getDatabasesPath(), 'database.db');

    print('Application database created at $path');
    deleteDatabase(path);
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        database.execute('''
            CREATE TABLE User (
              id INTEGER PRIMARY KEY,
              username TEXT,
              password TEXT
            )''');

        database.execute('''
            CREATE TABLE Category (
              id INTEGER PRIMARY KEY,
              name TEXT,
              imageBytes BLOB
            )''');

        database.execute('''
            CREATE TABLE Product (
              id INTEGER PRIMARY KEY,
              name TEXT,
              description TEXT,
              imageBytes BLOB,
              price INTEGER,
              sale INTEGER,
              stock INTEGER,
              relevance REAL,
              categoryId INTEGER REFERENCES Category(id)
            )''');

        database.execute(''' 
            CREATE TABLE UserProductCart (
              userId INTEGER REFERENCES User(id),
              productId INTEGER REFERENCES Product(id),
              amount INTEGER,
              PRIMARY KEY (userId, productId)
        )''');

        database.execute(''' 
            CREATE TABLE UserProductFavorite (
              userId INTEGER REFERENCES User(id),
              productId INTEGER REFERENCES Product(id),
              PRIMARY KEY (userId, productId)
        )''');

        <UserModel>[
          UserModel(null, 'root', 'pass'),
          UserModel(null, 'Guest', 'pass'),
        ].forEach((user) {
          database.insert('User', user.toJson());
        });

        <CategoryModel>[
          CategoryModel(1, 'Sneakers', (await rootBundle.load('assets/db/categories/sneakers.jpg')).buffer.asUint8List()),
          CategoryModel(2, 'Sport', (await rootBundle.load('assets/db/categories/sport.jpg')).buffer.asUint8List()),
          CategoryModel(3, 'Heels', (await rootBundle.load('assets/db/categories/heels.jpg')).buffer.asUint8List()),
          CategoryModel(null, 'Leather', (await rootBundle.load('assets/db/categories/leather.jpg')).buffer.asUint8List()),
        ].forEach((category) async {
          await database.insert('Category', category.toJson());
        });

        <ProductModel>[
          ProductModel(null, 'Debug Product 1', 'description', null, 19999, 0, 4, 1),
          ProductModel(null, 'Debug Product 2', 'description', null, 29999, 20, 17, 1),
          ProductModel(null, 'Debug Product 3', 'description', null, 8999, 30, 0, 1),
          ProductModel(null, 'Debug Product 4', 'description', null, 7999, 20, 0, 1),
          ProductModel(null, 'Debug Product 5', 'description', null, 12999, 50, 45, 1),
          ProductModel(null, 'Debug Product 6', 'description', null, 49999, 15, 21, 1),
          ProductModel(null, 'Debug Product 7', 'description', null, 46999, 0, 64, 1),
        ].forEach((product) async {
          await database.insert('Product', product.toJson());
        });
      },
    );
    return database;
  }
}
