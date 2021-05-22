import 'package:example_project/model/product_model.dart';
import 'package:example_project/services/product_service.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<List<ProductModel>> _cartProducts = ProductService.getProducts();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
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
                      '\$${99.99.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '${products.length > 0 ? products.length : 'No'} items in cart',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _onGoToCheckout,
                      child: Text('Go to checkout'),
                    )
                  ],
                ),
              ),
              Divider(),
              Column(
                children: snapshot.data
                    .map(
                      (product) => Container(
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Row(
                          children: [
                            Container(
                              height: 64,
                              width: 64,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: product.imageBytes != null
                                    ? Image.memory(
                                        product.imageBytes,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/placeholder.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        product.name,
                                        style: Theme.of(context).textTheme.subtitle1,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '\$${(product.price * (100 - product.sale) ~/ 100 / 100)}',
                                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                  ),
                                  if (product.stock > 0)
                                    Text(
                                      '${(product.stock)} in stock',
                                      style: Theme.of(context).textTheme.caption.copyWith(
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                    ),
                                  if (product.stock <= 0)
                                    Text(
                                      'Out of stock',
                                      style: Theme.of(context).textTheme.caption.copyWith(
                                            color: Theme.of(context).colorScheme.error,
                                          ),
                                    ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.remove),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () {},
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '${1}',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () {},
                            ),
                          ],
                        ),
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

  void _onGoToCheckout() {
    Navigator.pushNamed(context, '/checkout');
  }
}
