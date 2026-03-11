import 'package:file_manager_ui/models/Storage/index.dart';
import 'package:file_manager_ui/pages/Settings/LanguagePage/index.dart';
import 'package:file_manager_ui/pages/Settings/ThemeColorPage/index.dart';
import 'package:file_manager_ui/services/Storage/index.dart';
import 'package:file_manager_ui/utils/formatBytes.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _storageService = StorageService();

  Storage storage = Storage(
    name: "Storage",
    totalSpace: 0,
    usedSpace: 0,
    mountPoint: "/",
  );
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
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
                      _buildSwitchTile(
                        Icons.dark_mode_outlined,
                        'Dark mode',
                        false,
                      ),
                      _buildNavigationTile(
                        context,
                        Icons.palette_outlined,
                        'Theme color',
                        destination: ThemeColorPage(),
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // 设置组：Preferences
                    _buildSectionHeader('PREFERENCES'),
                    _buildGroupCard([
                      _buildSwitchTile(
                        Icons.notifications_none_outlined,
                        'Notifications',
                        true,
                      ),
                      _buildSwitchTile(
                        Icons.cloud_upload_outlined,
                        'Auto backup',
                        true,
                        subtitle: 'Automatically backup to cloud',
                      ),
                      _buildNavigationTile(
                        context,
                        Icons.language_outlined,
                        'Language',
                        trailingText: 'English (US)',
                        destination: LanguagePage(),
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // 设置组：Other
                    _buildSectionHeader('OTHER'),
                    _buildGroupCard([
                      _buildNavigationTile(
                        context,
                        Icons.security_outlined,
                        'Privacy & security',
                      ),
                      _buildNavigationTile(
                        context,
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

  @override
  void initState() {
    super.initState();
    loadStorage();
  }

  Future<void> loadStorage() async {
    final result = await _storageService.getStorage();
    if (result != null) {
      setState(() {
        storage = result;
      });
    }
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
            child: const Text(
              'JD',
              style: TextStyle(
                color: Color.fromARGB(255, 101, 85, 143),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'John Doe',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'john.doe@example.com',
                style: TextStyle(color: Color.fromARGB(255, 233, 221, 255)),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 101, 85, 143),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Premium',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 存储卡片组件
  Widget _buildStorageCard() {
    final usedSpace = formatBytes(storage.usedSpace);
    final totalSpace = formatBytes(storage.totalSpace);
    
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
              Row(
                children: [
                  const Icon(
                    Icons.donut_large,
                    color: Color.fromARGB(255, 101, 85, 143),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    storage.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                "$usedSpace / $totalSpace",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 28.4 / 128,
              minHeight: 10,
              backgroundColor: Color.fromARGB(
                255,
                101,
                85,
                143,
              ).withOpacity(0.1),
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
        style: const TextStyle(
          color: Color.fromARGB(255, 101, 85, 143),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
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
  Widget _buildSwitchTile(
    IconData icon,
    String title,
    bool value, {
    String? subtitle,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: Colors.black87),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: (v) {},
                activeColor: const Color.fromARGB(255, 101, 85, 143),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 带箭头的导航列表项
  Widget _buildNavigationTile(
    BuildContext context,
    IconData icon,
    String title, {
    String? trailingText,
    Widget? destination,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (destination != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: Colors.black87),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    if (trailingText != null)
                      Text(
                        trailingText,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
