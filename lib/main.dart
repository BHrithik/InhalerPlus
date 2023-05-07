import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() {
  runApp(InhalerPlusApp());
}

class InhalerPlusApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inhaler+',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _pages = [
    HomePage(),
    DataPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inhaler+'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _buttonClickCount = 0;
  final dbHelper = DatabaseHelper.instance;
  @override
  void initState() {
    super.initState();
    _getLatestCount();
  }

  void _incrementCounter() async {
    setState(() {
      _buttonClickCount++;
    });
    Map<String, dynamic> row = {
      DatabaseHelper.columnCount: _buttonClickCount,
      DatabaseHelper.columnDateTime: DateTime.now().toIso8601String(),
    };
    await dbHelper.insert(row);
  }

  void _getLatestCount() async {
    final latestCount = await dbHelper.queryLatestCount();
    if (latestCount.isNotEmpty) {
      setState(() {
        _buttonClickCount =
            latestCount.first[DatabaseHelper.columnCount] as int;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Todays Count',
          ),
          Text(
            '$_buttonClickCount',
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: _incrementCounter,
            child: Text('Record a use manually'),
          ),
        ],
      ),
    );
  }
}

class DataPage extends StatelessWidget {
  final List<Map<String, dynamic>> _data = [
    {
      'date': '2023-05-01',
      'count': 5,
      'time': '10:00 AM',
      'place': 'Home',
    },
    {
      'date': '2023-05-02',
      'count': 3,
      'time': '03:00 PM',
      'place': 'Office',
    },
    {
      'date': '2023-05-03',
      'count': 8,
      'time': '06:30 PM',
      'place': 'Park',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: DataTable(
          columns: [
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Count')),
            DataColumn(label: Text('Time')),
            DataColumn(label: Text('Place')),
          ],
          rows: _data.map((rowData) {
            return DataRow(cells: [
              DataCell(Text(rowData['date'])),
              DataCell(Text(rowData['count'].toString())),
              DataCell(Text(rowData['time'])),
              DataCell(Text(rowData['place'])),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String imageUrl =
      'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50'; // Replace with the user's image URL
  final String firstName = 'John';
  final String lastName = 'Doe';
  final String address = '123 Main St, Anytown, USA';
  final String phoneNumber = '+1 (123) 123-1234';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 50,
            ),
            SizedBox(height: 20),
            Text(
              '$firstName $lastName',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Address:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              address,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Phone:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              phoneNumber,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
