import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'settings.dart';
import 'survey.dart';
import 'main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String profilePicUrl = 'https://via.placeholder.com/150';
  String userName = '';
  int _stressLevel = 0;
  List<Map<String, dynamic>> _diaryEntries = [];
  final TextEditingController _diaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _fetchDiaryEntries();
  }

  Future<void> _loadProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user logged in')),
        );
        return;
      }

      final profile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      if (profile == null) {
        throw Exception('Profile not found');
      }

      int storedStressLevel = prefs.getInt('stressLevel') ?? 100;

      int currentTimeProfile = prefs.getInt('time_profile') ?? 0;
      int previousTimeProfile = prefs.getInt('previous_time_profile') ?? -1;

      if (currentTimeProfile != previousTimeProfile) {
        int stressReduction = (currentTimeProfile / 60).floor();
        storedStressLevel = (storedStressLevel - stressReduction).clamp(0, 100);

        await prefs.setInt('stressLevel', storedStressLevel);
        await prefs.setInt('previous_time_profile', currentTimeProfile);
      }

      setState(() {
        userName = profile['name'] ?? 'User';
        _stressLevel = storedStressLevel;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  Future<void> _fetchDiaryEntries() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final response = await Supabase.instance.client
          .from('diaries')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      setState(() {
        _diaryEntries = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching diary entries: $e')),
      );
    }
  }

  Future<void> _addDiaryEntry(String content) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final response = await Supabase.instance.client.from('diaries').insert({
        'user_id': user.id,
        'content': content,
      });

      if (response != null) {
        _diaryController.clear();
        _fetchDiaryEntries();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding diary entry: $e')),
      );
    }
  }

  void _signOut() async {
    await Supabase.instance.client.auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyApp()), // Navigate to the main app or login page
      (Route<dynamic> route) => false,
    );
  }

  void _navigateToSurvey() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AICompanionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/secondbg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profilePicUrl),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Stress Level: $_stressLevel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: _stressLevel / 100,
                    minHeight: 20,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _stressLevel > 70 ? Colors.red : Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Buttons for Sign Out and Survey
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _signOut,
                      child: Text('Sign Out'),
                    ),
                    ElevatedButton(
                      onPressed: _navigateToSurvey,
                      child: Text('Take Survey'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      Text(
                        'Diary:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextField(
                        controller: _diaryController,
                        decoration: InputDecoration(
                          hintText: 'Write your diary here...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_diaryController.text.isNotEmpty) {
                            _addDiaryEntry(_diaryController.text);
                          }
                        },
                        child: Text('Save Diary'),
                      ),
                      ..._diaryEntries.map((entry) => Card(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry['content'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 8),
                                  
                                ],
                              ),
                            ),
                          )),
                    ],
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
