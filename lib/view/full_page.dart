import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zefyr/zefyr.dart';

import '../model/note.dart';

class ZefyrLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[Text('MarkdownEditor')],
    );
  }
}

class FullPageEditorScreen extends StatefulWidget {
  const FullPageEditorScreen(this.note);
  final Note note;

  @override
  _FullPageEditorScreenState createState() => _FullPageEditorScreenState();
}

class _FullPageEditorScreenState extends State<FullPageEditorScreen> {
  ZefyrController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _editing = false;
  StreamSubscription<NotusChange> _sub;

  @override
  void initState() {
    super.initState();
    _controller = ZefyrController(
        NotusDocument.fromDelta(Delta.fromJson(json.decode(widget.note.text))));
    _sub = _controller.document.changes.listen((NotusChange change) {
      print('${change.source}: ${change.change}');
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ZefyrThemeData theme = ZefyrThemeData(
      cursorColor: Colors.blue,
      toolbarTheme: ZefyrToolbarTheme.fallback(context).copyWith(
        /// The background color of toolbar.
        color: Colors.grey.shade200,

        /// Color of buttons in toggled state.
        toggleColor: Colors.grey.shade400,

        /// Color of button icons.
        iconColor: Colors.grey.shade800,

        /// Color of button icons in disabled state.
        disabledIconColor: Colors.grey.shade500,
      ),
    );

    final List<Widget> done = _editing
        ? <Widget>[
            FlatButton(
              onPressed: _stopEditing,
              child: const Text('Preview'),
            ),
          ]
        : <Widget>[
            FlatButton(
              onPressed: _startEditing,
              child: const Text('Edit'),
            ),
          ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.grey.shade200,
        brightness: Brightness.light,
        title: ZefyrLogo(),
        actions: done,
      ),
      body: ZefyrScaffold(
        child: ZefyrTheme(
          data: theme,
          child: ZefyrEditor(
            controller: _controller,
            focusNode: _focusNode,
            mode: _editing ? ZefyrMode.edit : ZefyrMode.select,
          ),
          // implements image
          // buildImage(context, 'asset://assets/breeze.jpg'),
        ),
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _editing = true;
    });
  }

  void _stopEditing() {
    setState(() {
      _editing = false;
    });
  }
}

/// Custom image delegate used by this example to load image from application
/// assets.
class CustomImageDelegate implements ZefyrImageDelegate<ImageSource> {
  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;

  @override
  Future<String> pickImage(ImageSource source) async {
    final File file = await ImagePicker.pickImage(source: source);
    if (file == null) {
      return null;
    }
    return file.uri.toString();
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    // We use custom "asset" scheme to distinguish asset images from other files.
    if (key.startsWith('asset://')) {
      final AssetImage asset = AssetImage(key.replaceFirst('asset://', ''));
      return Image(image: asset);
    } else {
      // Otherwise assume this is a file stored locally on user's device.
      final File file = File.fromUri(Uri.parse(key));
      final FileImage image = FileImage(file);
      return Image(image: image);
    }
  }
}
