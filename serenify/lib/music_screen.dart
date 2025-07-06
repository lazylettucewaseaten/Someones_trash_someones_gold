import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicScreen extends StatelessWidget {
  final List<Map<String, String>> _musicFiles = [
    {'title': 'Zen Cascade', 'link': 'https://pixabay.com/music/meditationspiritual-zen-cascade-meditation-spa-relaxation-music-252902/'},
    {'title': 'Relaxing Piano', 'link': 'https://pixabay.com/music/modern-classical-relaxing-piano-music-248868/'},
    {'title': 'Inspirational Uplifting', 'link': 'https://pixabay.com/music/modern-classical-inspirational-uplifting-calm-piano-254764/'},
    {'title': 'Carol of the Bells', 'link': 'https://pixabay.com/th/music/carol-of-the-bells-background-christmas-music-for-video-bells-ver-254194/'},
    {'title': 'Deck the Halls', 'link': 'https://pixabay.com/th/music/deck-the-halls-background-christmas-music-for-video-vlog-60sec-172531/'},
    {'title': 'Lofi Study Chill', 'link': 'https://pixabay.com/th/music/lofi-study-calm-peaceful-chill-hop-112191/'},
    {'title': 'Calm Soul', 'link': 'https://pixabay.com/th/music/calm-soul-meditation-247330/'},
    {'title': 'Peace of Mind', 'link': 'https://pixabay.com/th/music/peace-of-mind-254203/'},
    {'title': 'Weeknds', 'link': 'https://pixabay.com/th/music/weeknds-122592/'},
    {'title': 'Where\'s My Love', 'link': 'https://pixabay.com/th/music/wherex27s-my-love-soft-piano-music-248975/'},
  ];

  Future<void> _openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7EBAF8),
        title: Text('Music'),
      ),
      body: ListView.builder(
        itemCount: _musicFiles.length,
        itemBuilder: (context, index) {
          final track = _musicFiles[index];
          return ListTile(
            title: Text(track['title']!),
            trailing: Icon(Icons.link),
            onTap: () => _openLink(track['link']!),
          );
        },
      ),
    );
  }
}