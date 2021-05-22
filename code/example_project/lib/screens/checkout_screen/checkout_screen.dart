import 'package:example_project/model/product_model.dart';
import 'package:example_project/services/cart_service.dart';
import 'package:example_project/services/user_service.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static final int _processingFee = 10;
  static final int _transportFee = 289;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailAddressController = TextEditingController();
  final _physicalAddressController = TextEditingController();

  bool _checkoutSubmitted = false;
  Future<bool> _checkoutSuccess = Future.value(false);
  Future<Map<ProductModel, int>> _cartProducts = CartService.getCartProducts(UserService.currentUser.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: AnimatedCrossFade(
        duration: Duration(milliseconds: 200),
        crossFadeState: _checkoutSubmitted ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        firstChild: ListView(
          shrinkWrap: true,
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          maxLength: 50,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          controller: _nameController,
                          validator: _validateName,
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        TextFormField(
                          maxLength: 50,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          controller: _surnameController,
                          validator: _validateSurname,
                          decoration: InputDecoration(labelText: 'Surname'),
                        ),
                        TextFormField(
                          maxLength: 10,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          controller: _phoneNumberController,
                          validator: _validatePhoneNumber,
                          decoration: InputDecoration(labelText: 'Phone number'),
                        ),
                        TextFormField(
                          maxLength: 255,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailAddressController,
                          validator: _validateEmailAddress,
                          decoration: InputDecoration(labelText: 'Email address'),
                        ),
                        TextFormField(
                          maxLength: 255,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.streetAddress,
                          controller: _physicalAddressController,
                          validator: _validatePhysicalAddress,
                          decoration: InputDecoration(labelText: 'Physical address'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
                future: _cartProducts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final cardProducts = snapshot.data;
                    return Padding(
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
                              Column(
                                children: cardProducts.entries
                                    .map<Widget>(
                                      (productEntry) => Row(
                                        children: [
                                          Text(
                                            '${productEntry.key.name}',
                                            style: Theme.of(context).textTheme.subtitle1,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'x${productEntry.value}',
                                            style: Theme.of(context).textTheme.subtitle2,
                                          ),
                                          Expanded(child: Container()),
                                          Text(
                                            '\$${(productEntry.key.price * productEntry.value / 100).toStringAsFixed(2)}',
                                            style: Theme.of(context).textTheme.subtitle1,
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
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
                                    '\$${(_processingFee / 100).toStringAsFixed(2)}',
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
                                    '\$${(_transportFee / 100).toStringAsFixed(2)}',
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
                                    '\$${((_totalSum(cardProducts) + _processingFee + _transportFee) / 100).toStringAsFixed(2)}',
                                    style: Theme.of(context).textTheme.headline6.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 32),
                              ElevatedButton(
                                onPressed: _onSubmitOrder,
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
                    );
                  } else
                    return Center(child: CircularProgressIndicator());
                }),
          ],
        ),
        secondChild: FutureBuilder(
            future: _checkoutSuccess,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'The order was placed successfully.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Icon(
                        Icons.sentiment_very_satisfied,
                        color: Theme.of(context).dividerColor,
                        size: 128,
                      ),
                      ElevatedButton(
                        onPressed: _onGoBack,
                        child: Text('I can\'t wait'),
                      )
                    ],
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'There was an error',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  String _validateName(String value) {
    if (value.isEmpty) return 'Name is required';
    if (value.length <= 3) return 'At least 3 characters are required';
    return null;
  }

  String _validateSurname(String value) {
    if (value.isEmpty) return 'Surname is required';
    if (value.length <= 3) return 'At least 3 characters are required';
    return null;
  }

  String _validatePhoneNumber(String value) {
    if (value.isEmpty) return 'Phone number is required';
    if (value.length <= 3) return 'At least 3 characters are required';
    if (!RegExp(r"(^(?:[+0]9)?[0-9]{10,12}$)").hasMatch(value)) return 'Phone number is invalid';
    return null;
  }

  String _validateEmailAddress(String value) {
    if (value.isEmpty) return 'Email address is required';
    if (value.length <= 3) return 'At least 3 characters are required';
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) return 'Email address is invalid';
    return null;
  }

  String _validatePhysicalAddress(String value) {
    if (value.isEmpty) return 'Physical address is required';
    if (value.length <= 3) return 'At least 3 characters are required';
    return null;
  }

  int _totalSum(Map<ProductModel, int> productMap) {
    if (productMap.isEmpty) return 0;
    return productMap.entries.map((entry) => entry.key.price * entry.value).reduce((lhs, rhs) => lhs + rhs);
  }

  void _onSubmitOrder() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _checkoutSubmitted = true;
        _checkoutSuccess = CartService.submitOrder(UserService.currentUser.id);
      });
    }
  }

  void _onGoBack() {
    Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => route == null);
  }
}
