import 'package:example_project/model/category_model.dart';
import 'package:example_project/pages/categories_page/widgets/category_card.dart';
import 'package:example_project/service/category_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: ClipOval(
                child: Image.network(
                  'https://github.com/identicons/username0.png',
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
        ],
        currentIndex: 1,
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: CategoryService.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              shrinkWrap: true,
              children: snapshot.data.map((e) => CategoryCard(categoryModel: e)).toList(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(":("),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
