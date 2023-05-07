import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Counter App')),
        body: Center(child: CounterWidget()),
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  final dbHelper = DatabaseHelper.instance;
  int _counter = 0;
  @override
  void initState() {
    super.initState();
    _getLatestCount();
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
    Map<String, dynamic> row = {
      DatabaseHelper.columnCount: _counter,
      DatabaseHelper.columnDateTime: DateTime.now().toIso8601String(),
    };
    await dbHelper.insert(row);
  }

  void _getLatestCount() async {
    final latestCount = await dbHelper.queryLatestCount();
    if (latestCount.isNotEmpty) {
      setState(() {
        _counter = latestCount.first[DatabaseHelper.columnCount] as int;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Counter:',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        Text(
          '$_counter',
          style: TextStyle(fontSize: 40),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: Text('Increment Counter'),
        ),
      ],
    );
  }
}
