import 'package:file_manager_ui/pages/Browse/index.dart';
import 'package:file_manager_ui/pages/Home/index.dart';
import 'package:file_manager_ui/widgets/bar_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



final routes = <String, Widget>{
  "/home": const HomePage(),
  "/browse": const BrowsePage(),
  "/starred": const Center(child: Text('Starred Page')),
  "/settings": const Center(child: Text('Settings Page')),
};

// 使用全局 Key 可以在不依赖 Context 的情况下进行跳转（可选）
final rootNavigatorKey = GlobalKey<NavigatorState>();

final AppRouter = GoRouter(
  initialLocation: '/home',
  navigatorKey: rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ResponsiveScaffold(navigationShell: navigationShell);
      },
      branches: mainNavItems.map((item) {
        return StatefulShellBranch(
          routes: [
            GoRoute(
              path: item.path,
              // builder: (context, state) => Center(
              //   child: Text(
              //     '${item.label} Content',
              //     style: const TextStyle(fontSize: 24),
              //   ),
              // ),
              builder: (context, state) =>
                  routes[item.path] ?? const SizedBox(),
              // 如果某个页面有子路由，可以在此添加
              // routes: [ ... ]
            ),
          ],
        );
      }).toList(),
    ),
  ],
);
