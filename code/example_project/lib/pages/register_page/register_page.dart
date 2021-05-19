import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key key}) : super(key: key);

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
                    Form(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 256,
                            width: 256,
                            child: Material(
                              type: MaterialType.circle,
                              color: Theme.of(context).colorScheme.surface,
                              elevation: 4,
                              child: Stack(
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      'https://randomuser.me/api/portraits/lego/6.jpg',
                                    ),
                                  ),
                                  Positioned.directional(
                                    end: 18,
                                    bottom: 18,
                                    textDirection: TextDirection.ltr,
                                    child: SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: Material(
                                        type: MaterialType.circle,
                                        color: Theme.of(context).colorScheme.primary,
                                        elevation: 8,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 32),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: "Username",
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(Icons.lock),
                            ),
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Repeat Password",
                              prefixIcon: Icon(Icons.lock),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
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
                            onPressed: () {
                              Navigator.pop(context);
                            },
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
}
