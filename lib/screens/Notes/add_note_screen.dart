import 'package:flutter/material.dart';
import 'package:gtk_flutter/screens/Notes/database.dart';

import 'note_model.dart';


class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _saveNote() {
    final String title = _titleController.text;
    final String description = _descriptionController.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      final NoteModel note = NoteModel(
        title: title,
        description: description,
        creationDate: DateTime.now().toString(),
        pinned: false,
        color: 'white', // 기본 색상, 추후 색상 선택 기능 추가 가능
      );
      DatabaseProvider.dbProvider.insertNote(note).then(
            (storedNote) => Navigator.of(context).pop(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Title'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(hintText: 'Description'),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}