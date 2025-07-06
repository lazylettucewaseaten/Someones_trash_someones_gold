import 'package:flutter/material.dart';
import 'profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  String profilePicUrl =
      'https://classroomclipart.com/image/static7/preview2/graphic-sticker-of-cute-sun-over-a-cloud-64087.jpg'; // Initial Profile Picture
  String name = ''; // Initially empty name
  String? selectedAbout; // Variable to hold selected item from dropdown
  bool isPrivacyPolicyExpanded = false; // Variable to manage dropdown state
  bool isAboutAppExpanded =
      false; // Variable to manage about app dropdown state

  final List<String> aboutOptions = [
    'Version 1.0',
    'Version 1.1',
    'Version 1.2',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  // Load user info from Supabase
  Future<void> _loadUserInfo() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        print('No user is logged in');
        setState(() {
          name = 'Guest'; // Default to Guest if not logged in
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
          name = response['name'] ?? 'Guest';
        });
      } else {
        print('User profile not found');
      }
    } catch (error) {
      print('Error fetching user info: $error');
      setState(() {
        name = 'Guest'; // Fall back to default value in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        // Back button that navigates to ProfilePage
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            ); // Navigate to ProfilePage
          },
        ),
      ),
     body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Picture
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profilePicUrl),
              ),
              SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        // Change Profile Picture Button
        SizedBox(height: 20),
        SizedBox(height: 16),
        // About App Dropdown
        GestureDetector(
          onTap: () {
            setState(() {
              isAboutAppExpanded = !isAboutAppExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'About App',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Icon(
                isAboutAppExpanded
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
              ),
            ],
          ),
        ),
        if (isAboutAppExpanded) ...[
          SizedBox(height: 8),
          Text(
            'Welcome to our app, a comprehensive platform designed to enhance mental well-being, provide stress-relief techniques, and support your journey toward a balanced and productive life.\n\n'
            'Features:\n\n'
            '1. Relaxation Techniques:\n'
            '   - Integrates scientifically-backed methods like guided breathing exercises, mindfulness sessions, and meditation to help you combat stress and unwind effectively.\n\n'
            '2. Dynamic Redirecting Techniques:\n'
            '   - Seamless navigation guides you intuitively across various sections of the app based on your preferences and interactions.\n\n'
            '3. Secure Password Hashing:\n'
            '   - Ensures your data privacy with robust encryption methods to keep your sensitive information secure.\n\n'
            '4. Future Updates:\n'
            '   - Expect AI-driven recommendations, wearable device integration, expanded counselor access, and much more in upcoming versions.\n\n'
            '5. Interactive Backgrounds:\n'
            '   - Enjoy visually appealing, calming, and interactive backgrounds that enhance your overall experience.\n\n'
            '6. Counselor Assistance:\n'
            '   - Connect with professional counselors for tailored guidance and strategies to support your mental health.\n\n'
            '7. Group Text Support:\n'
            '   - Engage with a community to share experiences, exchange advice, and participate in group relaxation sessions.\n\n'
            'This app is your companion in achieving mental well-being and growth. Explore, engage, and evolve with features crafted for your journey.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Current Version: ${aboutOptions[0]}', // Display the first version by default
            style: TextStyle(fontSize: 16),
          ),
        ],
        SizedBox(height: 16),
        // Privacy Policy Section
        GestureDetector(
          onTap: () {
            setState(() {
              isPrivacyPolicyExpanded = !isPrivacyPolicyExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Icon(
                isPrivacyPolicyExpanded
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
              ),
            ],
          ),
        ),
        if (isPrivacyPolicyExpanded) ...[
  SizedBox(height: 8),
  Text(
    'Your privacy is our top priority. We are committed to safeguarding your personal information and maintaining your trust. Here are some of the key measures we take to protect your data:\n\n'
    '1. **Password Security**:\n'
    '   - All passwords are securely hashed using industry-standard encryption algorithms. This ensures that your password is never stored in plain text and remains inaccessible to unauthorized parties.\n\n'
    '2. **Secure Database**:\n'
    '   - Your data is stored in a highly secure database with multiple layers of protection, including encryption at rest and in transit. This ensures that your information is safe, even in the unlikely event of a security breach.\n\n'
    '3. **Data Access Controls**:\n'
    '   - Access to your personal data is restricted to authorized personnel only. We use role-based access control to minimize exposure and maintain strict confidentiality.\n\n'
    '4. **User Consent**:\n'
    '   - We only collect and use data that you have explicitly consented to share with us. You have full control over your data and can update or delete your account at any time.\n\n'
    '5. **Regular Security Audits**:\n'
    '   - Our systems undergo regular security audits and updates to identify and resolve vulnerabilities. We stay up-to-date with the latest security practices to provide a safe environment for our users.\n\n'
    '6. **Anonymous Usage Data**:\n'
    '   - We may collect anonymized data to improve our services, but this data cannot be traced back to you personally.\n\n'
    '7. **Transparency**:\n'
    '   - You can access and review our full privacy policy to understand how your data is handled. We are committed to maintaining transparency in all aspects of data security.\n\n'
    'By using this app, you agree to our privacy practices designed to keep your information secure and private. If you have any concerns or questions about your data, feel free to contact us.',
    style: TextStyle(fontSize: 16),
  ),
],
      ],
    ),
  ),
),

    );
  }
}