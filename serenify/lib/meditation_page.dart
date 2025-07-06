import 'package:flutter/material.dart';
import 'dart:async';

class MeditationPage extends StatefulWidget {
  @override
  _MeditationPageState createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage> {
  Timer? _timer;
  int _remainingTime = 0;

  void _startTimer(int duration) {
    setState(() {
      _remainingTime = duration * 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          timer.cancel();
          _showEndDialog();
        }
      });
    });
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Time's Up"),
        content: Text("Hope you feel more relaxed!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget buildMeditationOption(String title, String description) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(description),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _startTimer(5),
                  child: Text("5 min"),
                ),
                ElevatedButton(
                  onPressed: () => _startTimer(10),
                  child: Text("10 min"),
                ),
                ElevatedButton(
                  onPressed: () => _startTimer(15),
                  child: Text("15 min"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7EBAF8),
        title: Text("Meditation"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_remainingTime > 0)
              Text(
                "Time Remaining: ${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}",
                style: TextStyle(fontSize: 24, color: Colors.blueAccent),
              ),
            Expanded(
              child: ListView(
                children: [
                  buildMeditationOption(
                    "Body Scan",
                    "Step 1: Find a comfortable position, sitting or lying down.\n"
                        "Step 2: Close your eyes and take a few deep breaths, relaxing your body with each exhale.\n"
                        "Step 3: Start by focusing on your toes. Notice any sensations, and slowly release tension as you breathe.\n"
                        "Step 4: Gradually move your attention up through your feet, legs, abdomen, chest, and so on, up to the top of your head.\n"
                        "Step 5: If your mind wanders, gently bring it back to the present body part.\n"
                        "Step 6: Take a final deep breath, bringing awareness to your entire body, and open your eyes when ready.",
                  ),
                  buildMeditationOption(
                    "Mindfulness Breathing",
                    "Step 1: Sit comfortably and close your eyes.\n"
                        "Step 2: Take a few deep breaths, allowing yourself to relax with each exhale.\n"
                        "Step 3: Focus your attention on your natural breathing rhythm.\n"
                        "Step 4: Notice the sensation of each inhale and exhale, feeling the air entering your nose and filling your lungs.\n"
                        "Step 5: If your mind drifts, gently bring your focus back to your breath without judgment.\n"
                        "Step 6: Continue this for the duration of the timer, cultivating calmness and clarity.",
                  ),
                  buildMeditationOption(
                    "Visualization",
                    "Step 1: Sit comfortably, close your eyes, and take a few deep breaths.\n"
                        "Step 2: Imagine yourself in a peaceful, calming place, such as a beach or a forest.\n"
                        "Step 3: Engage all senses in this place. Feel the ground under you, hear the sounds, and see the surroundings vividly.\n"
                        "Step 4: Let the peaceful energy of this place wash over you, releasing any tension.\n"
                        "Step 5: If your mind wanders, gently guide it back to the scene.\n"
                        "Step 6: When ready, take a deep breath and open your eyes, bringing calmness with you.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}