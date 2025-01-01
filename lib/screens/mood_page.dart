import 'package:flutter/material.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({Key? key}) : super(key: key);

  @override
  _MoodPageState createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {

  Widget _buildMoodCard({
    required IconData icon,
    required Color color,
    required String label,
    required String mood,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman '/addNote' dan meneruskan argumen mood
        Navigator.pushNamed(
          context,
          '/addNote',
          arguments: mood, // Mengirimkan nilai mood
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: color),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Mood'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bagaimana perasaan Anda hari ini?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMoodCard(
                  icon: Icons.sentiment_very_satisfied,
                  color: Colors.green,
                  label: 'Senang',
                  mood: 'happy',
                ),
                _buildMoodCard(
                  icon: Icons.sentiment_dissatisfied,
                  color: Colors.blue,
                  label: 'Sedih',
                  mood: 'sad',
                ),
                _buildMoodCard(
                  icon: Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                  label: 'Marah',
                  mood: 'angry',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
