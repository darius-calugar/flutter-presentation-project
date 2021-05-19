import 'package:flutter/material.dart';

class UserModel {
  final int id;
  final String username;
  final ImageProvider profileImage;

  UserModel(
    this.id,
    this.username,
    this.profileImage,
  );
}
