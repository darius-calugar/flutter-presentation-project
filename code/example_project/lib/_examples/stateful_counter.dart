import 'package:flutter/material.dart';

/// This is a stateful widget.
/// Stateful widgets do not implement the build method, instead, the _StatefulCounterState will handle building the widget.
class StatefulCounter extends StatefulWidget {
  /// Stateful widgets also only accept final and public attributes
  final int initialCounterValue;

  const StatefulCounter(this.initialCounterValue);

  @override
  _StatefulCounterState createState() => _StatefulCounterState(initialCounterValue);
}

class _StatefulCounterState extends State<StatefulCounter> {
  /// Underscore means private variable
  int _counterValue;

  _StatefulCounterState(initialCounterValue) {
    /// the constructor is called before the initial widget build.
    /// That means setState does not need to be used here.
    _counterValue = initialCounterValue;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('$_counterValue'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _incrementCounter,
            child: Text('Increment'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _decrementCounter,
            child: Text('Decrement'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _resetCounter,
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }

  /// This method uses setState
  /// This will increment the counter and the widget will be rebuilt
  void _incrementCounter() {
    setState(() {
      _counterValue++;
    });
  }

  /// This method uses setState
  /// This will decrement the counter and the widget will be rebuilt
  void _decrementCounter() {
    setState(() {
      _counterValue--;
    });
  }

  /// !!!!!!!!!
  /// This method does not use setState.
  /// This will reset the counter but the widget will not be rebuilt.
  /// !!!!!!!!!
  void _resetCounter() {
    _counterValue = 0;
  }
}
