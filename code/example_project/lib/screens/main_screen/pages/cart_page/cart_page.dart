import 'package:example_project/model/product_model.dart';
import 'package:example_project/screens/main_screen/widgets/product_list_tile.dart';
import 'package:example_project/services/cart_service.dart';
import 'package:example_project/services/user_service.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<Map<ProductModel, int>> _cartProducts = CartService.getCartProducts(UserService.currentUser.id);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<ProductModel, int>>(
      future: _cartProducts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data;
          return ListView(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '\$${(_totalSum(products) / 100).toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '${_totalItems(products) > 0 ? _totalItems(products) : 'No'} items in the cart',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _totalItems(products) > 0 && _cartValid(products) ? _onGoToCheckout : null,
                      child: Text('Go to checkout'),
                    ),
                    SizedBox(height: 16),
                    if (!_cartValid(products))
                      Text(
                        'Some items exceed the available stock',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                  ],
                ),
              ),
              Divider(),
              Column(
                children: products.entries
                    .map(
                      (entry) => ProductListTile(
                        productModel: entry.key,
                        actions: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: () => _onAddCartProduct(entry.key),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '${entry.value}',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: () => _onRemoveCartProduct(entry.key),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _fetchCartProducts() {
    final fetchedCartProducts = CartService.getCartProducts(UserService.currentUser.id);
    setState(() {
      _cartProducts = fetchedCartProducts;
    });
  }

  int _totalSum(Map<ProductModel, int> productMap) {
    if (productMap.isEmpty) return 0;
    return productMap.entries.map((entry) => entry.key.price * entry.value).reduce((lhs, rhs) => lhs + rhs);
  }

  int _totalItems(Map<ProductModel, int> productMap) {
    if (productMap.isEmpty) return 0;
    return productMap.values.reduce((lhs, rhs) => lhs + rhs);
  }

  bool _cartValid(Map<ProductModel, int> productMap) {
    return productMap.entries.every((entry) => entry.key.stock >= entry.value);
  }

  void _onRemoveCartProduct(ProductModel product) {
    CartService.addProductToCart(UserService.currentUser.id, product.id).then((value) => _fetchCartProducts());
  }

  void _onAddCartProduct(ProductModel product) {
    CartService.removeProductFromCart(UserService.currentUser.id, product.id).then((value) => _fetchCartProducts());
  }

  void _onGoToCheckout() {
    Navigator.pushNamed(context, '/checkout');
  }
}
