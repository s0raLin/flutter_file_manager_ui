import 'dart:io';

import 'package:file_manager_ui/models/FileItem/index.dart';
import 'package:file_manager_ui/services/File/index.dart';
import 'package:file_manager_ui/widgets/FileTile/index.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FileService fileService = FileService();

  String currentPath = "/";
  List<FileItem> files = [];
  Set<String> selectedFiles = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadFiles();
    });
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

  void toggleSelection(String path) {
    setState(() {
      if (selectedFiles.contains(path)) {
        selectedFiles.remove(path);
      } else {
        selectedFiles.add(path);
      }
    });
  }

  void clearSelection() {
    setState(() {
      selectedFiles.clear();
    });
  }

  // 更多选项操作
  void onShare(FileItem file) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('分享: ${file.name}')));
  }

  void onCopy(FileItem file) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('复制: ${file.name}')));
  }

  void onMove(FileItem file) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('移动: ${file.name}')));
  }

  void onDetails(FileItem file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('文件详情'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('名称: ${file.name}'),
            Text('路径: ${file.path}'),
            Text('类型: ${file.isDirectory ? "文件夹" : "文件"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭'),
          ),
        ],
      ),
    );
  }

  void onDelete(FileItem file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认删除'),
        content: Text('确定要删除 "${file.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              try {
                fileService.deleteFile(file);
                loadFiles();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('已删除: ${file.name}')));
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('删除失败: $e')));
              }
            },
            child: Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentPath),
        leading: IconButton(onPressed: goBack, icon: Icon(Icons.arrow_back)),
        actions: [
          if (selectedFiles.isNotEmpty)
            IconButton(
              onPressed: clearSelection,
              icon: Icon(Icons.close),
              tooltip: '取消选择',
            ),
          if (selectedFiles.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  '${selectedFiles.length} 项已选择',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
        ],
      ),

      body: GridView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          final isSelected = selectedFiles.contains(file.path);

          return FileTile(
            file: file,
            onTap: () => open(file),
            isSelected: isSelected,
            onSelectedChanged: (selected) => toggleSelection(file.path),
            onShare: () => onShare(file),
            onCopy: () => onCopy(file),
            onMove: () => onMove(file),
            onDetails: () => onDetails(file),
            onDelete: () => onDelete(file),
          );
        },
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: 230,
        ),
      ),
    );
  }
}
