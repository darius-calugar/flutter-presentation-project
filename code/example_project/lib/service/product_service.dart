import 'package:example_project/model/category_model.dart';
import 'package:example_project/model/product_model.dart';
import 'package:example_project/service/app_database.dart';

class ProductService {
  static Future<List<ProductModel>> getProducts() async {
    return (await AppDatabase.database.query(
      'Product',
    ))
        .map((json) => ProductModel.fromJson(json))
        .toList();
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
