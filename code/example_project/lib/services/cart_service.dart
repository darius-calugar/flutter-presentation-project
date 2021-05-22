import 'dart:developer';

import 'package:example_project/model/product_model.dart';
import 'package:example_project/services/app_database.dart';

class CartService {
  static Future<Map<ProductModel, int>> getCartProducts(int userId) async {
    log('getCartProducts(userId: $userId)', name: 'CartService', level: 0, time: DateTime.now());
    return Map.fromEntries((await AppDatabase.database.rawQuery('''
      select P.*, amount
      from UserProductCart
      left join Product P on P.id = productId
      where userId = $userId
    ''')).map((e) => MapEntry(ProductModel.fromJson(e), e['amount'])));
  }

  static Future<int> getCartProductAmount(int userId, int productId) async {
    log('getCartProductAmount(userId: $userId, productId: $productId)', name: 'CartService', level: 0, time: DateTime.now());
    return AppDatabase.database.query(
      'UserProductCart',
      where: 'userId = ? and productId = ?',
      whereArgs: [userId, productId],
    ).then((value) => value.firstWhere((element) => true, orElse: () => Map<String, dynamic>())['amount'] ?? 0);
  }

  static Future<bool> addProductToCart(int userId, int productId) async {
    log('addProductToCart(userId: $userId, productId: $productId)', name: 'CartService', level: 0, time: DateTime.now());
    int amount = (await AppDatabase.database.query(
          'UserProductCart',
          where: 'userId = ? and productId = ?',
          whereArgs: [userId, productId],
        ))
            .firstWhere((element) => true, orElse: () => Map<String, dynamic>())['amount'] ??
        0;

    if (amount > 0) {
      int id = await AppDatabase.database.update(
        'UserProductCart',
        {
          'amount': amount + 1,
        },
        where: 'userId = ? and productId = ?',
        whereArgs: [userId, productId],
      );
      return id != null;
    } else {
      int id = await AppDatabase.database.insert(
        'UserProductCart',
        {
          'userId': userId,
          'productId': productId,
          'amount': 1,
        },
      );
      return id != null;
    }
  }

  static Future<bool> removeProductFromCart(int userId, int productId) async {
    log('removeProductFromCart(userId: $userId, productId: $productId)', name: 'CartService', level: 0, time: DateTime.now());
    int amount = (await AppDatabase.database.query(
          'UserProductCart',
          where: 'userId = ? and productId = ?',
          whereArgs: [userId, productId],
        ))
            .firstWhere((element) => true, orElse: () => Map<String, dynamic>())['amount'] ??
        0;

    if (amount > 1) {
      int id = await AppDatabase.database.update(
        'UserProductCart',
        {
          'amount': amount - 1,
        },
        where: 'userId = ? and productId = ?',
        whereArgs: [userId, productId],
      );
      return id != null;
    } else {
      int id = await AppDatabase.database.delete(
        'UserProductCart',
        where: 'userId = ? and productId = ?',
        whereArgs: [userId, productId],
      );
      return id != null;
    }
  }

  static Future<bool> submitOrder(int userId) {
    log('submitOrder(userId: $userId)', name: 'CartService', level: 0, time: DateTime.now());
    AppDatabase.database.delete(
      'UserProductCart',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return Future.delayed(Duration(seconds: 1), () => true);
  }
}
