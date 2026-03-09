import 'package:file_manager_ui/models/Storage/index.dart';
import 'package:file_manager_ui/services/Storage/index.dart';
import 'package:file_manager_ui/utils/formatBytes.dart';
import 'package:flutter/material.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  final StorageService storageService = StorageService();
  List<Storage> devices = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadDevices();
    });
  }

  Future<void> loadDevices() async {
    final list = await storageService.getStorageDevices();
    setState(() {
      devices = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Browse')),
      body: ListView.separated(
        itemCount: devices.length,
        separatorBuilder: (context, index) => SizedBox(height: 20),
        itemBuilder: (context, index) {
          final d = devices[index];
          return Container(
            width: 250,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 233, 221, 255),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              title: Text(d.name),
              subtitle: Text(
                "挂载点:${d.mountPoint}\n已用: ${formatBytes(d.usedSpace)}/总容量: ${formatBytes(d.totalSpace)}",
              ),
            ),
          );
        },
      ),
    );
  }

  // String formatBytes(double bytes) {
  //   if (bytes < 1024) return "$bytes B";
  //   if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
  //   if (bytes < 1024 * 1024 * 1024) {
  //     return "${(bytes / 1024 / 1024).toStringAsFixed(1)} MB";
  //   }

  //   return "${(bytes / 1024 / 1024 / 1024).toStringAsFixed(2)} GB";
  // }
}
