import 'package:example_project/screens/checkout_screen/checkout_screen.dart';
import 'package:example_project/screens/details_screen/details_screen.dart';
import 'package:example_project/screens/login_screen/login_screen.dart';
import 'package:example_project/screens/main_screen/main_screen.dart';
import 'package:example_project/screens/register_screen/register_screen.dart';
import 'package:example_project/services/app_database.dart';
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
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/main': (context) => MainScreen(),
        '/checkout': (context) => CheckoutScreen(),
      },
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>;
        if (settings.name == '/details') {
          return MaterialPageRoute(
            builder: (context) => DetailsScreen(
              productId: args['productId'],
            ),
          );
        }
        return null;
      },
    );
  }
}
