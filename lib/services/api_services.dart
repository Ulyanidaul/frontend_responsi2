import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  /// URL dasar API
  static const String authbaseUrl = "http://192.168.137.138:8000/api/auth/login"; // Ganti dengan URL server Anda
  static const String notesbaseUrl = "http://192.168.137.138:8000/api/notes";

  // Login
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse(authbaseUrl);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['message'] == 'berhasil login') {
        // Respons backend menunjukkan login berhasil
        return true;
      } else {
        // Respons backend menunjukkan login gagal
        return false;
      }
    } catch (e) {
      print('Error: $e');
      throw Exception("Login gagal: Periksa koneksi atau backend Anda.");
    }
  }


static Future<List<Map<String, dynamic>>> getNotes() async {
  try {
    final response = await http.get(Uri.parse(notesbaseUrl));
    if (response.statusCode == 200) {
      // Decode response body
      Map<String, dynamic> responseBody = json.decode(response.body);

      // Pastikan ada key 'tasks' dan nilainya adalah List
      if (responseBody.containsKey('tasks') && responseBody['tasks'] is List) {
        List<dynamic> tasks = responseBody['tasks'];

        // Map setiap elemen ke Map<String, dynamic>
        return tasks.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception('Response tidak valid: Tidak ada key "tasks"');
      }
    } else {
      throw Exception('Gagal memuat catatan: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Terjadi kesalahan: $e');
  }
}


  // Fungsi untuk menambahkan catatan
  static Future<bool> addNote(String userId, String title, String content,
      String mood, String date) async {
    try {
      final response = await http.post(
        Uri.parse(notesbaseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "userId": userId,
          "title": title,
          "description": content,
          "mood": mood,
          "created_at": date,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Fungsi untuk mengupdate catatan
  static Future<bool> updateNote(String id, String title, String description, String mood) async {
    final url = Uri.parse('$notesbaseUrl/$id');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': title,
          'description': description,
          'mood': mood,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Fungsi untuk mendapatkan catatan berdasarkan ID
  static Future<Map<String, dynamic>?> getNoteById(String id) async {
    final url = Uri.parse('$notesbaseUrl/$id');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Mengembalikan data catatan
      } else {
        print('Error: ${response.body}');
        return null; // Catatan tidak ditemukan
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Fungsi untuk menghapus catatan
  static Future<bool> deleteNote(String id) async {
    final url = Uri.parse('$notesbaseUrl/$id');
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Register
  static Future<void> register(
      String name, String email, String phone, String password) async {
    final url = Uri.parse("http://192.168.137.138:8000/api/auth/register");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Pendaftaran berhasil: ${data['message']}');
      } else {
        final error = json.decode(response.body);
        throw Exception(
            "Pendaftaran gagal: ${error['message'] ?? 'Kesalahan server'}");
      }
    } catch (e) {
      throw Exception("Pendaftaran gagal: $e");
    }
  }
}
