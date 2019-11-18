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

  // @override
  // void initState() {
  //   print('>>>>>initState()<<<<<');
  //   super.initState();
  //   _loadNotes().then((dynamic onValue) {
  //     setState(() {
  //       _notes = onValue;
  //     });
  //   }).catchError(print);
  //   print(_notes);
  // }

  Future<void> _loadNotes() async {
    final String jsonResponse =
        await DefaultAssetBundle.of(context).loadString('assets/text.json');

    setState(() {
      _notes = Note.allFromResponse(jsonResponse);
    });
  }

  Widget _buildNoteListTile(BuildContext context, int index) {
    final Note note = _notes[index];

    return ListTile(
      onTap: () => _navigateToNoteDetails(note, index),
      title: Text(note.title),
      subtitle: Text(formatter.format(note.date)),
    );
  }

  void _navigateToNoteDetails(
    Note note,
    Object index, {
    bool startEditing = false,
  }) {
    Navigator.of(context).push<dynamic>(
      MaterialPageRoute<dynamic>(
        builder: (BuildContext ctx) => FullPageEditorScreen(note, startEditing),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    _loadNotes();

    if (_notes?.isEmpty ?? true) {
      content = Center(child: const CircularProgressIndicator());
    } else {
      content = ListView.builder(
        itemCount: _notes?.length ?? 1,
        itemBuilder: _buildNoteListTile,
        // itemBuilder: (_, int index) => _buildNoteListTile(context, index),,
      );
    }

    final FlatButton add = FlatButton(
      onPressed: _addNote,
      child: const Text('ADD'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('MarkdownEditor'),
        actions: <Widget>[add],
      ),
      body: content,
    );
  }

  void _addNote() {
    final Note note = Note(
      title: '',
      text: Note.emptyText,
      date: DateTime.now(),
    );
    _navigateToNoteDetails(note, null, startEditing: true);
  }
}
