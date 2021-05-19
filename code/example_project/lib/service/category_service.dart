import 'package:example_project/model/category_model.dart';
import 'package:flutter/material.dart';

class CategoryService {
  static Future<List<CategoryModel>> getCategories() {
    return Future.delayed(
      Duration(seconds: 1),
      () => <CategoryModel>[
        CategoryModel(
          2,
          'Sneakers',
          AssetImage('assets/images/categories/sneakers.png'),
          [],
        ),
        CategoryModel(
          1,
          'Sport',
          AssetImage('assets/images/categories/sport.png'),
          [],
        ),
        CategoryModel(
          3,
          'Heels',
          AssetImage('assets/images/categories/heels.png'),
          [],
        ),
        CategoryModel(
          4,
          'Leather',
          AssetImage('assets/images/categories/leather.png'),
          [],
        ),
      ],
    );
  }
}
