import 'package:example_project/pages/browse_page/browse_page.dart';
import 'package:example_project/pages/details_page/details_page.dart';
import 'package:example_project/pages/login_page/login_page.dart';
import 'package:example_project/pages/register_page/register_page.dart';
import 'package:example_project/service/app_database.dart';
import 'package:example_project/themes/themes.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Themes.defaultTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/browse': (context) => BrowsePage(),
      },
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>;
        if (settings.name == '/details') {
          return MaterialPageRoute(
            builder: (context) => DetailsPage(
              productId: args['productId'],
            ),
          );
        }
        return null;
      },
    );
  }
}
