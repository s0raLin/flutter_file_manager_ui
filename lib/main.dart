import 'package:file_manager_ui/pages/file_manager_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "File Manager",
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: FileManagerPage(),
  ));
}
