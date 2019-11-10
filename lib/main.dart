import 'package:flutter/material.dart';

import './editor_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zefyr Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        '/editor': (BuildContext context) => EditorPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Start'),
      ),
      body: Center(
        child: FlatButton(
          child: const Text('Open Editor'),
          onPressed: () => navigator.pushNamed('/editor'),
        ),
      ),
    );
  }
}
