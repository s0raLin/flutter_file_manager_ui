class Storage {
  final String name;
  final double totalSpace;
  final double usedSpace;
  final String mountPoint;

  Storage({
    required this.name,
    required this.totalSpace,
    required this.usedSpace,
    required this.mountPoint,
  });
}
