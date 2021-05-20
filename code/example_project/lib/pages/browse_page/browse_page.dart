import 'dart:developer';

import 'package:example_project/model/category_model.dart';
import 'package:example_project/model/product_model.dart';
import 'package:example_project/pages/browse_page/widgets/category_card.dart';
import 'package:example_project/service/auth_service.dart';
import 'package:example_project/service/category_service.dart';
import 'package:flutter/material.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({Key key}) : super(key: key);

  @override
  _BrowsePageState createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  CategoryModel _category;
  bool Function(ProductModel) _filter;
  int Function(ProductModel, ProductModel) _sort;
  TextEditingController _searchController = TextEditingController();

  _BrowsePageState() {
    _searchController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          PopupMenuButton(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ClipOval(
                child: Image.network(
                  'https://picsum.photos/seed/${AuthService.currentUser().username}/64/64',
                ),
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Logout'),
                value: logout,
              ),
            ],
            onSelected: (action) => action(),
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
            label: "Browse",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
        ],
        currentIndex: 1,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Material(
              elevation: 4,
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.search,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: TextButton(
                    onPressed: () {},
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
          ),
          if (_category == null)
            FutureBuilder<List<CategoryModel>>(
              future: CategoryService.getCategories(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.map((e) => CategoryCard(categoryModel: e, onPressed: setCategory)).toList(),
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
          if (_category != null)
            FutureBuilder<List<ProductModel>>(
              future: Future.value(<ProductModel>[]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data
                        .map((e) => Container(
                              color: Colors.red,
                              height: 100,
                              width: 100,
                            ))
                        .toList(),
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
        ],
      ),
    );
  }

  void setCategory(CategoryModel category) {
    setState(() {
      _category = category;
    });
  }

  void logout() {
    AuthService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => route == null);
  }
}
