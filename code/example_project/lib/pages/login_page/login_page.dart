import 'package:example_project/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberCredentials = false;
  String _error = '';

  _LoginPageState() {
    SharedPreferences.getInstance().then((sharedPreferences) {
      _usernameController.text = sharedPreferences.getString('login_username') ?? '';
      _passwordController.text = sharedPreferences.getString('login_password') ?? '';
      _rememberCredentials = sharedPreferences.getBool('login_remember_credentials') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(32, 128, 32, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello,',
                  style: Theme.of(context).textTheme.headline2.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                Text(
                  'Shopper',
                  style: Theme.of(context).textTheme.headline2.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w300,
                      ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: usernameValidator,
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: "Username",
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                          validator: passwordValidator,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberCredentials,
                        onChanged: onRememberCredentialsChanged,
                      ),
                      Text('Remember login credentials')
                    ],
                  ),
                  Container(
                    height: 32,
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      _error,
                      style: Theme.of(context).textTheme.caption.copyWith(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onLogin,
                          child: Text('Login'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onRegister,
                          child: Text('Register'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              "Hint: Login credentials are 'Guest' and 'pass'.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      ),
    );
  }

  void onLogin() async {
    if (_loginFormKey.currentState.validate()) {
      var user = await AuthService.login(
        _usernameController.value.text,
        _passwordController.value.text,
      );
      if (user != null) {
        SharedPreferences.getInstance().then((sharedPreferences) {
          if (_rememberCredentials) {
            sharedPreferences.setString('login_username', _usernameController.value.text);
            sharedPreferences.setString('login_password', _passwordController.value.text);
            sharedPreferences.setBool('login_remember_credentials', true);
          } else {
            sharedPreferences.remove('login_username');
            sharedPreferences.remove('login_password');
            sharedPreferences.remove('login_remember_credentials');
          }
        });
        Navigator.pushReplacementNamed(context, '/browse');
        setState(() {
          _error = '';
        });
      } else {
        setState(() {
          _error = 'Username or password are incorrect!';
        });
      }
    }
  }

  void onRegister() {
    Navigator.pushNamed(context, '/register');
  }

  void onRememberCredentialsChanged(bool value) {
    setState(() {
      _rememberCredentials = value;
    });
  }

  String usernameValidator(String value) {
    if (value.isEmpty) return 'Username is required';
    return null;
  }

  String passwordValidator(String value) {
    if (value.isEmpty) return 'Password is required';
    return null;
  }
}
