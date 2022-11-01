import 'package:flutter/material.dart';
import 'package:stick_slash/binders_page.dart';
import 'package:stick_slash/search_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StickSlash',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.red[600],
      ),
      home: const Layout(title: 'Stick Slash'),
    );
  }
}

// It's the main object
class Layout extends StatefulWidget {
  const Layout({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    HomePage(
      key: Key("HomePage"),
    ),
    AllCardsPage(
      key: Key("AllCards"),
    ),
    Binder(
      key: Key("Binders"),
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Binders",
          ),
          // TODO: Add Settings
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.red[600],
        selectedItemColor: Colors.white,
      ),
    );
  }
}
