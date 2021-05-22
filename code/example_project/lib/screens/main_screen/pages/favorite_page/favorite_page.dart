import 'package:example_project/model/product_model.dart';
import 'package:example_project/screens/main_screen/widgets/product_list_tile.dart';
import 'package:example_project/services/favorite_service.dart';
import 'package:example_project/services/user_service.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  Future<List<ProductModel>> _favoriteProducts = FavoriteService.getFavoriteProducts(UserService.currentUser.id);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: _favoriteProducts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final favoriteProducts = snapshot.data;
          return favoriteProducts.isNotEmpty
              ? ListView(
                  children: favoriteProducts
                      .map(
                        (product) => ProductListTile(
                          productModel: product,
                          actions: [
                            IconButton(
                              onPressed: () => _onRemoveFromFavorites(product),
                              icon: Icon(Icons.favorite),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                )
              : Center(
                  child: Text(
                    'No products',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void _onRemoveFromFavorites(ProductModel product) {
    FavoriteService.removeProductFromFavorites(UserService.currentUser.id, product.id);
    setState(() {
      _favoriteProducts = FavoriteService.getFavoriteProducts(UserService.currentUser.id);
    });
  }
}
