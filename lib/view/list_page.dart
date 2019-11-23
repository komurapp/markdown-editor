import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/note.dart';

import '../persistance/file_manager.dart';
import '../route_observer.dart';
import './full_page.dart';

class NotesListPage extends StatefulWidget {
  @override
  _NotesListPageState createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> with RouteAware {
  List<Note> _notes = <Note>[];
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');

  @override
  void initState() {
    print('>>>>>initState()<<<<<');
    super.initState();
    _loadNotes().then((dynamic onValue) {
      if (onValue.length == 0) {
        _loadFakeNote().then((dynamic onValue) {
          _notes = onValue;
        });
      } else {
        setState(() {
          _notes = onValue;
        });
      }
    }).catchError(print);
    print(_notes);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<List<Note>> _loadFakeNote() async {
    final String response =
        await DefaultAssetBundle.of(context).loadString('assets/text.json');
    final List<Note> notes = Note.allFromResponse(response);

    return notes;
  }

  Future<void> _loadNotes() async {
    final FileManager fm = FileManager();
    final List<Note> jsonResponse = await fm.getNotes();

    setState(() {
      _notes = jsonResponse;
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

  // Called when the top route has been popped off, and the current route shows up.
  @override
  void didPopNext() {
    _loadNotes().then((dynamic onValue) {
      if (onValue.length == 0) {
        _loadFakeNote().then((dynamic onValue) {
          _notes = onValue;
        }).catchError(print);
      } else {
        setState(() {
          _notes = onValue;
        });
      }
    }).catchError(print);
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
      id: 1,
      title: '',
      text: Note.emptyText,
      date: DateTime.now(),
    );
    _navigateToNoteDetails(note, null, startEditing: true);
  }
}
