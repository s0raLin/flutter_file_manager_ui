import 'dart:convert';
import 'dart:io';

import 'package:file_manager_ui/models/BlockDevice/index.dart';

class BlockDeviceService {
  final List<BlockDevice> blockDevices = [];

  Future<List<BlockDevice>> getBlockDevices() async {
    final result = await Process.run("lsblk", [
      "-b",
      "-J",
      "-o",
      "NAME,TYPE,SIZE",
    ]);
    final json = jsonDecode(result.stdout);

    final List<BlockDevice> blockDevices = (json['blockdevices'] as List)
        .map((e) => BlockDevice.fromJson(e))
        .where((e) => !e.name.contains("zram")) // 过滤掉 zram swap 设备
        .toList();

    return blockDevices;
  }
}
