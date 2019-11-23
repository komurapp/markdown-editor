import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart'; //log
import 'package:simple_permissions/simple_permissions.dart';

import '../model/note.dart';

class FileManager {
  factory FileManager() {
    return _singleton;
  }

  FileManager._internal();

  static final FileManager _singleton = FileManager._internal();

  Future<String> get _localPath async {
    final String directory = (await getApplicationDocumentsDirectory()).path;
    final String finalPath =
        p.join(directory, 'notes'); //path takes strings and not Path objects
    Directory(finalPath)
        .createSync(recursive: true); //create directory if non existant

    return finalPath;
  }

  Future<File> writeNote(Note note) async {
    String file = await _localPath;
    print('lala');

    file = p.join(
      file,
      note.title == ''
          ? DateFormat('kk:mm:ssyMMdd').format(DateTime.now())
          : note.title,
    );

    return await SimplePermissions.requestPermission(Permission.WriteExternalStorage)
        .then((PermissionStatus value) {
      if (value == PermissionStatus.authorized) {
        print('authorized WRITE');
        final String noteJson = note.toJson();
        return File(file).writeAsString('$noteJson');
      } else {
        print('unauthorized');
        SimplePermissions.openSettings();
        return null;
      }
    });
  }

  Future<List<Note>> getNotes() async {
    final String file = await _localPath;

    return SimplePermissions.requestPermission(Permission.ReadExternalStorage)
        .then((PermissionStatus value) {
      if (value == PermissionStatus.authorized) {
        print('authorized READ');
        try {
          final Future<List<Note>> result = Directory(file)
              .list(recursive: false, followLinks: false)
              .asyncMap((FileSystemEntity fse) {
                if (fse is File) {
                  return fse.readAsString();
                }
              })
              .asyncMap((String s) => Note.fromJsonResponse(s))
              .toList();
          return result;
        } catch (e) {
          debugPrint('getNoteError: $e');
          return null;
        }
      } else {
        print('lala');
        SimplePermissions.openSettings();
        return null;
      }
    });
  }
}
