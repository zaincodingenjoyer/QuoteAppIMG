import 'package:flutter/material.dart';
import 'quotes_page.dart';

class QuotesApp extends StatelessWidget {
  const QuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zen Quotes',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: QuotesPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
