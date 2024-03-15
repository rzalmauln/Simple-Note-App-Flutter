import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/pages/add_edit_note_page.dart';

class NodeDetailPage extends StatefulWidget {
  const NodeDetailPage({super.key, required this.id});
  final int id;

  @override
  State<NodeDetailPage> createState() => _NodeDetailPageState();
}

class _NodeDetailPageState extends State<NodeDetailPage> {
  late Note _note;
  var _isLoading = false;

  Future<void> _refreshNotes() async {
    setState(() {
      _isLoading = true;
    });
    _note = await NoteDatabase.instance.getNoteById(widget.id);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
        actions: [_editButton(), _deleteButton()],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Text(
                  _note.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(DateFormat.yMMMd().format(_note.createdTime)),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  _note.description,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
    );
  }

  Widget _editButton() {
    return IconButton(
        onPressed: () async {
          if (_isLoading) return;
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddEditNotePage(
                        note: _note,
                      )));
          _refreshNotes();
        },
        icon: const Icon(Icons.edit_outlined));
  }

  Widget _deleteButton() {
    return IconButton(
        onPressed: () async {
          if (_isLoading) return;
          await NoteDatabase.instance.deleteNoteById(widget.id);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.delete));
  }
}
