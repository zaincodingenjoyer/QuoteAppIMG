import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zen_quotes/gradient_container.dart';
//screenshot workkk
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';

import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

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

  bool isFavourite = false;
  // Current gradient index
  int currentGradientIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchQuote();
    // Initialize with a random gradient
    currentGradientIndex = random.nextInt(GradientData.gradients.length);
  }

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: GradientData.gradients[currentGradientIndex],
              ),
            ),
          ),

          // Main Content
          Screenshot(
            controller: screenshotController,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ZEN QUOTES',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 40),
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Text(
                                    quote,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      height: 1.5,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  if (author.isNotEmpty)
                                    Text(
                                      "— $author",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                ],
                              ),
                            ),
                          ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: fetchQuote,
                      icon: const Icon(Icons.refresh),
                      label: const Text('New Quote'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Sidebar with icons
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 60, // Sidebar width
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: isFavourite ? Colors.red : Colors.lightBlueAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavourite = !isFavourite;
                      });
                      // Handle favorite action
                    },
                  ),
                  const SizedBox(height: 20),
                  IconButton(
                    icon:
                        const Icon(Icons.share, color: Colors.lightBlueAccent),
                    onPressed: () {
                      // Handle share action
                    },
                  ),
                  const SizedBox(height: 20),
                  IconButton(
                    icon: const Icon(Icons.download,
                        color: Colors.lightBlueAccent),
                    onPressed: () {
                      // Handle download action
                      captureAndSaveScreenshot();
                    },
                  ),
                  const SizedBox(height: 40), //padding near the bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
