import 'package:file_manager_ui/models/Storage/index.dart';
import 'package:file_manager_ui/services/Storage/index.dart';
import 'package:file_manager_ui/utils/formatBytes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 1. 导航项模型：清晰定义图标切换逻辑
class NavItem {
  final String label;
  final IconData activeIcon; // 选中时的填充图标
  final IconData normalIcon; // 未选中的线性图标
  final String path;

  const NavItem({
    required this.label,
    required this.activeIcon,
    required this.normalIcon,
    required this.path,
  });
}

// 统一管理导航配置
const List<NavItem> mainNavItems = [
  NavItem(
    label: 'Home',
    activeIcon: Icons.home,
    normalIcon: Icons.home_outlined,
    path: '/home',
  ),
  NavItem(
    label: 'Browse',
    activeIcon: Icons.folder,
    normalIcon: Icons.folder_outlined,
    path: '/browse',
  ),
  NavItem(
    label: 'Starred',
    activeIcon: Icons.star,
    normalIcon: Icons.star_border,
    path: '/starred',
  ),
  NavItem(
    label: 'Settings',
    activeIcon: Icons.settings,
    normalIcon: Icons.settings_outlined,
    path: '/settings',
  ),
];

// 3. 响应式外壳：根据宽度决定 UI 结构
class ResponsiveScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ResponsiveScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 宽度 > 600 使用侧边栏
        if (constraints.maxWidth > 600) {
          return Scaffold(
            body: Row(
              children: [
                _Sidebar(navigationShell: navigationShell),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: navigationShell),
              ],
            ),
          );
        }
        // 宽度 <= 600 使用底部导航
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) => navigationShell.goBranch(index),
            destinations: mainNavItems.map((item) {
              final isSelected =
                  navigationShell.currentIndex == mainNavItems.indexOf(item);
              return NavigationDestination(
                icon: Icon(item.normalIcon),
                selectedIcon: Icon(item.activeIcon), // 自动处理填充图标切换
                label: item.label,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

// 4. 抽取侧边栏组件，完美还原图1
class _Sidebar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const _Sidebar({required this.navigationShell});

  @override
  State<_Sidebar> createState() => __SidebarState();
}

class __SidebarState extends State<_Sidebar> {
  final StorageService storageService = StorageService();
  List<Storage> storages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadStorage();
    });
  }

  Future<void> loadStorage() async {
    storages = await storageService.getStorageDevices();

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
    if (storages.isEmpty) {
      return const SizedBox.shrink();
    }

    final storage = storages.first;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            storage.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "${formatBytes(storage.usedSpace)} of ${formatBytes(storage.totalSpace)}",
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.22,
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}

// class _Sidebar extends StatelessWidget {
//   final StatefulNavigationShell navigationShell;
//   const _Sidebar({required this.navigationShell});

// }
