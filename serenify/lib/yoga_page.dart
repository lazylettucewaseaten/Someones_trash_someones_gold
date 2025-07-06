import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stress Relief App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => YogaPage()),
            );
          },
          child: Text('Yoga for Stress Relief'),
        ),
      ),
    );
  }
}

class YogaPage extends StatelessWidget {
  final List<Map<String, String>> yogaPoses = [
    {
      'title': "Child's Pose",
      'description':
          'Stretches the back and spine, releases tension in the chest, and relaxes muscles.',
      'image': 'assets/childs_pose.jpg',
    },
    {
      'title': 'Legs Up the Wall',
      'description':
          'Releases stress and fatigue, increases blood flow to the CNS.',
      'image': 'assets/legs_up_wall.jpg',
    },
    {
      'title': 'Corpse Pose',
      'description':
          'A stress-release pose often done at the end of a yoga session.',
      'image': 'assets/corpse_pose.jpg',
    },
    {
      'title': 'Paschimottanasana',
      'description':
          'Also known as Seated Forward Bend, relieves stress, anxiety, and anger.',
      'image': 'assets/paschimottanasana.jpg',
    },
    {
      'title': 'Standing Forward Fold (Uttanasana)',
      'description':
          'Removes tension in the neck, shoulders, and back, increases blood flow to the brain.',
      'image': 'assets/standing_forward_fold.jpg',
    },
    {
      'title': 'Cat and Cow Pose (Marjariasana)',
      'description':
          'Gently massages the spine and abdomen, relieving stress impacts.',
      'image': 'assets/cat_cow_pose.jpg',
    },
    {
      'title': 'Downward Facing Dog (Adho Mukha Svanasana)',
      'description':
          'Stretches the back, legs, and arms, and promotes spine alignment.',
      'image': 'assets/downward_dog.jpg',
    },
    {
      'title': 'Butterfly Pose (Baddha Konasana)',
      'description':
          'This pose relaxes the inner thighs and pelvic area, and when paired with deep breathing, it can also soothe your mind.',
      'image': 'assets/butterfly_pose.jpg',
    },
    {
      'title': 'Sukhasana (Easy Pose)',
      'description':
          'Sukhasana will lengthen your spine and open your hips. It will help you calm down and eliminate anxiety.',
      'image': 'assets/sukhasana.jpg',
    },
    {
      'title': 'Shoulderstand',
      'description':
          'An excellent yoga pose for relieving anxiety and depression, similar to downward-facing dog, as it increases blood flow.',
      'image': 'assets/shoulderstand.jpg',
    },
    {
      'title': 'Bhujangasana (Cobra Pose)',
      'description':
          'A reclining back-bending asana in hatha yoga and modern yoga, excellent for stretching the back and spine.',
      'image': 'assets/cobra_pose.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7EBAF8),
        title: Text('Yoga Poses'),
      ),
      body: ListView.builder(
        itemCount: yogaPoses.length,
        itemBuilder: (context, index) {
          final pose = yogaPoses[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    pose['image']!,
                    height: 180, // Set fixed height for all images
                    width: double.infinity,
                    fit: BoxFit.cover, // Ensures image covers the area
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pose['title']!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        pose['description']!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6F6F6F),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}