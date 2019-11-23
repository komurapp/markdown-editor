import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

class Note {
  Note({
    @required this.id,
    @required this.title,
    @required this.text,
    @required this.date,
  });

  final int id;
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
    return Note(
      id: map['id'],
      title: map['title'],
      text: map['text'],
      date: DateTime.parse(map['date']),
    );
  }

  static const String emptyText = '[{"insert":"\\n"}]';

  String toJson() {
    return json.encode(<String, dynamic>{
      'id': id,
      'text': text,
      'title': title,
      'date': DateFormat('kk:mm:ssyMMdd').format(date)
    });
  }

  static Note fromJsonResponse(String response) {
    final dynamic decodedJson = json.decode(response);
    final dynamic casted = decodedJson.cast<String, dynamic>();
    return fromMap(casted);
  }
}
