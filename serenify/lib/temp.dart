import 'package:flutter/material.dart';
import 'chat.dart';
import 'book_appointment.dart';
import 'profile.dart';
import 'relax.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  double _stressPercentage = 60.0; // Default stress percentage
  int _timeSpentInRelaxation = 0;

  @override
  void initState() {
    super.initState();
    _loadStressLevel(); // Load the stress level from SharedPreferences
  }

  // Function to load the stress level from SharedPreferences
  Future<void> _loadStressLevel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _stressPercentage = prefs.getDouble('stressLevel') ??
          60.0; // Use default value if not set
    });
  }

  // Callback for navigation item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Update the time spent in relaxation
  void _updateTimeSpent(int timeSpent) {
    setState(() {
      _timeSpentInRelaxation = timeSpent;
    });
    _saveTimeSpent(timeSpent); // Save the time to SharedPreferences
  }

  // Function to save the time spent in relaxation to SharedPreferences
  Future<void> _saveTimeSpent(int timeSpent) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('time_profile', timeSpent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://wallpapers.com/images/hd/mount-fuji-lake-japan-4k-0vknx3r8nalstf1c.jpg',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), // Adjust opacity here
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 20.0), // Increased top padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40), // Added space above Stress Level
                // Stress Meter
                Text(
                  'Stress Level',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                LinearProgressIndicator(
                  value: _stressPercentage / 100,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  color: _stressPercentage > 70 ? Colors.red : Colors.blue,
                ),
                SizedBox(height: 5),
                Text(
                  '${_stressPercentage.toStringAsFixed(0)}%',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(height: 40), // Added space above the image

                // Center the image and button
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              width: 150, // Set desired width
                              height: 150, // Set desired height
                              child: Image.network(
                                'https://img.freepik.com/free-vector/cute-dog-sticking-her-tongue-out-cartoon-icon-illustration_138676-2709.jpg',
                                fit: BoxFit.cover, // Ensures the image fills the box
                              ),
                            ),
                          ),
                      ),
                      SizedBox(height: 20), // Increased space above the button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActivitySuggestionsScreen(
                                onReturnTimeSpent: _updateTimeSpent,
                              ),
                            ),
                          );
                        },
                        child: Text('Commence Relaxation'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        "Time spent in relaxation recently: $_timeSpentInRelaxation seconds",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom navigation buttons
          Positioned(
            bottom: 20, // Position from the bottom of the screen
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    _onItemTapped(0);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  child: Text('Profile'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    foregroundColor: Colors.white,
                    backgroundColor:
                        _selectedIndex == 0 ? Colors.blue : Colors.grey,
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                    );
                  },
                  child: Text('Chat'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    foregroundColor: Colors.white,
                    backgroundColor:
                        _selectedIndex == 1 ? Colors.blue : Colors.grey,
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _onItemTapped(2);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CounsillerPage()),
                    );
                  },
                  child: Text('Counselor'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    foregroundColor: Colors.white,
                    backgroundColor:
                        _selectedIndex == 2 ? Colors.blue : Colors.grey,
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}