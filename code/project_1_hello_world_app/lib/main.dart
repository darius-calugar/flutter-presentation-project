import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hello World"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.nightlight_round,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 32,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.account_circle,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 32,
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColorDark,
                      Theme.of(context).primaryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: FlutterLogo(),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.map),
                title: Text('Drawer List Item 1'),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.access_alarm),
                title: Text('Drawer List Item 2'),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(Icons.email),
                title: Text('Drawer List Item 3'),
              ),
              AboutListTile(
                applicationName: 'Hello World App',
                applicationLegalese: 'Build by Darius Călugăr',
                applicationVersion: 'V1.0',
                icon: Icon(Icons.info_outline),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              children: [
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('ELEVATED'),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text('OUTLINED'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('FLAT'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: null,
                  child: Text('CUSTOM BUTTON'),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Write visible text here...',
                  ),
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Write obscured text here...',
                  ),
                ),
                Card(
                  margin: EdgeInsets.only(top: 32.0),
                  child: Row(
                    children: [
                      Image.network('https://picsum.photos/160'),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'This is a card',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean porttitor quis eros sed vehicula.')
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
