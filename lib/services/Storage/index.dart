import 'dart:io';

import 'package:disk_space_plus/disk_space_plus.dart';
import 'package:file_manager_ui/models/Storage/index.dart';

class StorageService {
  final _diskSpacePlus = DiskSpacePlus();
  Future<Storage> getDiskInfo() async {
    final name = "Storage";
    final total = await _diskSpacePlus.getTotalDiskSpace ?? 0;
    final free = await _diskSpacePlus.getFreeDiskSpace ?? 0;
    final used = total - free;
    return Storage(
      name: name,
      totalSpace: total,
      usedSpace: used,
      mountPoint: "/",
    );
  }

  Future<Storage?> getStorage() async {
    final result = await Process.run("df", ['-B1', '--output=size,avail', "/"]);
    var lines = result.stdout.toString().split("\n");

    if (lines.length >= 2) {
      final line = lines[1];
      var parts = line.split(RegExp(r'\s+'));

      if (parts.length >= 2) {
        final total = double.parse(parts[0]);
        final free = double.parse(parts[1]);
        final used = total - free;

        return Storage(
          name: "Storage",
          usedSpace: used,
          totalSpace: total,
          mountPoint: "/",
        );
      }
    }
    return null;
  }
}