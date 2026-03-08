import 'dart:io';

import 'package:file_manager_ui/models/storage.dart';

class StorageService {
  
  static Future<List<Storage>> getStorageDevices() async {
    final result = await Process.run('df', ['-B1']);

    List<Storage> devices = [];

    List<String> lines = result.stdout.toString().split('\n');

    for (var line in lines.skip(1)) {
      if (line.trim().isEmpty) continue;

      var parts = line.split(RegExp(r'\s+'));

      if (parts.length >= 6) {
        devices.add(
          Storage(
            name: parts[0], // 设备名
            totalSpace: double.parse(parts[1]), // 总空间
            usedSpace: double.parse(parts[2]), // 已用空间
            mountPoint: parts[5], // 挂载点
          ),
        );
      }
    }

    return devices;
  }
}
