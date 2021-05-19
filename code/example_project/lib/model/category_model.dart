import 'package:example_project/model/product_model.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final int id;
  final String name;
  final ImageProvider imageProvider;
  final List<ProductModel> products;

  CategoryModel(this.id, this.name, this.imageProvider, this.products);
}
