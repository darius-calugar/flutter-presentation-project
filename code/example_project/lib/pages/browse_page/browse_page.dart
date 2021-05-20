import 'package:example_project/model/category_model.dart';
import 'package:example_project/model/product_model.dart';
import 'package:example_project/pages/browse_page/widgets/category_card.dart';
import 'package:example_project/pages/browse_page/widgets/product_card.dart';
import 'package:example_project/service/auth_service.dart';
import 'package:example_project/service/category_service.dart';
import 'package:example_project/service/product_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({Key key}) : super(key: key);

  @override
  _BrowsePageState createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  TextEditingController _searchController = TextEditingController();
  CategoryModel _category;
  String _searchString = '';

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
          Container(
            height: 48,
            margin: EdgeInsets.all(8),
            child: Material(
              elevation: 4,
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.search,
                      onSubmitted: onSetSearch,
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    crossFadeState: (_category != null || _searchString.isNotEmpty) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 100),
                    firstChild: Container(
                      width: 64,
                      height: 48,
                      child: Material(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                        child: InkWell(
                          onTap: () => onReset(),
                          child: Icon(
                            Icons.close,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                    ),
                    secondChild: Container(height: 48, child: Material()),
                  ),
                ],
              ),
            ),
          ),
          if (_category != null || _searchString.isNotEmpty)
            Container(
              height: 36,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Material(
                        elevation: 2,
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(100),
                        child: Center(
                          child: Text('Filter price'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Material(
                        elevation: 2,
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          onTap: () {},
                          child: Center(
                            child: Text('Sort by Relevance'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (_category != null || _searchString.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'Searching '),
                      if (_searchString.isNotEmpty) TextSpan(text: 'for "'),
                      if (_searchString.isNotEmpty) TextSpan(text: _searchString, style: TextStyle(fontWeight: FontWeight.bold)),
                      if (_searchString.isNotEmpty) TextSpan(text: '" '),
                      if (_category != null) TextSpan(text: 'in '),
                      if (_category != null) TextSpan(text: _category.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                    style: Theme.of(context).textTheme.caption,
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
                    children: snapshot.data.map((e) => CategoryCard(categoryModel: e, onPressed: onSetCategory)).toList(),
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
              future: ProductService.getCategoryProducts(_category),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.count(
                    primary: false,
                    shrinkWrap: true,
                    childAspectRatio: 8 / 13,
                    crossAxisCount: 2,
                    children: snapshot.data
                        .map((e) => ProductCard(
                              productModel: e,
                              onPressed: (product) {},
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

  void onSetSearch(String string) {
    setState(() {
      _searchController.text = string;
      _searchString = string;
    });
  }

  void onSetCategory(CategoryModel category) {
    setState(() {
      _category = category;
    });
  }

  void onReset() {
    _searchController.text = '';
    setState(() {
      _searchString = '';
      _category = null;
    });
  }

  void logout() {
    AuthService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => route == null);
  }
}
