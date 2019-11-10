import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class EditorPage extends StatefulWidget {
  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _loadDocument().then((NotusDocument document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = _controller == null
        ? Center(child: CupertinoActivityIndicator())
        : ZefyrScaffold(
            child: ZefyrEditor(
              padding: const EdgeInsets.all(16),
              controller: _controller,
              focusNode: _focusNode,
            ),
          );
    // Note that the editor requires special `ZefyrScaffold` widget to be
    // one of its parents.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor page'),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) => IconButton(
              icon: Icon(Icons.save),
              onPressed: () => _saveDocument(context),
            ),
          )
        ],
      ),
      body: body,
    );
  }

  /// Loads the document asynchronously from a file if it exists, otherwise
  /// returns default document.
  Future<NotusDocument> _loadDocument() async {
    final File tempFile = File('${Directory.systemTemp.path}/quick_start.json');
    if (tempFile.existsSync()) {
      final String contents = await tempFile.readAsString();
      return NotusDocument.fromJson(jsonDecode(contents));
    }
    final Delta delta = Delta()..insert('Zefyr Quick Start\n');
    return NotusDocument.fromDelta(delta);
  }

  /// This function converts our document using jsonEncode()
  /// function and writes the result to a file quick_start.json
  /// in the system's temporary directory.
  void _saveDocument(BuildContext context) {
    /// Notus documents can be easily serialized to JSON by passing to
    /// `jsonEncode` directly
    final String contents = jsonEncode(_controller.document);
    // Save our document to a temporary file.
    final File tempFile = File('${Directory.systemTemp.path}/quick_start.json');

    // And show a snack bar on success.
    tempFile.writeAsString(contents).then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: const Text('Saved.'),
      ));
    });
  }
}
