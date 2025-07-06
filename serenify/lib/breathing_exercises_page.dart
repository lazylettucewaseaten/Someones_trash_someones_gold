import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BreathingExercisesPage extends StatelessWidget {
  final List<Map<String, String>> _breathingExercises = [
    {
      'name': 'Sama Vritti Pranayama – Box Breathing',
      'description':
          'Box breathing balances oxygen and carbon dioxide levels by equalizing breaths, easing anxiety and stress.',
      'image': 'assets/box_breathing.jpg',
      'link': 'https://www.fitsri.com/pranayama/sama-vritti',
    },
    {
      'name': 'Anulom Vilom Pranayama – Alternate Breathing',
      'description':
          'This alternate nostril breathing balances both hemispheres of the brain, enhancing mental clarity and calm.',
      'image': 'assets/alternate_breathing.jpg',
      'link': 'https://www.fitsri.com/pranayama/anulom-vilom',
    },
    {
      'name': 'Ujjayi Pranayama – Ocean Breathing',
      'description':
          'With a focus on deep exhalation, this practice switches the body from stress to relaxation mode.',
      'image': 'assets/ocean_breathing.jpg',
      'link': 'https://www.fitsri.com/pranayama/ujjayi',
    },
    {
      'name': 'Sitali Pranayama – Cooling Breath',
      'description':
          'Known as the “Cooling Breath,” this exercise cools the body and calms the mind, reducing anxiety symptoms.',
      'image': 'assets/cooling_breath.jpg',
      'link': 'https://www.fitsri.com/pranayama/sitali',
    },
    {
      'name': 'Bhramari Pranayama – Bee Breathing',
      'description':
          'The humming sound of this technique reduces stress by calming overstimulated brain centers.',
      'image': 'assets/bee_breathing.jpg',
      'link': 'https://www.fitsri.com/pranayama/bhramari',
    },
  ];

  // Function to open URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7EBAF8),
        title: Text('Breathing Exercises'),
      ),
      body: ListView.builder(
        itemCount: _breathingExercises.length,
        itemBuilder: (context, index) {
          final exercise = _breathingExercises[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(exercise['image']!),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    exercise['name']!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    exercise['description']!,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => _launchURL(exercise['link']!),
                    child: Text('More Details'),
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