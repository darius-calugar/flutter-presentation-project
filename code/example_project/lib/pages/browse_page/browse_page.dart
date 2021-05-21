import 'package:example_project/model/category_model.dart';
import 'package:example_project/model/product_model.dart';
import 'package:example_project/pages/browse_page/widgets/category_card.dart';
import 'package:example_project/pages/browse_page/widgets/product_card.dart';
import 'package:example_project/service/auth_service.dart';
import 'package:example_project/service/category_service.dart';
import 'package:example_project/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({Key key}) : super(key: key);

  @override
  _BrowsePageState createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  final _searchController = TextEditingController();
  Future<List<CategoryModel>> _categories = CategoryService.getCategories();
  Future<List<ProductModel>> _products = Future.value([]);

  // Query Parameters
  CategoryModel _category;
  String _searchString = '';
  static final int _defaultMinPrice = 0;
  static final int _defaultMaxPrice = 100000;
  int _minPrice = _defaultMinPrice;
  int _maxPrice = _defaultMaxPrice;
  static final int _defaultMinSale = 0;
  static final int _defaultMaxSale = 100;
  int _minSale = _defaultMinSale;
  int _maxSale = _defaultMaxSale;
  static final Map<String, Set<bool>> _sortOptions = {
    'Relevance': {false},
    'Price': {false, true},
    'Sale': {false},
  };
  static final String _defaultSortField = 'Relevance';
  String _sortField = _defaultSortField;
  bool _sortAscending = false;

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
        currentIndex: 1,
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
          if (isQuerying())
            Container(
              height: 36,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () => showFilterModalBottomSheet(),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32))),
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.surface),
                            foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onSurface),
                            overlayColor: MaterialStateProperty.all(Theme.of(context).splashColor)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.filter_alt, size: 18),
                            Text('Filter options'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () => showSortModalBottomSheet(),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32))),
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.surface),
                            foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onSurface),
                            overlayColor: MaterialStateProperty.all(Theme.of(context).splashColor)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sort, size: 18),
                            Text('Sort by '),
                            Text('$_sortField', style: TextStyle(fontWeight: FontWeight.bold)),
                            if (_sortOptions[_sortField].length > 1) (_sortAscending ? Icon(Icons.north_east, size: 18) : Icon(Icons.south_east, size: 18)),
                          ],
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
          if (!isQuerying())
            FutureBuilder<List<CategoryModel>>(
              future: _categories,
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
          if (isQuerying())
            FutureBuilder<List<ProductModel>>(
              future: _products,
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

  void logout() {
    AuthService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => route == null);
  }

  void onSetCategory(CategoryModel category) {
    setState(() {
      _category = category;
    });
    fetchProducts();
  }

  void onSetSearch(String string) {
    setState(() {
      _searchController.text = string;
      _searchString = string;
    });
    fetchProducts();
  }

  void onReset() {
    _searchController.text = '';
    setState(() {
      _category = null;
      _searchString = '';
      _minPrice = _defaultMinPrice;
      _maxPrice = _defaultMaxPrice;
      _minSale = _defaultMinSale;
      _maxSale = _defaultMaxSale;
      _sortField = _defaultSortField;
      _sortAscending = _sortOptions[_sortField].first;
    });
    fetchProducts();
  }

  bool isQuerying() {
    return _category != null || _searchString.isNotEmpty;
  }

  void fetchProducts() async {
    Future<List<ProductModel>> fetchedProducts;
    fetchedProducts = ProductService.getProducts(
      category: _category,
      searchString: _searchString,
      sortField: _sortField,
      ascending: _sortAscending,
    ).then((products) => products
        .where(
          (element) => element.price >= _minPrice && element.price <= _maxPrice && element.sale >= _minSale && element.sale <= _maxSale,
        )
        .toList());
    setState(() {
      _products = fetchedProducts;
    });
  }

  void showFilterModalBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Filter Options',
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 32),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FlexColumnWidth(.25),
                  1: IntrinsicColumnWidth(),
                  2: FlexColumnWidth(.75),
                  3: IntrinsicColumnWidth(),
                },
                children: [
                  TableRow(
                    children: [
                      Text(
                        'Price',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text('${_defaultMinPrice ~/ 100}'),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return RangeSlider(
                            min: _defaultMinPrice / 100,
                            max: _defaultMaxPrice.toDouble(),
                            divisions: (_defaultMaxPrice - _defaultMinPrice) ~/ 100,
                            values: RangeValues(_minPrice.toDouble(), _maxPrice.toDouble()),
                            labels: RangeLabels('${_minPrice ~/ 100} RON', '${_maxPrice ~/ 100} RON'),
                            onChanged: (value) {
                              setState(() {
                                _minPrice = value.start.toInt();
                                _maxPrice = value.end.toInt();
                              });
                            },
                          );
                        },
                      ),
                      Text('${_defaultMaxPrice ~/ 100}'),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text(
                        'Sale',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text('$_defaultMinSale%'),
                      RangeSlider(
                        min: _defaultMinSale.toDouble(),
                        max: _defaultMaxSale.toDouble(),
                        divisions: _defaultMaxSale - _defaultMinSale,
                        values: RangeValues(_minSale.toDouble(), _maxSale.toDouble()),
                        labels: RangeLabels('$_minSale%', '$_maxSale%'),
                        onChanged: (value) {
                          setState(() {
                            _minSale = value.start.toInt();
                            _maxSale = value.end.toInt();
                          });
                        },
                      ),
                      Text('$_defaultMaxSale%'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 32),
              ButtonBar(
                children: [
                  TextButton(
                    child: Text('Clear'),
                    onPressed: () {
                      setState(() {
                        _minPrice = _defaultMinPrice;
                        _maxPrice = _defaultMaxPrice;
                        _minSale = _defaultMinSale;
                        _maxSale = _defaultMaxSale;
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text('Apply Filters'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            ],
          ),
        );
      }),
    ).then((e) => fetchProducts());
  }

  void showSortModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sort Options',
                style: Theme.of(context).textTheme.headline5,
              ),
              Divider(),
            ]..addAll(
                _sortOptions.entries.expand(
                  (option) => option.value.map(
                    (optionValue) => RadioListTile(
                      value: option.key + optionValue.toString(),
                      groupValue: _sortField + _sortAscending.toString(),
                      title: Row(
                        children: [
                          Text(
                            option.key,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          if (option.value.length > 1)
                            Icon(
                              optionValue ? Icons.north_east : Icons.south_east,
                              size: 18,
                            ),
                        ],
                      ),
                      onChanged: (value) {
                        setState(() {
                          _sortField = option.key;
                          _sortAscending = optionValue;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
          ),
        );
      }),
    ).then((e) => fetchProducts());
  }
}
