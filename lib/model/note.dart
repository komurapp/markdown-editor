import 'dart:convert';

import 'package:meta/meta.dart';

class Note {
  Note({
    @required this.title,
    @required this.text,
    @required this.date,
  });

  final String title;
  String text;
  final DateTime date;

  /// Gets all the notes from the json
  static List<Note> allFromResponse(String response) {
    /// String -> Object
    final dynamic decodedJson = json.decode(response).cast<String, dynamic>();

    return decodedJson['results']
        .cast<Map<String, dynamic>>()
        .map((dynamic obj) => Note.fromMap(obj))
        .toList()
        .cast<Note>(); // cast the object into a `<Note>[]`
  }

  static Note fromMap(Map<String, dynamic> map) {
    /// Object -> Json -> String
    final String textJson = json.encode(map['text']);
    return Note(
      title: map['title'],
      text: textJson,
      date: DateTime.parse(map['date']),
    );
  }

  static const String emptyText = '[{"insert":"\\n"}]';
}
