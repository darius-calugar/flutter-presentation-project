import 'package:example_project/model/user_model.dart';
import 'package:flutter/material.dart';

class AuthService {
  static Future<UserModel> auth(String username, String password) {
    return Future.delayed(
      Duration(seconds: 1),
      () {
        if (username == 'Guest' && password == 'pass')
          return UserModel(1, username, NetworkImage('https://randomuser.me/api/portraits/lego/1.jpg'));
        else
          return Future.error(Error());
      },
    );
  }
}
