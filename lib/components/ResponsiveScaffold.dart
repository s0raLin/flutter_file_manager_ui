
import 'package:file_manager_ui/contants/mainNavItems.dart';
import 'package:file_manager_ui/widgets/BarTile/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



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
                Sidebar(navigationShell: navigationShell),
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
