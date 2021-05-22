import 'package:example_project/model/product_model.dart';

class UserModel {
  final int id;
  final String username;
  final String password;
  final Map<ProductModel, int> cartProducts;
  final List<ProductModel> favoriteProducts;

  UserModel(this.id,
      this.username,
      this.password,
      this.cartProducts,
      this.favoriteProducts,);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'cartProducts': cartProducts?.map((product, amount) => MapEntry(product.toJson(), amount)),
      'favoriteProducts': favoriteProducts?.map((e) => e.toJson())?.toList(),
    }
      ..removeWhere((key, value) => value == null);
  }

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['id'],
      json['username'],
      json['password'],
      (json['cartProducts'] as Map)?.cast<Map<String, dynamic>, int>()?.map((key, value) => MapEntry(ProductModel.fromJson(key), value)) ?? {},
      (json['favoriteProducts'] as List<Map<String, dynamic>>)?.map((e) => ProductModel.fromJson(e))?.toList() ?? List(),
    );
  }
}
