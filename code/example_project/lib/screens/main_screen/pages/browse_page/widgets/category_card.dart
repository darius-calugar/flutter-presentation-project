import 'dart:math';

import 'package:example_project/model/category_model.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel categoryModel;
  final void Function(CategoryModel) onPressed;

  const CategoryCard({
    Key key,
    this.categoryModel,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              categoryModel.imageBytes != null ? Image.memory(categoryModel.imageBytes) : Image.asset('assets/images/placeholder.png'),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                      colors: [
                        Colors.black54,
                        Colors.grey.withOpacity(0.0),
                        Colors.white24,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryModel.name,
                      style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              // if (categoryModel.products.any((product) => product.sale > 0))
              Positioned.directional(
                bottom: 0,
                end: 0,
                textDirection: TextDirection.ltr,
                child: Transform(
                  transform: Matrix4.rotationZ(-pi / 3) * Matrix4.translationValues(12, 148, 0),
                  child: Material(
                    elevation: 16,
                    color: Theme.of(context).colorScheme.primary,
                    child: Container(
                      height: 36,
                      width: 256,
                      alignment: Alignment.center,
                      child: Text(
                        "SALE ${30}%",
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onPressed(categoryModel),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
