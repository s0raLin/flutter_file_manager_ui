import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              // 关键点：限制最大宽度并居中
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Settings',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    // 用户信息卡片
                    _buildUserCard(),
                    const SizedBox(height: 16),

                    // 存储卡片
                    _buildStorageCard(),
                    const SizedBox(height: 24),

                    // 设置组：Appearance
                    _buildSectionHeader('APPEARANCE'),
                    _buildGroupCard([
                      _buildSwitchTile(Icons.dark_mode_outlined, 'Dark mode', false),
                      _buildNavigationTile(Icons.palette_outlined, 'Theme color'),
                    ]),
                    const SizedBox(height: 24),

                    // 设置组：Preferences
                    _buildSectionHeader('PREFERENCES'),
                    _buildGroupCard([
                      _buildSwitchTile(Icons.notifications_none_outlined, 'Notifications', true),
                      _buildSwitchTile(
                        Icons.cloud_upload_outlined,
                        'Auto backup',
                        true,
                        subtitle: 'Automatically backup to cloud',
                      ),
                      _buildNavigationTile(
                        Icons.language_outlined,
                        'Language',
                        trailingText: 'English (US)',
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // 设置组：Other
                    _buildSectionHeader('OTHER'),
                    _buildGroupCard([
                      _buildNavigationTile(Icons.security_outlined, 'Privacy & security'),
                      _buildNavigationTile(
                        Icons.info_outline,
                        'About',
                        trailingText: 'Version 1.0.0',
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 用户卡片组件
  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Color.fromARGB(255, 101, 85, 143).withOpacity(0.1),
            child: const Text('JD', style: TextStyle(color: Color.fromARGB(255, 101, 85, 143), fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('John Doe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('john.doe@example.com', style: TextStyle(color: Color.fromARGB(255, 233, 221, 255))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 101, 85, 143),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Premium', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 存储卡片组件
  Widget _buildStorageCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.donut_large, color: Color.fromARGB(255, 101, 85, 143), size: 20),
                  SizedBox(width: 8),
                  Text('Storage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const Text('28.4 GB / 128 GB', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 28.4 / 128,
              minHeight: 10,
              backgroundColor: Color.fromARGB(255, 101, 85, 143).withOpacity(0.1),
              color: const Color.fromARGB(255, 101, 85, 143),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStorageDetail('Images', '12.3 GB'),
              _buildStorageDetail('Videos', '8.7 GB'),
              _buildStorageDetail('Documents', '4.2 GB'),
              _buildStorageDetail('Other', '3.2 GB'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStorageDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // 分组标题
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(color: Color.fromARGB(255, 101, 85, 143), fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  // 通用的组合卡片容器
  Widget _buildGroupCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }

  // 带开关的列表项
  Widget _buildSwitchTile(IconData icon, String title, bool value, {String? subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: Switch(
        value: value,
        onChanged: (v) {},
        activeColor: const Color.fromARGB(255, 101, 85, 143),
      ),
    );
  }

  // 带箭头的导航列表项
  Widget _buildNavigationTile(IconData icon, String title, {String? trailingText}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: trailingText != null ? Text(trailingText, style: const TextStyle(fontSize: 12)) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}