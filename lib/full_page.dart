import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zefyr/zefyr.dart';

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
  @override
  _FullPageEditorScreenState createState() => _FullPageEditorScreenState();
}

const String doc =
    r'[{"insert":"Zefyr"},{"insert":"\n","attributes":{"heading":1}},{"insert":"Soft and gentle rich text editing for Flutter applications.","attributes":{"i":true}},{"insert":"\n"},{"insert":"Photo by Hiroyuki Takeda.","attributes":{"i":true}},{"insert":"\nZefyr is currently in "},{"insert":"early preview","attributes":{"b":true}},{"insert":". If you have a feature request or found a bug, please file it at the "},{"insert":"issue tracker","attributes":{"a":"https://github.com/memspace/zefyr/issues"}},{"insert":'
    r'".\nDocumentation"},{"insert":"\n","attributes":{"heading":3}},{"insert":"Quick Start","attributes":{"a":"https://github.com/memspace/zefyr/blob/master/doc/quick_start.md"}},{"insert":"\n","attributes":{"block":"ul"}},{"insert":"Data Format and Document Model","attributes":{"a":"https://github.com/memspace/zefyr/blob/master/doc/data_and_document.md"}},{"insert":"\n","attributes":{"block":"ul"}},{"insert":"Style Attributes","attributes":{"a":"https://github.com/memspace/zefyr/blob/master/doc/attr'
    r'ibutes.md"}},{"insert":"\n","attributes":{"block":"ul"}},{"insert":"Heuristic Rules","attributes":{"a":"https://github.com/memspace/zefyr/blob/master/doc/heuristics.md"}},{"insert":"\n","attributes":{"block":"ul"}},{"insert":"FAQ","attributes":{"a":"https://github.com/memspace/zefyr/blob/master/doc/faq.md"}},{"insert":"\n","attributes":{"block":"ul"}},{"insert":"Clean and modern look"},{"insert":"\n","attributes":{"heading":2}},{"insert":"Zefyr’s rich text editor is built with simplicity and fle'
    r'xibility in mind. It provides clean interface for distraction-free editing. Think Medium.com-like experience.\nMarkdown inspired semantics"},{"insert":"\n","attributes":{"heading":2}},{"insert":"Ever needed to have a heading line inside of a quote block, like this:\nI’m a Markdown heading"},{"insert":"\n","attributes":{"block":"quote","heading":3}},{"insert":"And I’m a regular paragraph"},{"insert":"\n","attributes":{"block":"quote"}},{"insert":"Code blocks"},{"insert":"\n","attributes":{"headin'
    r'g":2}},{"insert":"Of course:\nimport ‘package:flutter/material.dart’;"},{"insert":"\n","attributes":{"block":"code"}},{"insert":"import ‘package:zefyr/zefyr.dart’;"},{"insert":"\n\n","attributes":{"block":"code"}},{"insert":"void main() {"},{"insert":"\n","attributes":{"block":"code"}},{"insert":" runApp(MyWAD());"},{"insert":"\n","attributes":{"block":"code"}},{"insert":"}"},{"insert":"\n","attributes":{"block":"code"}},{"insert":"\n\n\n"}]';

Delta getDelta() {
  return Delta.fromJson(json.decode(doc));
}

class _FullPageEditorScreenState extends State<FullPageEditorScreen> {
  final ZefyrController _controller =
      ZefyrController(NotusDocument.fromDelta(getDelta()));
  final FocusNode _focusNode = FocusNode();
  bool _editing = false;
  StreamSubscription<NotusChange> _sub;

  @override
  void initState() {
    super.initState();
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
