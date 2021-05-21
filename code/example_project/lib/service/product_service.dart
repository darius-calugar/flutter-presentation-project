import 'package:example_project/model/category_model.dart';
import 'package:example_project/model/product_model.dart';
import 'package:example_project/service/app_database.dart';

class ProductService {
  static Future<List<ProductModel>> getProducts({
    CategoryModel category,
    String searchString,
    String sortField,
    bool ascending = false,
  }) async {
    return (await AppDatabase.database.rawQuery('''
      SELECT *
      FROM Product
      ${(searchString != null) ? 'WHERE categoryId = ${category.id} AND name like "%$searchString%"' : ''}
      ORDER BY ${(sortField != null ? '$sortField ${ascending ? 'ASC' : 'DESC'}, ' : '')} relevance DESC;
    ''')).map((json) => ProductModel.fromJson(json)).toList();
  }

  static Future<List<ProductModel>> getCategoryProducts(CategoryModel category) async {
    return (await AppDatabase.database.query(
      'Product',
      where: 'categoryId = ?',
      whereArgs: [category.id],
    ))
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }
}
