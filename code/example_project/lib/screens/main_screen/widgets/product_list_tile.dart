import 'package:example_project/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductListTile extends StatelessWidget {
  final ProductModel productModel;
  final List<Widget> actions;

  const ProductListTile({Key key, this.actions, this.productModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.pushNamed(context, '/details', arguments: {'productId': productModel.id}),
      title: Row(
        children: [
          Container(
            height: 64,
            width: 64,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: productModel.imageBytes != null
                  ? Image.memory(
                      productModel.imageBytes,
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
                Text(
                  productModel.name,
                  style: Theme.of(context).textTheme.subtitle1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$${(productModel.price * (100 - productModel.sale) ~/ 100 / 100)}',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                if (productModel.stock > 0)
                  Text(
                    '${(productModel.stock)} in stock',
                    style: Theme.of(context).textTheme.caption.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                if (productModel.stock <= 0)
                  Text(
                    'Out of stock',
                    style: Theme.of(context).textTheme.caption.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
              ],
            ),
          ),
        ]..addAll(actions),
      ),
    );
  }
}
