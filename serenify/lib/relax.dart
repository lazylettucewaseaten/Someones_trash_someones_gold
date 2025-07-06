import 'package:flutter/material.dart';
import 'dart:async';
import 'music_screen.dart';
import 'yoga_page.dart';
import 'breathing_exercises_page.dart';
import 'meditation_page.dart';
import 'guidedimagery.dart'; // Import Guided Imagery page

class ActivitySuggestionsScreen extends StatefulWidget {
  final Function(int) onReturnTimeSpent;

  ActivitySuggestionsScreen({required this.onReturnTimeSpent});

  @override
  _ActivitySuggestionsScreenState createState() =>
      _ActivitySuggestionsScreenState();
}

class _ActivitySuggestionsScreenState extends State<ActivitySuggestionsScreen> {
  int _timeSpent = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeSpent++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    _stopTimer();
    widget
        .onReturnTimeSpent(_timeSpent); // Pass the time spent back to homepage
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF7EBAF8),
          title: Text(
            'Activity Recommendations',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text('Time Spent: $_timeSpent seconds',
                  style: TextStyle(fontSize: 20)),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ActivityCard(
                      imagePath: 'assets/yoga.png',
                      label: 'Yoga',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => YogaPage()),
                        );
                      },
                    ),
                    ActivityCard(
                      imagePath: 'assets/music.png',
                      label: 'Music',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MusicScreen()),
                        );
                      },
                    ),
                    ActivityCard(
                      imagePath: 'assets/breathing.png',
                      label: 'Breathing Exercises',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BreathingExercisesPage()),
                        );
                      },
                    ),
                    ActivityCard(
                      imagePath: 'assets/meditation.png',
                      label: 'Meditation',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MeditationPage()),
                        );
                      },
                    ),
                    ActivityCard(
                      imagePath: 'assets/guided_imagery.png', // Add a relevant image asset
                      label: 'Guided Imagery',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GuidedImageryPage()),
                        );
                      },
                    ),
                    // Additional Activity Cards here
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  ActivityCard({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Image.asset(imagePath, width: 50, height: 50),
        title: Text(label, style: TextStyle(fontSize: 18)),
        onTap: onTap,
      ),
    );
  }
}
