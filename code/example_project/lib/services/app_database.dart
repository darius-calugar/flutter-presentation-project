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
          CategoryModel(1, 'Laptops', (await rootBundle.load('assets/db/categories/laptop.jpg')).buffer.asUint8List()),
          CategoryModel(2, 'Smartphones', (await rootBundle.load('assets/db/categories/smartphone.jpg')).buffer.asUint8List()),
          CategoryModel(3, 'Mice', (await rootBundle.load('assets/db/categories/mouse.jpg')).buffer.asUint8List()),
          CategoryModel(4, 'Keyboards', (await rootBundle.load('assets/db/categories/keyboard.jpg')).buffer.asUint8List()),
        ].forEach((category) async {
          await database.insert('Category', category.toJson());
        });

        <ProductModel>[
          // Laptops
          ProductModel(null, "Laptop Lenovo 15.6'' IdeaPad 3 15IML05", "FHD, Processor Intel® Celeron® 5205U (2M Cache, 1.90 GHz), 4GB DDR4, 256GB SSD, GMA UHD, No OS, Platinum Grey",
              (await rootBundle.load('assets/db/products/laptop_1.jpg')).buffer.asUint8List(), 139899, 10, 10, 1),
          ProductModel(null, "Laptop Lenovo 15.6'' ThinkBook 15 G2 ARE", "FHD, Processor AMD Ryzen™ 5 4500U (8M Cache, up to 4.0 GHz), 8GB DDR4, 256GB SSD, Radeon, No OS, Mineral Gray",
              (await rootBundle.load('assets/db/products/laptop_2.jpg')).buffer.asUint8List(), 259899, 0, 5, 1),
          ProductModel(null, "Gaming Laptop HP 15.6'' Pavilion 15-ec0054nq", "FHD, Processor AMD Ryzen™ 5 3550H (4M Cache, up to 3.70 GHz), 8GB DDR4, 512GB SSD, GeForce GTX 1650 4GB, Free DOS, Shadow Black",
              (await rootBundle.load('assets/db/products/laptop_3.jpg')).buffer.asUint8List(), 289899, 15, 11, 1),
          ProductModel(null, "Laptop DELL 15.6'' Vostro 3500", "FHD, Processor Intel® Core™ i5-1135G7 (8M Cache, up to 4.20 GHz), 8GB DDR4, 256GB SSD, Intel Iris Xe, Win 10 Pro, 3Yr BOS",
              (await rootBundle.load('assets/db/products/laptop_4.jpg')).buffer.asUint8List(), 339899, 0, 7, 1),
          // Smartphones
          ProductModel(null, "Smartphone Xiaomi Poco M3", "Snapdragon Octa Core, 64GB, 4GB RAM, Dual SIM, 4G, 48MP AI Triple Camera, Dual speakers, Battery 6000 mAh, Cool Blue",
              (await rootBundle.load('assets/db/products/smartphone_1.jpg')).buffer.asUint8List(), 62999, 10, 14, 2),
          ProductModel(null, "Smartphone Motorola Moto G8 Power Lite", "Octa Core, 64GB, 4GB RAM, Dual SIM, 4G, 48MP 4 Cameras, Battery 5000 mAh, Arctic Blue",
              (await rootBundle.load('assets/db/products/smartphone_2.jpg')).buffer.asUint8List(), 56899, 0, 20, 2),
          // Mice
          ProductModel(null, "Mouse Logitech B100", "Optical USB, 800 dpi, Black", (await rootBundle.load('assets/db/products/mouse_1.jpg')).buffer.asUint8List(), 3999, 0, 64, 3),
          ProductModel(null, "Mouse ASUS WT425", "Wireless, 1600 dpi, Blue", (await rootBundle.load('assets/db/products/mouse_2.jpg')).buffer.asUint8List(), 4999, 50, 20, 3),
          ProductModel(null, "Gaming Mouse Logitech G102", "Lightsync RGB, Optical USB, 8000 dpi, Black", (await rootBundle.load('assets/db/products/mouse_3.jpg')).buffer.asUint8List(), 10999, 0, 15, 3),
          // Keyboards
          ProductModel(null, "Gaming keyboard Logitech G413", "LED Mechanical, Silver White", (await rootBundle.load('assets/db/products/keyboard_1.jpg')).buffer.asUint8List(), 39999, 10, 13, 4),
          ProductModel(null, "Gaming Keyboard Logitech G Pro GX", "LED Mechanical, Silver White", (await rootBundle.load('assets/db/products/keyboard_2.jpg')).buffer.asUint8List(), 59999, 0, 25, 4),
          ProductModel(null, "Keyboard Microsoft All-in-One Media", "Track-pad, 10m wireless, 2.4 GHz frequency range", (await rootBundle.load('assets/db/products/keyboard_3.jpg')).buffer.asUint8List(), 15999, 0, 43, 4),
        ].forEach((product) async {
          await database.insert('Product', product.toJson());
        });
      },
    );
    return database;
  }
}
