
import 'package:flutter/material.dart';

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