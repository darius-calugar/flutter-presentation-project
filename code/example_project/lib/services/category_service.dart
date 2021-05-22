import 'dart:developer';

import 'package:example_project/model/category_model.dart';
import 'package:example_project/services/app_database.dart';

class CategoryService {
  static Future<List<CategoryModel>> getCategories() async {
    log('getCategories()', name: 'CategoryService', level: 0, time: DateTime.now());
    return (await AppDatabase.database.query(
      'Category',
    ))
        .map<CategoryModel>((json) => CategoryModel.fromJson(json))
        .toList();
  }
}
