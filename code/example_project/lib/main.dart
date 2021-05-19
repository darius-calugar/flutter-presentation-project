import 'package:example_project/pages/categories_page/categories_page.dart';
import 'package:example_project/pages/login_page/login_page.dart';
import 'package:example_project/pages/register_page/register_page.dart';
import 'package:example_project/themes/themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      theme: Themes.defaultTheme(),
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/categories': (context) => CategoriesPage(),
      },
    );
  }
}
