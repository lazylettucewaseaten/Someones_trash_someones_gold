import 'package:flutter/material.dart';

class GuidedImageryPage extends StatefulWidget {
  const GuidedImageryPage({Key? key}) : super(key: key);

  @override
  _GuidedImageryPageState createState() => _GuidedImageryPageState();
}

class _GuidedImageryPageState extends State<GuidedImageryPage> {
  final List<String> _images = [
    'https://images.unsplash.com/photo-1507041957456-9c397ce39c97?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Forest path
    'https://images.unsplash.com/photo-1557456170-0cf4f4d0d362?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Lake view
    'https://images.unsplash.com/photo-1505142468610-359e7d316be0?q=80&w=2126&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Ocean waves
    'https://images.unsplash.com/photo-1723577434680-5f060c6a7e00?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Mountain view
    'https://images.unsplash.com/photo-1465156799763-2c087c332922?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Clouds
    'https://plus.unsplash.com/premium_photo-1724864863815-1469c8b74711?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Birds in forest
    'https://plus.unsplash.com/premium_photo-1667423049497-291580083466?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Meadow
    'https://images.unsplash.com/photo-1511860810434-a92f84c6f01e?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Desert oasis
    'https://images.unsplash.com/photo-1618824834789-eb5d98e150f8?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Winter landscape
    'https://images.unsplash.com/photo-1502675135487-e971002a6adb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8U3RhcnJ5JTIwTklnaHR8ZW58MHx8MHx8fDA%3D', // Starry night
    'https://images.unsplash.com/photo-1532920161727-344adb090f7f?q=80&w=1976&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Bamboo forest
    'https://images.unsplash.com/photo-1642861208331-f0a023f9e69d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8TW91bnRhdGluJTIwU3RyZWFtfGVufDB8fDB8fHww', // Mountain stream
    'https://images.unsplash.com/photo-1610112839736-c9bddb0d98c8?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8U3VucmlzZSUyME9jZWFufGVufDB8fDB8fHww', // Sunrise over ocean
    'https://images.unsplash.com/photo-1534710961216-75c88202f43e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8R2FyZGVufGVufDB8fDB8fHww', // Garden
    'https://images.unsplash.com/photo-1496942424442-a019cdf47341?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fFJvbGxpbmclMjBHcmVlZW4lMjBIaWxsc3xlbnwwfHwwfHx8MA%3D%3D', // Rolling green hills
  ];

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView with soothing images
          PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(_images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.4), // Overlay for text visibility
                  child: Center(
                    child: Text(
                      _getImageryText(index),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 6,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
          // Back button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous screen
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Returns text for guided imagery instructions
  String _getImageryText(int index) {
    switch (index) {
      case 0:
        return "Imagine yourself walking along a peaceful forest path.";
      case 1:
        return "Feel the warmth of the sun as you sit by a tranquil lake.";
      case 2:
        return "Visualize the waves gently lapping at the shore.";
      case 3:
        return "Picture yourself standing atop a mountain with a panoramic view.";
      case 4:
        return "Let yourself float above the clouds, weightless and serene.";
      case 5:
        return "Hear the sound of birds chirping in a lush forest.";
      case 6:
        return "Imagine a calm meadow with flowers swaying in the breeze.";
      case 7:
        return "Visualize yourself at a peaceful desert oasis.";
      case 8:
        return "Feel the serenity of a quiet winter landscape.";
      case 9:
        return "Picture a starry night sky above a tranquil countryside.";
      case 10:
        return "Imagine yourself in a bamboo forest with rustling leaves.";
      case 11:
        return "Feel the calm of a mountain stream flowing gently.";
      case 12:
        return "Visualize a sunrise over a peaceful ocean.";
      case 13:
        return "Imagine yourself in a beautiful garden with colorful flowers.";
      case 14:
        return "Feel the peace of being surrounded by rolling green hills.";
      default:
        return "Breathe deeply and relax.";
    }
  }
}
