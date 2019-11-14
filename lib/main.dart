import 'package:flutter/material.dart';

import './view/list_page.dart';

void main() => runApp(MarkdownEditorApp());

class MarkdownEditorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: const Color(0xFFF850DD),
      ),
      home: NotesListPage(),
    );
  }
}
