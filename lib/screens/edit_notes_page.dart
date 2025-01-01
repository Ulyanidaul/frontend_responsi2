import 'package:flutter/material.dart';
import 'package:responsi_2/services/api_services.dart';

class EditNotePage extends StatefulWidget {
  final String noteId;
  
  const EditNotePage({Key? key, required this.noteId}) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _mood;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  // Fungsi untuk memuat data catatan yang akan diedit
  void _loadNote() async {
    final note = await ApiService.getNoteById(widget.noteId);
    if (note != null) {
      setState(() {
        _titleController.text = note['title'];
        _descriptionController.text = note['description'];
        _mood = note['mood'];
      });
    }
  }

  // Fungsi untuk menyimpan perubahan pada catatan
 void _saveNote() async {
  final title = _titleController.text;
  final description = _descriptionController.text;
  final mood = _mood ?? 'neutral'; // Jika mood tidak dipilih, defaultkan ke 'neutral'

  if (title.isNotEmpty && description.isNotEmpty) {
    final success = await ApiService.updateNote(
      widget.noteId,  // Mengirimkan ID catatan yang diteruskan dari NotesListPage
      title, 
      description, 
      mood,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan berhasil diperbarui')),
      );
      Navigator.pop(context, true); // Kembali ke halaman daftar catatan setelah berhasil disimpan
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui catatan')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Judul dan deskripsi tidak boleh kosong')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Catatan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
