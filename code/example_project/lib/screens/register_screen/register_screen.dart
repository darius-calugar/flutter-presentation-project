import 'package:example_project/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  String _error = '';
  String _identiconUrl = '';

  _RegisterScreenState() {
    _usernameController.text = '';
    _passwordController.text = '';
    _repeatPasswordController.text = '';

    _usernameController.addListener(() {
      setState(() {
        _identiconUrl = 'https://picsum.photos/seed/${_usernameController.value.text}/512/512';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 256,
                      width: 256,
                      child: Material(
                        type: MaterialType.circle,
                        color: Theme.of(context).colorScheme.surface,
                        elevation: 4,
                        child: ClipOval(
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  Icons.face,
                                  size: 256,
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                              if (_usernameController.value.text.isNotEmpty)
                                Image.network(
                                  _identiconUrl,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Form(
                      key: _registerFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: _usernameValidator,
                            controller: _usernameController,
                            decoration: InputDecoration(
                              hintText: "Username",
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            obscureText: true,
                            validator: _passwordValidator,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(Icons.lock),
                            ),
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            validator: _repeatPasswordValidator,
                            controller: _repeatPasswordController,
                            decoration: InputDecoration(
                              hintText: "Repeat Password",
                              prefixIcon: Icon(Icons.lock),
                            ),
                          ),
                        ],
                      ),
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
                            onPressed: _onCreateAccount,
                            child: Text('Create Account'),
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
                            onPressed: _onGoBack,
                            child: Text('Go Back'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCreateAccount() {
    if (_registerFormKey.currentState.validate()) {
      UserService.register(
        _usernameController.value.text,
        _passwordController.value.text,
      ).then((success) {
        if (success) {
          setState(() {
            _error = '';
          });
          Navigator.pop(context);
        } else {
          setState(() {
            _error = 'Could not create account. Username might not be unique.';
          });
        }
      });
    }
  }

  void _onGoBack() {
    Navigator.pop(context);
  }

  String _usernameValidator(String value) {
    if (value.isEmpty) return 'Username is required';
    return null;
  }

  String _passwordValidator(String value) {
    if (value.isEmpty) return 'Password is required';
    return null;
  }

  String _repeatPasswordValidator(String value) {
    if (value != _passwordController.value.text) return 'Passwords do not match';
    return null;
  }
}
