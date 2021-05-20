import 'package:example_project/model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductModel productModel;
  final void Function(ProductModel) onPressed;

  const ProductCard({
    Key key,
    this.productModel,
    this.onPressed,
  }) : super(key: key);

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
                  productModel.imageBytes != null ? Image.memory(productModel.imageBytes) : Image.asset('assets/images/placeholder.png'),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        productModel.name + ' ' + productModel.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ),
                  if (productModel.sale > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${((productModel.price.toDouble()) / 100).toStringAsFixed(2)} RON',
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
                            '${productModel.sale}% OFF',
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  Text(
                    '${((productModel.price.toDouble() * (100 - productModel.sale) / 100) / 100).toStringAsFixed(2)} RON',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.orange[400]),
                      Icon(Icons.star, color: Colors.orange[400]),
                      Icon(Icons.star, color: Colors.orange[400]),
                      Icon(Icons.star, color: Colors.orange[400]),
                      Icon(Icons.star_border, color: Colors.orange[400]),
                    ],
                  ),
                  Text(
                    '(57 Reviews)',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Text('See details'),
                    ),
                  ),
                ],
              ),
              Positioned.directional(
                top: 0,
                end: 0,
                textDirection: TextDirection.ltr,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.favorite_border),
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
