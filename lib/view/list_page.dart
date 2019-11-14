import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/note.dart';

import './full_page.dart';

class NotesListPage extends StatefulWidget {
  @override
  _NotesListPageState createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  List<Note> _notes = <Note>[];
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');

  @override
  void initState() {
    super.initState();
    _loadNotes().then((dynamic onValue) {
      setState(() {
        _notes = onValue;
      });
    }).catchError(print);
  }

  Future<void> _loadNotes() async {
    final String jsonResponse =
        await DefaultAssetBundle.of(context).loadString('assets/text.json');

    setState(() {
      _notes = Note.allFromResponse(jsonResponse);
    });
  }

  Widget _buildNoteListTile(BuildContext context, int index) {
    final Note note = _notes[index];
    print(note);

    return ListTile(
      onTap: () => _navigateToNoteDetails(note, index),
      title: Text(note.title),
      subtitle: Text(formatter.format(note.date)),
    );
  }

  void _navigateToNoteDetails(Note note, Object index) {
    Navigator.of(context).push<dynamic>(
      MaterialPageRoute<dynamic>(
        builder: (BuildContext ctx) => FullPageEditorScreen(note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_notes?.isEmpty ?? true) {
      content = Center(child: const CircularProgressIndicator());
    } else {
      content = ListView.builder(
        itemCount: _notes?.length ?? 1,
        itemBuilder: _buildNoteListTile,
        // itemBuilder: (_, int index) => _buildNoteListTile(context, index),,
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('MarkdownEditor')),
      body: content,
    );
  }
}
