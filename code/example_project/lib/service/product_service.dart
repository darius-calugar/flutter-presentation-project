import 'package:example_project/model/product_model.dart';
import 'package:example_project/service/app_database.dart';

class ProductService {
  static Future<List<ProductModel>> getProducts() async {
    AppDatabase.database.rawQuery('''
      select  * from Product P
        left join Category C on C.id = P.id
    ''');
  }

  static Future<List<ProductModel>> getCategoryProducts(CategoryModel) async {}
}
