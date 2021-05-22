import 'dart:developer';

import 'package:example_project/model/product_model.dart';
import 'package:example_project/services/app_database.dart';

class FavoriteService {
  static Future<List<ProductModel>> getFavoriteProducts(int userId) async {
    log('getFavoriteProducts(userId: $userId)', name: 'FavoriteService', level: 0, time: DateTime.now());
    return (await AppDatabase.database.rawQuery('''
      select P.*
      from UserProductFavorite
      left join Product P on P.id = productId
      where userId = $userId
    ''')).map((element) => ProductModel.fromJson(element)).toList();
  }

  static Future<bool> isProductFavorite(int userId, int productId) async {
    log('isProductFavorite(userId: $userId, productId: $productId)', name: 'FavoriteService', level: 0, time: DateTime.now());
    AppDatabase.database.query(
      'UserProductFavorite',
      where: 'userId = ? and productId = ?',
      whereArgs: [userId, productId],
    ).then((value) => print(value));
    return AppDatabase.database.query(
      'UserProductFavorite',
      where: 'userId = ? and productId = ?',
      whereArgs: [userId, productId],
    ).then((value) => value.isNotEmpty);
  }

  static Future<bool> addProductToFavorites(int userId, int productId) async {
    log('addProductToFavorites(userId: $userId, productId: $productId)', name: 'FavoriteService', level: 0, time: DateTime.now());
    return AppDatabase.database.insert(
      'UserProductFavorite',
      {
        'userId': userId,
        'productId': productId,
      },
    ).then((id) => id != null);
  }

  static Future<bool> removeProductFromFavorites(int userId, int productId) async {
    log('removeProductToFavorites(userId: $userId, productId: $productId)', name: 'FavoriteService', level: 0, time: DateTime.now());
    return AppDatabase.database.delete(
      'UserProductFavorite',
      where: 'userId = ? and productId = ?',
      whereArgs: [userId, productId],
    ).then((id) => id != null);
  }
}
