class BlockDevice {
  final String name; // "zram0"
  final double size; // 15881732096
  final String type; // "disk"
  final List<BlockDevice>? children; //

  BlockDevice({
    required this.name,
    required this.size,
    required this.type,
    // this.mountPoints,
    this.children,
  });

  factory BlockDevice.fromJson(Map<String, dynamic> json) {
    final sizeStr = json['size']?.toString() ?? '0';
    final size = double.tryParse(sizeStr) ?? 0;

    return BlockDevice(
      name: json['name']?.toString() ?? 'unknown',
      size: size,
      type: json['type']?.toString() ?? 'unknown',
      // mountPoints: (json['mountpoints'] as List)
      //     .where((e) => e != null)
      //     .map((e) => e.toString())
      //     .toList(),
      children: json['children'] != null
          ? (json['children'] as List)
                .where((e) => e != null)
                .map((e) => BlockDevice.fromJson(e))
                .toList()
          : null,
    );
  }
}
