import 'package:file_manager_ui/contants/mainNavItems.dart';
import 'package:file_manager_ui/models/Storage/index.dart';
import 'package:file_manager_ui/services/Storage/index.dart';
import 'package:file_manager_ui/utils/formatBytes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 4. 抽取侧边栏组件，完美还原图1
class Sidebar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const Sidebar({super.key, required this.navigationShell});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final StorageService storageService = StorageService();

  List<Storage> storages = [];

  Storage storage = Storage(
    name: "name",
    totalSpace: 0,
    usedSpace: 0,
    mountPoint: "mountPoint",
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadStorage();
    });
  }

  Future<void> loadStorage() async {
    // storages = await storageService.getStorageDevices();
    final result = await storageService.getStorage();
    if (result != null) {
      storage = result;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 280,
      color: theme.colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "Files",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "Material You File Manager",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
          _buildStorageCard(theme),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                ...mainNavItems
                    .getRange(0, 3)
                    .map((item) => _buildSidebarTile(context, item)),
                const Divider(height: 32),
                _buildSidebarTile(
                  context,
                  const NavItem(
                    label: 'Recent',
                    activeIcon: Icons.access_time_filled,
                    normalIcon: Icons.access_time,
                    path: '/recent',
                  ),
                ),
                _buildSidebarTile(
                  context,
                  const NavItem(
                    label: 'Cloud',
                    activeIcon: Icons.cloud,
                    normalIcon: Icons.cloud_outlined,
                    path: '/cloud',
                  ),
                ),
                _buildSidebarTile(
                  context,
                  const NavItem(
                    label: 'Trash',
                    activeIcon: Icons.delete,
                    normalIcon: Icons.delete_outline,
                    path: '/trash',
                  ),
                ),
              ],
            ),
          ),
          _buildSidebarTile(context, mainNavItems[3]), // Settings
          const SizedBox(height: 16), // 返回你定义的响应式外壳
        ],
      ),
    );
  }

  Widget _buildSidebarTile(BuildContext context, NavItem item) {
    // 通过路径匹配判断是否选中
    final bool isSelected =
        mainNavItems.indexOf(item) == widget.navigationShell.currentIndex;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: () {
          int index = mainNavItems.indexOf(item);
          if (index != -1) widget.navigationShell.goBranch(index);
        },
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? item.activeIcon : item.normalIcon, // 图标切换逻辑
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Text(
                item.label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStorageCard(ThemeData theme) {

    final name = storage.name;
    final usedSpace = formatBytes(storage.usedSpace);
    final totalSpace = formatBytes(storage.totalSpace);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("$usedSpace of $totalSpace", style: TextStyle(fontSize: 12)),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: storage.totalSpace > 0
                ? storage.usedSpace / storage.totalSpace
                : 0.0,
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}

// class Sidebar extends StatelessWidget {
//   final StatefulNavigationShell navigationShell;
//   const Sidebar({required this.navigationShell});

// }
