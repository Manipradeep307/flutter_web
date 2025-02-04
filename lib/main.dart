import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _urlController = TextEditingController();
  String? _imageUrl;
  bool _isMenuOpen = false;

  void _loadImage() {
    setState(() {
      _imageUrl = _urlController.text;
    });
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _closeMenu() {
    if (_isMenuOpen) {
      setState(() {
        _isMenuOpen = false;
      });
    }
  }

  void _toggleFullScreen(BuildContext context) {
    if (_imageUrl != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenImage(imageUrl: _imageUrl!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _closeMenu,
      child: Scaffold(
        backgroundColor: _isMenuOpen ? Colors.black.withOpacity(0.5) : Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
          child: Column(
            children: [
              // Display image at the top if URL is loaded
              if (_imageUrl != null)
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('Failed to load image'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              if (_imageUrl == null) const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        hintText: 'Image URL',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _loadImage,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Icon(Icons.arrow_forward),
                    ),
                  ),
                ],
              ),
              // Spacer to push the TextField down when image is displayed
              if (_imageUrl != null) const SizedBox(height: 20),
              if (_imageUrl == null) const Spacer(),
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: [
            if (_isMenuOpen)
              Positioned(
                bottom: 100, 
                right: 16,
                child: Column(
                  children: [
                    FloatingActionButton.extended(
                      heroTag: 'enter_fs',
                      label: const Text('Enter Fullscreen'),
                      onPressed: () {
                        _toggleFullScreen(context);
                        _closeMenu();
                      },
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.extended(
                      heroTag: 'exit_fs',
                      label: const Text('Exit Fullscreen'),
                      onPressed: () {
                        _closeMenu();
                      },
                    ),
                  ],
                ),
              ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: _toggleMenu,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'Failed to load image',
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.fullscreen_exit),
            ),
          ),
        ],
      ),
    );
  }
}