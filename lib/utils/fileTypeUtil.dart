import 'dart:io';

import 'package:file_manager_ui/models/FileItem/index.dart';
import 'package:flutter/material.dart';

class FileTypeUtil {
  static bool isImage(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith(".png") ||
        ext.endsWith(".jpg") ||
        ext.endsWith(".jpeg") ||
        ext.endsWith(".gif") ||
        ext.endsWith(".webp");
  }

  static bool isVideo(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith(".mp4") ||
        ext.endsWith(".mkv") ||
        ext.endsWith(".avi") ||
        ext.endsWith(".mov") ||
        ext.endsWith(".webm");
  }

  static bool isPdf(String path) {
    return path.toLowerCase().endsWith(".pdf");
  }

  static bool isAudio(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith(".mp3") ||
        ext.endsWith(".wav") ||
        ext.endsWith(".flac");
  }

  static bool isTextFile(String path) {
    final ext = path.toLowerCase();

    const textExtensions = [
      ".txt",
      ".md",
      ".json",
      ".xml",
      ".html",
      ".css",
      ".js",
      ".java",
      ".c",
      ".cpp",
      ".py",
      ".dart",
      ".yaml",
      ".yml",
      ".log",
    ];

    return textExtensions.any((e) => ext.endsWith(e));
  }
}

Widget buildFileThumbnail(FileItem file) {
  if (file.isDirectory) {
    return Icon(
      Icons.folder,
      size: 40,
      color: Color.fromARGB(255, 101, 85, 143),
    );
  }

  final path = file.path;

  if (FileTypeUtil.isTextFile(path)) {
    return Icon(Icons.text_snippet, size: 40, color: Colors.grey);
  }

  if (FileTypeUtil.isImage(path)) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(
        File(path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 40, color: Colors.grey);
        },
      ),
    );
  }

  if (FileTypeUtil.isVideo(path)) {
    return const Icon(Icons.video_file, size: 40, color: Colors.blue);
  }

  if (FileTypeUtil.isPdf(path)) {
    return const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red);
  }

  if (FileTypeUtil.isAudio(path)) {
    return const Icon(Icons.music_note, size: 40, color: Colors.green);
  }

  return const Icon(Icons.insert_drive_file, size: 40, color: Colors.grey);
}
