import 'package:flutter/material.dart';

import './route_observer.dart';
import './view/list_page.dart';

void main() => runApp(MarkdownEditorApp());

class MarkdownEditorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[routeObserver],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: const Color(0xFFF850DD),
      ),
      home: NotesListPage(),
    );
  }
}
