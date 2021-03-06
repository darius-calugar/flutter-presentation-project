import 'dart:developer';

import 'package:example_project/model/product_model.dart';
import 'package:example_project/services/app_database.dart';

class ProductService {
  static Future<List<ProductModel>> getProducts({
    int categoryId,
    String searchString,
    String sortField,
    bool ascending = false,
  }) async {
    log('getProducts()', name: 'ProductService', level: 0, time: DateTime.now());
    return (await AppDatabase.database.rawQuery('''
      SELECT *
      FROM Product
      ${(categoryId != null || searchString != null) ? 'WHERE' : ''}
      ${(categoryId != null) ? 'categoryId = $categoryId' : ''}
      ${(categoryId != null && searchString != null) ? 'AND' : ''}
      ${(searchString != null) ? 'name like "%$searchString%"' : ''}
      ORDER BY ${(sortField != null ? '$sortField ${ascending ? 'ASC' : 'DESC'}, ' : '')} relevance DESC;
    ''')).map((json) => ProductModel.fromJson(json)).toList();
  }

  static Future<ProductModel> getProduct(int id) async {
    log('getProduct(id: $id)', name: 'ProductService', level: 0, time: DateTime.now());
    return (await AppDatabase.database.rawQuery('''
      SELECT *
      FROM Product
      where id = $id
    ''')).map((json) => ProductModel.fromJson(json)).first;
  }
}
