import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zen_quotes/gradient_container.dart';
//screenshot workkk
import 'package:screenshot/screenshot.dart';
import 'favorites_page.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  String quote = "Loading...";
  String author = "";
  bool isLoading = true;
  final Random random = Random();
  ScreenshotController screenshotController = ScreenshotController();
  /*Okay switching it to the Favourites tab and back i need smth to store the fav quotes
  its either screenshots or txt/string data ->> use this
  */
  List<String> favoriteQuotes = []; //fav quotes

  final List<Widget> _pages = [
    QuotesPage(),
    FavoritesPage(),
  ];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool isFavourite = false;
  //current gradient index
  int currentGradientIndex = 0;

  Future<void> fetchQuote() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse('https://zenquotes.io/api/random'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        setState(() {
          quote = data[0]['q'];
          author = data[0]['a'];
          isLoading = false;
          currentGradientIndex = random.nextInt(GradientData.gradients.length);
        });
      } else {
        setState(() {
          quote = "Failed to load quote. Press again.";
          author = "";
          isLoading = false;
        });
      }
    } catch (e) {
      // this would catch the errors
      setState(() {
        quote = "Error: ${e.toString()}";
        author = "";
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuote();
    // Initialize with a random gradient
    currentGradientIndex = random.nextInt(GradientData.gradients.length);
  }

/*
  Future<void> captureAndSaveScreenshot() async {
    final Uint8List? image = await screenshotController.capture();
    if (image == null) return;

    if (await _requestPermission()) {
      final result = await ImageGallerySaver.saveImage(image,
          quality: 100,
          name: "zen_quote_${DateTime.now().millisecondsSinceEpoch}");
      print("Saved to gallery: $result");
    } else {
      print("Permission denied!");
    }
  }

  Future<bool> _requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: GradientData.gradients[currentGradientIndex],
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  children: [
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Expanded(
                            child: GestureDetector(
                              onHorizontalDragEnd: (DragEndDetails details) {
                                if (details.primaryVelocity! > 0) {
                                  fetchQuote();
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    quote,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      height: 1.5,
                                      color: Color.fromRGBO(255, 255, 255, .7),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  if (author.isNotEmpty)
                                    Text(
                                      "~ $author",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.7),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: isFavourite ? Colors.red : Colors.white,
                      ),
                      iconSize: 35,
                      onPressed: () {
                        setState(() {
                          isFavourite = !isFavourite;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      iconSize: 35,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 20),
                    IconButton(
                      icon: const Icon(Icons.download, color: Colors.white),
                      iconSize: 35,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
        /*
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
        */
      ),
    );
  }
}
