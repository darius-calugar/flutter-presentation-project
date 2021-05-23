import 'package:flutter/material.dart';

/// This is a stateless widget with input parameters.
/// It's build method will still only be called once.
/// Since this is immutable, input parameters cannot be changed.
/// A different object would be needed.
class StatelessCard extends StatelessWidget {
  /// Stateless widgets only accept final and public attributes
  final String headline;
  final String subtitle;
  final String caption;

  const StatelessCard({Key key, this.headline, this.subtitle, this.caption}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            headline,
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
