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
              relevance REAL,
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
              ProductModel(null, 'Debug Product 1', 'description', (await rootBundle.load('assets/db/categories/sneakers.jpg')).buffer.asUint8List(), 19999, 0, 4, null),
              ProductModel(null, 'Debug Product 2', 'description', (await rootBundle.load('assets/db/categories/sneakers.jpg')).buffer.asUint8List(), 29999, 20, 17, null),
              ProductModel(null, 'Debug Product 3', 'description', (await rootBundle.load('assets/db/categories/sneakers.jpg')).buffer.asUint8List(), 8999, 0, 0, null),
              ProductModel(null, 'Debug Product 4', 'description', (await rootBundle.load('assets/db/categories/sneakers.jpg')).buffer.asUint8List(), 7999, 0, 0, null),
              ProductModel(null, 'Debug Product 5', 'description', (await rootBundle.load('assets/db/categories/sneakers.jpg')).buffer.asUint8List(), 12999, 50, 45, null),
              ProductModel(null, 'Debug Product 6', 'description', (await rootBundle.load('assets/db/categories/sneakers.jpg')).buffer.asUint8List(), 49999, 15, 21, null),
              ProductModel(null, 'Debug Product 7', 'description', (await rootBundle.load('assets/db/categories/sneakers.jpg')).buffer.asUint8List(), 46999, 70, 64, null),
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
