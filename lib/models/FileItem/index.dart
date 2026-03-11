class FileItem {
  final String name;
  final String path;
  final String date;
  final bool isDirectory;
  final String type;

  FileItem({
    required this.name,
    required this.path,
    required this.isDirectory,
    required this.date, 
    required this.type,
  });
}
