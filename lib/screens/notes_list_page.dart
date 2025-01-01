import 'package:flutter/material.dart';
import 'package:responsi_2/services/api_services.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({Key? key}) : super(key: key);

  @override
  _NotesListPageState createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  late Future<List<Map<String, dynamic>>> notesFuture;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Memuat data catatan
  void _loadNotes() {
    setState(() {
      notesFuture = ApiService.getNotes();  // Pastikan nama fungsi sesuai dengan yang ada di ApiService
    });
  }

  // Mengambil mood icon berdasarkan nilai mood
  IconData _getMoodIcon(String mood) {
    switch (mood) {
      case 'happy':
        return Icons.sentiment_very_satisfied;
      case 'sad':
        return Icons.sentiment_dissatisfied;
      case 'angry':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

  // Fungsi untuk menghapus catatan
  void _deleteNote(String id) async {
    bool isDeleted = await ApiService.deleteNote(id);
    if (isDeleted) {
      _loadNotes(); // Muat ulang daftar catatan setelah penghapusan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus catatan')),
      );
    }
  }

  // Fungsi untuk mengedit catatan
  void _editNote(String id) async {
    final selectedNote = await Navigator.pushNamed(context, '/editNote', arguments: id);
    if (selectedNote != null) {
      _loadNotes(); // Muat ulang data setelah mengedit catatan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Catatan'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(  // Perbaiki handling null data
        future: notesFuture,
        builder: (context, snapshot) {
          // Menunggu data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Menangani error
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          // Tidak ada data
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada catatan.'));
          }

          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                leading: Icon(
                  _getMoodIcon(note['mood'] ?? 'neutral'),
                  size: 40,
                ),
                title: Text(note['title'] ?? 'Tanpa Judul'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(note['description'] ?? 'Deskripsi tidak tersedia'),
                    Text(
                      note['created_at'] ?? 'Tanggal tidak tersedia',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Mengedit catatan
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editNote(note['id']?.toString() ?? ''),
                    ),
                    // Menghapus catatan
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteNote(note['id']?.toString() ?? ''),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman AddNotePage saat tombol ditekan
          Navigator.pushNamed(context, '/addNote');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
