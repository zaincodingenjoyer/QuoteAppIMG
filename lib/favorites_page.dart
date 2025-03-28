import 'package:flutter/material.dart';
//import 'quotes_page.dart'; // Import your Quotes page

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Quotes"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }
}
