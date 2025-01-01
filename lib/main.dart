import 'package:flutter/material.dart';
import 'package:responsi_2/screens/add_notes.dart';
import 'package:responsi_2/screens/edit_notes_page.dart';
import 'package:responsi_2/screens/login_screen.dart';
import 'package:responsi_2/screens/mood_page.dart';
import 'package:responsi_2/screens/notes_list_page.dart';
import 'package:responsi_2/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Catatan Sederhana',
      // Gunakan FutureBuilder untuk menunggu hasil status login
      home: FutureBuilder<bool>(
        future: checkLoginStatus(),  // Memeriksa status login
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());  // Menunggu hasil
          } else if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan'));
          } else if (snapshot.hasData && snapshot.data == true) {
            return const NotesListPage();  // Jika sudah login
          } else {
            return const LoginPage();  // Jika belum login
          }
        },
      ),
      onGenerateRoute: (settings) {
        // Menangani rute dinamis
        if (settings.name?.startsWith('/editNote') == true) {
          final noteId = settings.name?.split('/').last; // Mengambil ID dari URL
          return MaterialPageRoute(
            builder: (context) => EditNotePage(noteId: noteId!), // Kirim ID ke EditNotePage
          );
        }
        return null;
      },
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/moodPage': (context) => const MoodPage(),
        '/listNotes': (context) => const NotesListPage(),
        '/addNote': (context) => const AddNotePage(),
      },
    );
  }

  // Fungsi untuk memeriksa apakah pengguna sudah login
  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // Mengecek apakah ada flag status login
    bool? isLoggedIn = prefs.getBool('isLoggedIn'); // Ganti token dengan flag login
    return isLoggedIn ?? false; // Jika flag login ada dan true, berarti sudah login
  }
}
