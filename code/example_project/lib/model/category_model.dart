import 'dart:typed_data';

import 'package:example_project/model/product_model.dart';

class CategoryModel {
  final int id;
  final String name;
  final Uint8List imageBytes;
  final List<ProductModel> products;

  CategoryModel(
    this.id,
    this.name,
    this.imageBytes,
    this.products,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageBytes': imageBytes,
      'products': products.map((e) => e?.toJson()),
    }..removeWhere((key, value) => value == null);
  }

  static CategoryModel fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      json['id'],
      json['name'],
      json['imageBytes'],
      (json['products'] as Map<String, dynamic>)?.values?.map((e) => ProductModel.fromJson(e))?.toList() ?? [],
    );
  }
}
