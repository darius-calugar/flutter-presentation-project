import 'package:flutter/material.dart';

/// This is a stateless widget
/// it's build method will only be called once.
class StatelessCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'This is a card headline',
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(height: 16),
          Text(
            'This is a card subtitle',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 16),
          Text(
            'This text is really small',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
