import 'dart:io';

import 'package:file_manager_ui/models/file_item.dart';
import 'package:file_manager_ui/services/file_service.dart';
import 'package:file_manager_ui/widgets/bar_tile.dart';
import 'package:file_manager_ui/widgets/file_tile.dart';
import 'package:flutter/material.dart';

class FileManagerPage extends StatefulWidget {
  const FileManagerPage({super.key});

  @override
  State<FileManagerPage> createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
  final FileService fileService = FileService();

  String currentPath = "/home/cangli";
  List<FileItem> files = [];

  void initState() {
    super.initState();
    loadFiles();
  }
  /*@override
 

  Future<void> init() async {
    await requestPermission();

    loadFiles();
  }

  // 安卓获取应用权限
  Future<void> requestPermission() async {} */

  void loadFiles() {
    final list = fileService.listFiles(currentPath);

    setState(() {
      files = list;
    });
  }

  void open(FileItem file) {
    if (file.isDirectory) {
      setState(() {
        currentPath = file.path;
      });

      loadFiles();
    }
  }

  void goBack() {
    final dir = Directory(currentPath);

    setState(() {
      currentPath = dir.parent.path;
    });

    loadFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentPath),
        leading: IconButton(onPressed: goBack, icon: Icon(Icons.arrow_back)),
      ),

      body: GridView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];

          return FileTile(file: file, onTap: () => open(file));
        },
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: 230,
        ),
      ),
      bottomNavigationBar: BarTile(),
    );
  }
}


