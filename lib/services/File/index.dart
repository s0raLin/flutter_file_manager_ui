import 'dart:io';

import 'package:file_manager_ui/models/FileItem/index.dart';

class FileService {
  List<FileItem> listFiles(String path) {
    final directory = Directory(path);
    final entities = directory.listSync();

    return entities.map((e) {
      final name = e.path.split('/').last;

      return FileItem(name: name, path: e.path, isDirectory: e is Directory);
    }).toList();
  }

  void deleteFile(FileItem file) {
    if (file.isDirectory) {
      Directory(file.path).deleteSync(recursive: true);
    } else {
      File(file.path).deleteSync();
    }
  }
}
