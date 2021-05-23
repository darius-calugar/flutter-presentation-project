import 'package:example_project/model/product_model.dart';
import 'package:example_project/services/favorite_service.dart';
import 'package:example_project/services/user_service.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final ProductModel productModel;

  const ProductCard({
    Key key,
    this.productModel,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState(productModel);
}

class _ProductCardState extends State<ProductCard> {
  Future<bool> _isFavorite = Future.value(false);

  _ProductCardState(ProductModel productModel) {
    _isFavorite = FavoriteService.isProductFavorite(UserService.currentUser.id, productModel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Material(
        elevation: 1,
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  widget.productModel.imageBytes != null ? Image.memory(widget.productModel.imageBytes) : Image.asset('assets/images/placeholder.png'),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        widget.productModel.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ),
                  if (widget.productModel.sale > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$${(widget.productModel.price.toDouble() / (100 - widget.productModel.sale)).toStringAsFixed(2)}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
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
                            '${widget.productModel.sale}% OFF',
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  Text(
                    '\$${(widget.productModel.price.toDouble() / 100).toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  if (widget.productModel.stock > 0)
                    Text(
                      '${widget.productModel.stock} in stock',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  if (widget.productModel.stock == 0)
                    Text(
                      'Out of stock',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: OutlinedButton(
                      onPressed: _onOpenDetails,
                      child: Text('See details'),
                    ),
                  ),
                ],
              ),
              Positioned.directional(
                top: 0,
                end: 0,
                textDirection: TextDirection.ltr,
                child: FutureBuilder(
                  future: _isFavorite,
                  builder: (context, snapshot) => IconButton(
                    onPressed: snapshot.hasData ? () => _onSetFavorite(!snapshot.data) : null,
                    icon: Icon((snapshot.hasData && snapshot.data) ? Icons.favorite : Icons.favorite_border),
                    color: (snapshot.hasData && snapshot.data) ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onOpenDetails() {
    Navigator.pushNamed(context, '/details', arguments: {'productId': widget.productModel.id});
  }

  void _onSetFavorite(bool value) {
    if (value == true) {
      FavoriteService.addProductToFavorites(UserService.currentUser.id, widget.productModel.id);
    } else {
      FavoriteService.removeProductFromFavorites(UserService.currentUser.id, widget.productModel.id);
    }
    _fetchIsFavorite();
  }

  void _fetchIsFavorite() {
    final fetchedIsFavorite = FavoriteService.isProductFavorite(UserService.currentUser.id, widget.productModel.id);
    setState(() {
      _isFavorite = fetchedIsFavorite;
    });
  }
}
