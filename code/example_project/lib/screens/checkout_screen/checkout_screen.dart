import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Billing Details',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                TextField(
                  maxLength: 50,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  maxLength: 50,
                  decoration: InputDecoration(labelText: 'Surname'),
                ),
                TextField(
                  maxLength: 10,
                  decoration: InputDecoration(labelText: 'Phone number'),
                ),
                TextField(
                  maxLength: 255,
                  decoration: InputDecoration(labelText: 'Email address'),
                ),
                TextField(
                  maxLength: 255,
                  decoration: InputDecoration(labelText: 'Billing address'),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              elevation: 2,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Order summary',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Divider(height: 32),
                    Row(
                      children: [
                        Text(
                          'Product Name',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          'x1',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Expanded(child: Container()),
                        Text(
                          '\$999.99',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Processing fee',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Container(),
                        Expanded(child: Container()),
                        Text(
                          '\$0.10',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Transport fee',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Container(),
                        Expanded(child: Container()),
                        Text(
                          '\$2.99',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Expanded(child: Container()),
                        Text(
                          '\$999.99',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(16)),
                        textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.headline6),
                      ),
                      child: Text(
                        'Submit order',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
