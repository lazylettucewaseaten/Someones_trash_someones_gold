import 'package:flutter/material.dart';
import 'counsellorinfo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          HomeScreen(), // Set the initial screen to a different page if desired
      routes: {
        '/counsiller': (context) => CounsillerPage(), // Define the named route
        // Add other routes here as needed
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
                context, '/counsiller'); // Navigate to CounsillerPage
          },
          child: Text('Go to Profile Page'),
        ),
      ),
    );
  }
}

class CounsillerPage extends StatefulWidget {
  @override
  _CounsillerPageState createState() => _CounsillerPageState();
}

class _CounsillerPageState extends State<CounsillerPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  String userName = ''; // Store user name here
  String profilePicUrl =
      'https://classroomclipart.com/image/static7/preview2/graphic-sticker-of-cute-sun-over-a-cloud-64087.jpg'; // Replace with your image URL
  List<String> appointments = [];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  // Load user info from Supabase
  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        print('No user is logged in');
        setState(() {
          userName = 'Guest'; // Default to Guest if not logged in
        });
        return;
      }

      // Fetch user name from the 'profiles' table
      final response = await supabase
          .from('profiles')
          .select('name')
          .eq('id', user.id)
          .single();

      if (response != null) {
        setState(() {
          userName = response['name'] ?? 'Guest';
        });
      } else {
        print('User profile not found');
      }

      // Fetch appointments or any other data as needed
      // (replace this block with the actual logic for fetching appointments)
      setState(() {
        String response = prefs.getString('response') ??
            ''; // Default to empty if no appointment
        if (response.isNotEmpty) {
          appointments.add(response); // Add the appointment to the list
        }
      });
    } catch (error) {
      print('Error fetching user info: $error');
      setState(() {
        userName = 'Guest'; // Fall back to default value in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profilePicUrl),
              ),
            ),
            SizedBox(height: 16),
            // User's Name
            Text(
              userName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 16),
            // Previous Booked Appointments
            Text(
              'Previous Booked Appointments:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        appointments[index],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            // Navigate to Counselor Info Page Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the AI Companion Screen or Survey Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CounselorInfoScreen()), // Change to AICompanionScreen if needed
                  );
                },
                child: Text('View Counselor Info'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}