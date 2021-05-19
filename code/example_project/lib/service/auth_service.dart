import 'package:example_project/model/user_model.dart';
import 'package:example_project/service/app_database.dart';

class AuthService {
  static Future<UserModel> login(String username, String password) async {
    var maps = await AppDatabase.database.query(
      'User',
      where: 'username = ? and password = ?',
      whereArgs: [username, password],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      var user = UserModel(1, maps.first['username'], maps.first['password']);
      AppDatabase.currentUser = user;
      return user;
    } else
      return null;
  }

  static Future<bool> register(String username, String password) async {
    var maps = await AppDatabase.database.query(
      'User',
      where: 'username = ? and password = ?',
      whereArgs: [username, password],
      limit: 1,
    );
    if (maps.isEmpty) {
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

  static void logout() {
    AppDatabase.currentUser = null;
  }

  static UserModel currentUser() {
    return AppDatabase.currentUser;
  }
}
