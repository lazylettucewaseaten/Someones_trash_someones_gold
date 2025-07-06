import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BubblePopGame(),
    );
  }
}

class BubblePopGame extends StatefulWidget {
  const BubblePopGame({Key? key}) : super(key: key);

  @override
  State<BubblePopGame> createState() => _BubblePopGameState();
}

class _BubblePopGameState extends State<BubblePopGame>
    with TickerProviderStateMixin {
  final List<Bubble> bubbles = [];
  int score = 0;
  late Timer gameTimer;
  late Timer cleanupTimer; // New timer for cleanup
  final Random random = Random();
  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    // Timer for adding new bubbles
    gameTimer = Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      if (bubbles.length < 10) {
        addBubble();
      }
    });

    // Timer for checking and removing completed bubbles
    cleanupTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      cleanupBubbles();
    });
  }

  void cleanupBubbles() {
    if (!mounted) return;

    setState(() {
      bubbles.removeWhere((bubble) {
        if (bubble.controller.status == AnimationStatus.completed) {
          bubble.controller.dispose();
          score -= 5; // Penalty for missing a bubble
          return true;
        }
        return false;
      });
    });
  }

  void addBubble() {
    if (!mounted) return;

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    setState(() {
      final controller = AnimationController(
        duration: const Duration(seconds: 4),
        vsync: this,
      );

      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          cleanupBubbles();
        }
      });

      bubbles.add(
        Bubble(
          x: random.nextDouble() * (screenWidth - 60),
          y: 0,
          color: Colors.primaries[random.nextInt(Colors.primaries.length)],
          controller: controller..forward(),
        ),
      );
    });
  }

  void popBubble(int index) {
    setState(() {
      bubbles[index].controller.dispose();
      bubbles.removeAt(index);
      score += 10;
      HapticFeedback.lightImpact();
    });
  }

  @override
  void dispose() {
    gameTimer.cancel();
    cleanupTimer.cancel();
    for (var bubble in bubbles) {
      bubble.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SafeArea(
        child: Stack(
          children: [
            // Back Button
            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context); // Navigate back to the previous screen
                },
              ),
            ),
            // Score Display
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Score: $score',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: score < 0 ? Colors.red : Colors.black,
                  ),
                ),
              ),
            ),
            // Bubbles
            ...bubbles.asMap().entries.map((entry) {
              final index = entry.key;
              final bubble = entry.value;

              return AnimatedBuilder(
                animation: bubble.controller,
                builder: (context, child) {
                  return Positioned(
                    left: bubble.x,
                    bottom: bubble.y +
                        (bubble.controller.value * screenHeight * 0.8),
                    child: GestureDetector(
                      onTapDown: (_) => popBubble(index),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: bubble.color.withOpacity(0.7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class Bubble {
  final double x;
  final double y;
  final Color color;
  final AnimationController controller;

  Bubble({
    required this.x,
    required this.y,
    required this.color,
    required this.controller,
  });
}
