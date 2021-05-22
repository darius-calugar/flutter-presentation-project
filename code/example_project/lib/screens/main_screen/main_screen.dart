import 'package:example_project/screens/main_screen/pages/cart_page/cart_page.dart';
import 'package:example_project/screens/main_screen/pages/favorite_page/favorite_page.dart';
import 'package:example_project/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'pages/browse_page/browse_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _pages = [
    FavoritePage(),
    BrowsePage(),
    CartPage(),
  ];
  final List<IconData> _pageIcons = [
    Icons.favorite,
    Icons.search,
    Icons.shopping_cart,
  ];
  final List<String> _pageNames = [
    'Favorites',
    'Browse',
    'Cart',
  ];
  int _currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageNames[_currentPageIndex]),
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
                value: _logout,
              ),
            ],
            onSelected: (action) => action(),
          ),
        ],
      ),
      body: _pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _setPage,
        currentIndex: _currentPageIndex,
        items: List.generate(_pages.length, (index) => index)
            .map(
              (index) => BottomNavigationBarItem(
                icon: Icon(_pageIcons[index]),
                label: _pageNames[index],
              ),
            )
            .toList(),
      ),
    );
  }

  void _setPage(int value) {
    setState(() {
      _currentPageIndex = value;
    });
  }

  void _logout() {
    AuthService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => route == null);
  }
}
