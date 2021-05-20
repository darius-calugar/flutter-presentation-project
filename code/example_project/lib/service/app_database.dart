import 'package:example_project/model/category_model.dart';
import 'package:example_project/model/product_model.dart';
import 'package:example_project/model/user_model.dart';
import 'package:flutter/services.dart';
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
              categoryId REFERENCES Category(id)
            )''');

        <UserModel>[
          UserModel(null, 'root', 'pass'),
          UserModel(null, 'Guest', 'pass'),
        ].forEach((user) {
          database.insert('User', user.toJson());
        });

        <CategoryModel>[
          CategoryModel(
            null,
            'Sneakers',
            (await rootBundle.load('assets/db/categories/sneakers.jpg')).buffer.asUint8List(),
            <ProductModel>[
              ProductModel(null, 'Debug Product 1', 'description', null, 19999, 0, 999, null),
              ProductModel(null, 'Debug Product 2', 'description', null, 29999, 20, 999, null),
              ProductModel(null, 'Debug Product 3', 'description', null, 8999, 20, 999, null),
              ProductModel(null, 'Debug Product 4', 'description', null, 7999, 20, 999, null),
              ProductModel(null, 'Debug Product 5', 'description', null, 12999, 20, 999, null),
              ProductModel(null, 'Debug Product 6', 'description', null, 49999, 20, 999, null),
              ProductModel(null, 'Debug Product 7', 'description', null, 46999, 20, 999, null),
            ],
          ),
          CategoryModel(
            null,
            'Sport',
            (await rootBundle.load('assets/db/categories/sport.jpg')).buffer.asUint8List(),
            <ProductModel>[
              ProductModel(null, 'Debug Product 3', 'description', null, 39999, 0, 999, null),
            ],
          ),
          CategoryModel(
            null,
            'Heels',
            (await rootBundle.load('assets/db/categories/heels.jpg')).buffer.asUint8List(),
            <ProductModel>[],
          ),
          CategoryModel(
            null,
            'Leather',
            (await rootBundle.load('assets/db/categories/leather.jpg')).buffer.asUint8List(),
            <ProductModel>[],
          ),
        ].forEach((category) async {
          var categoryId = await database.insert('Category', category.toJson()..remove('products'));
          category.products.forEach((product) {
            database.insert('Product', product.toJson()..addAll({'categoryId': categoryId}));
          });
        });
      },
    );
    return database;
  }
}
