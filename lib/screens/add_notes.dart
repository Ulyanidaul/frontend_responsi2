import 'package:flutter/material.dart';
import 'package:responsi_2/services/api_services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  bool isLoading = false;

  Future<String> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      if (userId == null || userId.isEmpty) {
        throw Exception('User ID tidak ditemukan. Harap login terlebih dahulu.');
      }
      return userId;
    } catch (e) {
      throw Exception('Gagal mengambil User ID: $e');
    }
  }

  Future<void> saveNote() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Validasi input
    if (titleController.text.isEmpty) {
      _showErrorDialog('Judul tidak boleh kosong');
      setState(() => isLoading = false);
      return;
    }
    if (contentController.text.isEmpty) {
      _showErrorDialog('Isi catatan tidak boleh kosong');
      setState(() => isLoading = false);
      return;
    }

    try {
      final userId = await getUserId();
      print('User ID: $userId');
      print('Judul: ${titleController.text}');
      print('Isi: ${contentController.text}');
      print('Tanggal: $currentDate');

      final isAdded = await ApiService.addNote(
        userId,
        titleController.text.trim(),
        contentController.text.trim(),
        '',
        currentDate,
      );

      if (isAdded) {
        print('Catatan berhasil ditambahkan');
        Navigator.pushReplacementNamed(context, '/listNotes'); // Kembali ke halaman daftar catatan
      } else {
        throw Exception('Gagal menyimpan catatan');
      }
    } catch (e) {
      _showErrorDialog('Gagal menambah catatan: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tanggal: $currentDate',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Catatan',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Isi Catatan',
                    prefixIcon: Icon(Icons.edit),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : saveNote,
                    child: isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text('Tambah Catatan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
