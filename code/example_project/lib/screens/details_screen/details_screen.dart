import 'package:example_project/model/product_model.dart';
import 'package:example_project/services/cart_service.dart';
import 'package:example_project/services/product_service.dart';
import 'package:example_project/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final int productId;

  const DetailsScreen({Key key, this.productId}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState(productId);
}

class _DetailsScreenState extends State<DetailsScreen> {
  Future<ProductModel> _product;
  Future<int> _cartAmount;

  _DetailsScreenState(int productId) {
    _product = ProductService.getProduct(productId)..then((product) => _fetchCartAmount(product));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: FutureBuilder(
        future: _product,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ProductModel productModel = snapshot.data;
            return ListView(
              children: [
                productModel.imageBytes != null ? Image.memory(productModel.imageBytes) : Image.asset('assets/images/placeholder.png'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          productModel.name,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      if (productModel.sale > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '\$${((productModel.price.toDouble()) / (100 - productModel.sale)).toStringAsFixed(2)}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                    color: Theme.of(context).disabledColor,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 2,
                                  ),
                            ),
                            SizedBox(width: 6),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '${productModel.sale}% OFF',
                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      Text(
                        '\$${(productModel.price.toDouble() / 100).toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      SizedBox(height: 8),
                      if (productModel.stock > 0)
                        Text(
                          '${productModel.stock} in stock',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      if (productModel.stock == 0)
                        Text(
                          'Out of stock',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Theme.of(context).hintColor,
                              ),
                        ),
                      SizedBox(height: 16),
                      FutureBuilder(
                          future: _cartAmount,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final cartAmount = snapshot.data;
                              return AnimatedSwitcher(
                                duration: Duration(milliseconds: 100),
                                child: (cartAmount <= 0)
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 32),
                                        child: ElevatedButton(
                                          onPressed: () => _onAddToCart(productModel),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Add to cart'),
                                              Icon(Icons.add_shopping_cart),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => _onRemoveFromCart(productModel),
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all(CircleBorder()),
                                            ),
                                            child: Icon(Icons.remove),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Text(
                                              '${cartAmount}',
                                              style: Theme.of(context).textTheme.headline5,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => _onAddToCart(productModel),
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all(CircleBorder()),
                                            ),
                                            child: Icon(Icons.add),
                                          ),
                                        ],
                                      ),
                              );
                            }
                            return Center(child: CircularProgressIndicator());
                          }),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    productModel.description,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                )
              ],
            );
          } else if (snapshot.hasError) {
            throw snapshot.error;
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void _onAddToCart(ProductModel productModel) {
    CartService.addProductToCart(UserService.currentUser.id, productModel.id).then((result) => _fetchCartAmount(productModel));
  }

  void _onRemoveFromCart(ProductModel productModel) {
    CartService.removeProductFromCart(UserService.currentUser.id, productModel.id).then((result) => _fetchCartAmount(productModel));
  }

  void _fetchCartAmount(ProductModel productModel) {
    final fetchedCartAmount = CartService.getCartProducts(UserService.currentUser.id).then((cartProducts) {
      print(cartProducts);
      if (!cartProducts.keys.any((product) => product.id == productModel.id)) return 0;
      return cartProducts.entries.singleWhere((productEntry) => productEntry.key.id == productModel.id).value;
    });
    setState(() {
      _cartAmount = fetchedCartAmount;
    });
  }
}
