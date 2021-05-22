import 'dart:developer';

import 'package:example_project/model/user_model.dart';
import 'package:example_project/services/app_database.dart';

class UserService {
  static UserModel currentUser;

  static Future<UserModel> fetchUser(int id) async {
    log('fetchUser(id: $id)', name: 'UserService', level: 0, time: DateTime.now());
    currentUser = await AppDatabase.database
        .query(
      'User',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    )
        .then(
      (serializedData) async {
        if (serializedData.isEmpty) return null;
        var data = Map.of(serializedData.first);
        data.addEntries([
          MapEntry(
            'cartProducts',
            Map.fromEntries((await AppDatabase.database.rawQuery('''
              SELECT P.*, amount
              FROM UserProductCart
              LEFT JOIN Product P on P.id = productId
              WHERE userId = $id
            ''')).map((entry) => MapEntry(entry, entry['amount']))),
          ),
          MapEntry(
            'favoriteProducts',
            await AppDatabase.database.rawQuery('''
              SELECT P.*
              FROM UserProductFavorite
              LEFT JOIN Product P on P.id = productId
              WHERE userId = $id
            '''),
          ),
        ]);
        return UserModel.fromJson(data);
      },
    );
    return currentUser;
  }

  static Future<UserModel> login(String username, String password) async {
    log('login(username: $username, password: $password)', name: 'UserService', level: 0, time: DateTime.now());
    var serializedData = (await AppDatabase.database.query(
      'User',
      columns: ['id'],
      where: 'username = ? and password = ?',
      whereArgs: [username, password],
      limit: 1,
    ));

    if (serializedData.isEmpty) return null;

    final id = serializedData.first['id'];
    return await fetchUser(id);
  }

  static Future<bool> register(String username, String password) async {
    log('register(username: $username, password: $password)', name: 'UserService', level: 0, time: DateTime.now());
    var serializedData = await AppDatabase.database.query(
      'User',
      where: 'username = ? and password = ?',
      whereArgs: [username, password],
      limit: 1,
    );
    if (serializedData.isEmpty) {
      return null !=
          await AppDatabase.database.insert(
            'User',
            {
              'username': username,
              'password': password,
            },
          );
    } else
      return false;
  }

  static Future<void> logout() async {
    currentUser = null;
  }

  static Future<bool> addProductToFavorites(int userId, int productId) async {
    log('addProductToFavorites(userId: $userId, productId: $productId)', name: 'UserService', level: 0, time: DateTime.now());
    return true;
  }

  static Future<bool> removeProductFromFavorites(int userId, int productId) async {
    log('removeProductFromFavorites(userId: $userId, productId: $productId)', name: 'UserService', level: 0, time: DateTime.now());
    return true;
  }
}
