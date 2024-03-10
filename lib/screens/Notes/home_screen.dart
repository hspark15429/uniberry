import 'package:flutter/material.dart';
import 'package:gtk_flutter/screens/Notes/database.dart';

import 'add_note_screen.dart';
import 'note_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NoteModel> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() {
    DatabaseProvider.dbProvider.getNotes().then((loadedNotes) {
      setState(() {
        _notes = loadedNotes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNoteScreen()),
            ).then((_) => _loadNotes()), // 노트 추가 후 홈 화면 갱신
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.description),
            trailing: note.pinned ? Icon(Icons.push_pin) : null,
          );
        },
      ),
    );
  }
}