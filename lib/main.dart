import 'package:flutter/material.dart';

import './full_page.dart';

void main() => runApp(MarkdownEditorApp());

class MarkdownEditorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zefyr Editor',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder>{'/fullPage': _buildFullPage},
    );
  }

  Widget _buildFullPage(BuildContext context) {
    return FullPageEditorScreen();
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NavigatorState nav = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.grey.shade200,
        brightness: Brightness.light,
        title: ZefyrLogo(),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: Container()),
          FlatButton(
            onPressed: () => nav.pushNamed('/fullPage'),
            child: const Text('Full page editor'),
            color: Colors.lightBlue,
            textColor: Colors.white,
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
