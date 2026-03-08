// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

// 自定义 StatefulNavigationShell 类似于 go_router 的实现
class StatefulNavigationShell extends StatefulWidget {
  final int currentIndex;
  final List<Widget> branches;
  final ValueChanged<int> onBranchChanged;

  const StatefulNavigationShell({
    super.key,
    required this.currentIndex,
    required this.branches,
    required this.onBranchChanged,
  });

  @override
  State<StatefulNavigationShell> createState() =>
      _StatefulNavigationShellState();
}

class _StatefulNavigationShellState extends State<StatefulNavigationShell> {
  @override
  Widget build(BuildContext context) {
    return widget.branches[widget.currentIndex];
  }

  void goBranch(int index, {bool initialLocation = false}) {
    widget.onBranchChanged(index);
  }
}

// 导航项数据模型，包含 active（填充）和 normal（线性）两个版本的图标
class NavItem {
  final String label;
  final IconData activeIcon;
  final IconData normalIcon;
  final String route;

  const NavItem({
    required this.label,
    required this.activeIcon,
    required this.normalIcon,
    required this.route,
  });
}

// 定义导航项列表，包含 active（填充）和 normal（线性）两个版本的图标
const List<NavItem> navItems = [
  NavItem(
    label: 'Home',
    activeIcon: Icons.home,
    normalIcon: Icons.home_outlined,
    route: '/home',
  ),
  NavItem(
    label: 'Browse',
    activeIcon: Icons.folder,
    normalIcon: Icons.folder_outlined,
    route: '/browse',
  ),
  NavItem(
    label: 'Starred',
    activeIcon: Icons.star,
    normalIcon: Icons.star_border,
    route: '/starred',
  ),
  NavItem(
    label: 'Settings',
    activeIcon: Icons.settings,
    normalIcon: Icons.settings_outlined,
    route: '/settings',
  ),
];

class BarTile extends StatelessWidget {
  const BarTile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: const ResponsiveFileDashboard(),
    );
  }
}

class ResponsiveFileDashboard extends StatefulWidget {
  const ResponsiveFileDashboard({super.key});

  @override
  State<ResponsiveFileDashboard> createState() =>
      _ResponsiveFileDashboardState();
}

class _ResponsiveFileDashboardState extends State<ResponsiveFileDashboard> {
  int _selectedIndex = 0;

  // 模拟页面切换
  final List<Widget> _pages = [
    const Center(child: Text('Home Page')),
    const Center(child: Text('Browse Page')),
    const Center(child: Text('Starred Page')),
    const Center(child: Text('Settings Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 如果宽度大于 600，显示侧边栏布局
          if (constraints.maxWidth > 600) {
            return Row(
              children: [
                _buildSidebar(),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: _pages[_selectedIndex > 3 ? 0 : _selectedIndex],
                ),
              ],
            );
          } else {
            // 如果宽度小，显示普通页面内容
            return _pages[_selectedIndex > 3 ? 0 : _selectedIndex];
          }
        },
      ),
      // 仅在宽度较小时显示底部导航栏
      bottomNavigationBar: MediaQuery.of(context).size.width <= 600
          ? NavigationBar(
              selectedIndex: _selectedIndex > 3 ? 0 : _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() => _selectedIndex = index);
              },
              destinations: navItems
                  .map(
                    (item) => NavigationDestination(
                      icon: Icon(item.normalIcon),
                      selectedIcon: Icon(item.activeIcon),
                      label: item.label,
                    ),
                  )
                  .toList(),
            )
          : null,
    );
  }

  // 构建侧边栏
  Widget _buildSidebar() {
    final theme = Theme.of(context);
    return Container(
      width: 280,
      color: theme.colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            "Files",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          Text("Material You File Manager", style: theme.textTheme.bodySmall),
          const SizedBox(height: 24),

          // 存储状态卡片
          _buildStorageCard(),

          const SizedBox(height: 16),

          // 导航列表 - 使用动态图标切换
          Expanded(
            child: ListView(
              children: [
                _navItem(navItems[0], 0),
                _navItem(navItems[1], 1),
                _navItem(navItems[2], 2),
                const Divider(height: 32),
                _navItem(
                  const NavItem(
                    label: 'Recent',
                    activeIcon: Icons.access_time,
                    normalIcon: Icons.access_time,
                    route: '/recent',
                  ),
                  4,
                ),
                _navItem(
                  const NavItem(
                    label: 'Cloud',
                    activeIcon: Icons.cloud,
                    normalIcon: Icons.cloud_outlined,
                    route: '/cloud',
                  ),
                  5,
                ),
                _navItem(
                  const NavItem(
                    label: 'Trash',
                    activeIcon: Icons.delete,
                    normalIcon: Icons.delete_outline,
                    route: '/trash',
                  ),
                  6,
                ),
              ],
            ),
          ),

          // 底部设置按钮
          _navItem(navItems[3], 3),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // 存储信息卡片组件
  Widget _buildStorageCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Storage", style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          const Text("28.4 GB of 128 GB", style: TextStyle(fontSize: 12)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 28.4 / 128,
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  // 侧边栏单个选项组件 - 使用动态图标切换
  Widget _navItem(NavItem item, int index) {
    bool isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.deepPurple.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              // 动态图标切换：选中时显示 active（填充），未选中时显示 normal（线性）
              Icon(
                isSelected ? item.activeIcon : item.normalIcon,
                color: isSelected ? Colors.deepPurple : Colors.black54,
              ),
              const SizedBox(width: 16),
              Text(
                item.label,
                style: TextStyle(
                  color: isSelected ? Colors.deepPurple : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 使用 StatefulShellRoute 概念的响应式 Shell
// 类似于 go_router 的 StatefulShellRoute 实现
class ResponsiveShell extends StatefulWidget {
  final List<Widget> branches;

  const ResponsiveShell({super.key, required this.branches});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 使用自定义的 StatefulNavigationShell
    final navigationShell = _CustomNavigationShell(
      currentIndex: _currentIndex,
      branches: widget.branches,
      onBranchChanged: (index) {
        setState(() => _currentIndex = index);
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // 大屏幕（>600px）：使用 Row 侧边栏布局
        if (constraints.maxWidth > 600) {
          return Row(
            children: [
              _buildSidebar(context, navigationShell),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: navigationShell),
            ],
          );
        }
        // 小屏幕：使用 Scaffold 底部导航
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
            },
            destinations: navItems
                .map(
                  (item) => NavigationDestination(
                    icon: Icon(item.normalIcon),
                    selectedIcon: Icon(item.activeIcon),
                    label: item.label,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildSidebar(
    BuildContext context,
    _CustomNavigationShell navigationShell,
  ) {
    final theme = Theme.of(context);
    return Container(
      width: 280,
      color: theme.colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            "Files",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          Text("Material You File Manager", style: theme.textTheme.bodySmall),
          const SizedBox(height: 24),
          _buildStorageCard(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                for (int i = 0; i < navItems.length; i++)
                  _sidebarNavItem(context, navItems[i], i, navigationShell),
                const Divider(height: 32),
                _sidebarNavItem(
                  context,
                  const NavItem(
                    label: 'Recent',
                    activeIcon: Icons.access_time,
                    normalIcon: Icons.access_time,
                    route: '/recent',
                  ),
                  4,
                  navigationShell,
                ),
                _sidebarNavItem(
                  context,
                  const NavItem(
                    label: 'Cloud',
                    activeIcon: Icons.cloud,
                    normalIcon: Icons.cloud_outlined,
                    route: '/cloud',
                  ),
                  5,
                  navigationShell,
                ),
                _sidebarNavItem(
                  context,
                  const NavItem(
                    label: 'Trash',
                    activeIcon: Icons.delete,
                    normalIcon: Icons.delete_outline,
                    route: '/trash',
                  ),
                  6,
                  navigationShell,
                ),
              ],
            ),
          ),
          _sidebarNavItem(context, navItems[3], 3, navigationShell),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStorageCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Storage", style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          const Text("28.4 GB of 128 GB", style: TextStyle(fontSize: 12)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 28.4 / 128,
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _sidebarNavItem(
    BuildContext context,
    NavItem item,
    int index,
    _CustomNavigationShell navigationShell,
  ) {
    final isSelected = _currentIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          setState(() => _currentIndex = index);
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.deepPurple.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              // 动态图标切换：选中时显示 active（填充），未选中时显示 normal（线性）
              Icon(
                isSelected ? item.activeIcon : item.normalIcon,
                color: isSelected ? Colors.deepPurple : Colors.black54,
              ),
              const SizedBox(width: 16),
              Text(
                item.label,
                style: TextStyle(
                  color: isSelected ? Colors.deepPurple : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 自定义导航 Shell 类似于 go_router 的 StatefulNavigationShell
class _CustomNavigationShell extends StatelessWidget {
  final int currentIndex;
  final List<Widget> branches;
  final ValueChanged<int> onBranchChanged;

  const _CustomNavigationShell({
    required this.currentIndex,
    required this.branches,
    required this.onBranchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return branches[currentIndex];
  }

  void goBranch(int index, {bool initialLocation = false}) {
    onBranchChanged(index);
  }
}
