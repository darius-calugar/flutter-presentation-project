class UserModel {
  final int id;
  final String username;
  final String password;

  UserModel(
    this.id,
    this.username,
    this.password,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
    }..removeWhere((key, value) => value == null);
  }

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['id'],
      json['username'],
      json['password'],
    );
  }
}
