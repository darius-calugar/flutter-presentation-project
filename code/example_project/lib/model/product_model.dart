import 'dart:typed_data';

import 'package:example_project/model/category_model.dart';

class ProductModel {
  final int id;
  final String name;
  final String description;
  final Uint8List imageBytes;
  final int price;
  final int sale;
  final int stock;
  final CategoryModel category;
  double relevance;

  ProductModel(
    this.id,
    this.name,
    this.description,
    this.imageBytes,
    this.price,
    this.sale,
    this.stock,
    this.category, {
    this.relevance,
  })  : assert(name.isNotEmpty),
        assert(description.isNotEmpty),
        assert(price > 0),
        assert(sale >= 0 && sale < 100),
        assert(stock >= 0) {
    if (relevance == null) relevance = sale.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageBytes': imageBytes,
      'price': price,
      'sale': sale,
      'stock': stock,
      'category': category?.toJson(),
      'relevance': relevance,
    }..removeWhere((key, value) => value == null);
  }

  static ProductModel fromJson(Map<String, dynamic> json) {
    return ProductModel(
      json['id'],
      json['name'],
      json['description'],
      json['imageBytes'],
      json['price'],
      json['sale'],
      json['stock'],
      json['category'],
      relevance: json['relevance'],
    );
  }
}
