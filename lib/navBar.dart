import 'package:flutter/material.dart';

import 'favorites_page.dart';
import 'quotes_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Show the appropriate page based on the selected index
        body: _selectedIndex == 0 ? QuotesPage() : FavoritesPage(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.format_quote, size: 30),
              label: "QUOTES",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, size: 30),
              label: "FAVORITES",
            ),
          ],
        ),
      ),
    );
  }
}
