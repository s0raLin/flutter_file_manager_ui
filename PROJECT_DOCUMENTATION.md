# File Manager UI 项目文档

## 一、项目概述

本项目是一个基于 Flutter 的跨平台文件管理器应用，支持 Android、iOS、Linux、macOS 和 Web 平台。项目采用现代化的 Material Design 3 设计语言，提供响应式布局，能够在手机和平板电脑上良好运行。

### 1.1 主要功能

- 📁 **文件浏览**：浏览设备上的文件和文件夹
- 📂 **存储设备管理**：查看各存储设备的容量和使用情况
- ⭐ **收藏夹**：收藏常用文件和文件夹
- ⚙️ **设置**：应用配置
- 📊 **文件操作**：支持分享、复制、移动、查看详情、删除等操作

---

## 二、项目架构

### 2.1 目录结构

```
lib/
├── main.dart                    # 应用入口
├── routes/
│   └── index.dart               # 路由配置 (GoRouter)
├── models/                      # 数据模型层
│   ├── FileItem/
│   │   └── index.dart           # 文件/文件夹模型
│   └── Storage/
│       └── index.dart           # 存储设备模型
├── services/                    # 服务层 (业务逻辑)
│   ├── File/
│   │   └── index.dart           # 文件操作服务
│   └── Storage/
│       └── index.dart           # 存储设备信息服务
├── pages/                       # 页面层
│   ├── Home/
│   │   └── index.dart           # 主页面 (文件浏览)
│   └── Browse/
│       └── index.dart           # 浏览页面 (存储设备)
└── widgets/                     # 组件层
    ├── FileTile/
    │   └── index.dart           # 文件卡片组件
    └── BarTile/
        └── index.dart           # 侧边栏/导航组件
```

### 2.2 技术栈

| 技术 | 说明 |
|------|------|
| Flutter | UI 框架 |
| GoRouter | 路由管理 |
| Material Design 3 | UI 设计语言 |
| dart:io | 文件系统操作 |
| dart:process | 系统命令执行 |

---

## 三、数据流向图

### 3.1 整体数据流向

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                用户界面 (UI)                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │  HomePage    │  │  BrowsePage  │  │  FileTile    │  │  BarTile     │    │
│  │  (文件浏览)   │  │  (设备浏览)   │  │  (文件卡片)   │  │  (导航栏)     │    │
│  └──────┬───────┘  └──────┬───────┘  └──────────────┘  └──────────────┘    │
└─────────┼─────────────────┼────────────────────────────────────────────────┘
          │                 │
          ▼                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              页面层 (Pages)                                  │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                    HomePage / BrowsePage                           │    │
│  │   • 状态管理 (setState)                                              │    │
│  │   • 用户交互处理                                                      │    │
│  │   • 数据渲染                                                          │    │
│  └─────────────────────────────────┬───────────────────────────────────┘    │
└─────────────────────────────────────┼───────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              服务层 (Services)                                │
│  ┌──────────────────────┐          ┌──────────────────────────┐             │
│  │    FileService      │          │     StorageService      │             │
│  │  • listFiles()      │          │  • getStorageDevices()  │             │
│  │  • deleteFile()     │          │                         │             │
│  └──────────┬──────────┘          └───────────┬──────────────┘             │
└─────────────┼───────────────────────────────────┼────────────────────────────┘
              │                                   │
              ▼                                   ▼
┌─────────────────────────────┐    ┌─────────────────────────────────────────┐
│     dart:io (文件系统)       │    │        dart:io (系统命令: df)           │
│   • Directory.listSync()    │    │    • Process.run('df', ['-B1'])         │
│   • File.deleteSync()       │    │                                          │
│   • Directory.deleteSync()  │    │                                          │
└─────────────────────────────┘    └─────────────────────────────────────────┘
              │                                   │
              ▼                                   ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              模型层 (Models)                                 │
│  ┌──────────────────────┐          ┌──────────────────────────┐             │
│  │       FileItem       │          │         Storage          │             │
│  │  • name: String     │          │  • name: String          │             │
│  │  • path: String     │          │  • totalSpace: double    │             │
│  │  • isDirectory: bool│          │  • usedSpace: double     │             │
│  └──────────────────────┘          │  • mountPoint: String    │             │
│                                    └──────────────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 3.2 核心数据流详解

#### 3.2.1 文件列表数据流

```
[用户打开应用]
      │
      ▼
[HomePage.initState()]
      │
      ▼
[loadFiles()] ─────────────────────────────────────────┐
      │                                               │
      ▼                                               │
[FileService.listFiles(currentPath)]                   │
      │                                               │
      ▼                                               │
[Directory(path).listSync()] ──► [文件系统]            │
      │                                               │
      ▼                                               │
[entities.map() 转换为 FileItem 列表]                   │
      │                                               │
      ▼                                               │
[setState({ files: list })] ◄──────────────────────────┘
      │
      ▼
[GridView.builder] ──► [FileTile] ──► [渲染文件卡片]
```

#### 3.2.2 存储设备数据流

```
[用户切换到 Browse 页面]
      │
      ▼
[BrowsePage.initState()]
      │
      ▼
[loadDevices()]
      │
      ▼
[await StorageService.getStorageDevices()]
      │
      ▼
[Process.run('df', ['-B1'])] ──► [系统命令: df]
      │                              │
      ▼                              ▼
[解析命令输出]                   [返回设备信息]
      │                              │
      ▼                              ▼
[转换为 Storage 对象列表] ◄───────────────────────┘
      │
      ▼
[setState({ devices: list })]
      │
      ▼
[ListView.separated] ──► [渲染设备列表]
```

#### 3.2.3 文件操作数据流

```
[用户点击文件卡片]
      │
      ▼
[FileTile.onTap] ──► [HomePage.open(file)]
      │
      ├──────────────────┐
      │                  │
      ▼                  ▼
[如果是文件夹]      [如果是文件]
      │                  │
      ▼                  ▼
[更新 currentPath] [执行对应操作]
[loadFiles()]        │
                     ▼
              [onShare / onCopy / onMove / onDetails / onDelete]
                     │
                     ▼
              [Service 调用]
                     │
                     ├────────────┬────────────┐
                     ▼            ▼            ▼
               [分享提示]    [复制提示]    [删除操作]
                                               │
                                               ▼
                                    [FileService.deleteFile()]
                                               │
                                               ▼
                                    [File.deleteSync() 或
                                     Directory.deleteSync()]
                                               │
                                               ▼
                                    [loadFiles() 刷新列表]
```

---

## 四、核心代码模块

### 4.1 入口文件 ([`lib/main.dart`](lib/main.dart))

```dart
void main() {
  runApp(
    MaterialApp.router(
      routerConfig: AppRouter,  // 使用 GoRouter 配置
    )
  );
}
```

### 4.2 路由配置 ([`lib/routes/index.dart`](lib/routes/index.dart))

- 使用 `GoRouter` 进行路由管理
- 采用 `StatefulShellRoute.indexedStack` 实现底部导航
- 支持响应式布局：宽屏 > 600px 显示侧边栏，窄屏显示底部导航

**路由表：**

| 路径 | 页面 | 说明 |
|------|------|------|
| `/home` | HomePage | 文件浏览主页 |
| `/browse` | BrowsePage | 存储设备浏览 |
| `/starred` | StarredPage | 收藏夹 (预留) |
| `/settings` | SettingsPage | 设置页面 (预留) |

### 4.3 数据模型

#### FileItem ([`lib/models/FileItem/index.dart`](lib/models/FileItem/index.dart))

```dart
class FileItem {
  final String name;        // 文件/文件夹名称
  final String path;        // 完整路径
  final bool isDirectory;  // 是否为文件夹
}
```

#### Storage ([`lib/models/Storage/index.dart`](lib/models/Storage/index.dart))

```dart
class Storage {
  final String name;         // 设备名称 (如 /dev/sda1)
  final double totalSpace;  // 总空间 (字节)
  final double usedSpace;   // 已用空间 (字节)
  final String mountPoint;  // 挂载点 (如 /, /home)
}
```

### 4.4 服务层

#### FileService ([`lib/services/File/index.dart`](lib/services/File/index.dart))

| 方法 | 功能 |
|------|------|
| `listFiles(path)` | 列出指定路径下的所有文件和文件夹 |
| `deleteFile(file)` | 删除指定的文件或文件夹 |

#### StorageService ([`lib/services/Storage/index.dart`](lib/services/Storage/index.dart))

| 方法 | 功能 |
|------|------|
| `getStorageDevices()` | 获取所有存储设备信息 (通过 df 命令) |

### 4.5 页面层

#### HomePage ([`lib/pages/Home/index.dart`](lib/pages/Home/index.dart))

主要功能：
- 显示当前路径下的文件列表 (GridView)
- 文件/文件夹的点击进入
- 返回上级目录
- 多选文件操作
- 文件操作菜单 (分享、复制、移动、详情、删除)

#### BrowsePage ([`lib/pages/Browse/index.dart`](lib/pages/Browse/index.dart))

主要功能：
- 显示所有存储设备
- 显示设备容量使用情况
- 格式化字节数为可读格式

### 4.6 组件层

#### FileTile ([`lib/widgets/FileTile/index.dart`](lib/widgets/FileTile/index.dart))

- 文件卡片展示 (包含图标、名称、选择框)
- 更多操作菜单 (底部弹出)
- 点击和长按交互

#### BarTile ([`lib/widgets/BarTile/index.dart`](lib/widgets/BarTile/index.dart))

- 响应式导航组件
- 侧边栏模式 (宽屏)
- 底部导航栏模式 (窄屏)
- 导航项配置 (Home, Browse, Starred, Settings)

---

## 五、数据交互流程

### 5.1 State Management 流程

```
用户操作
    │
    ▼
Widget 调用 Page 方法
    │
    ▼
Page 调用 Service
    │
    ▼
Service 操作 dart:io / Process
    │
    ▼
返回数据给 Page
    │
    ▼
Page 调用 setState()
    │
    ▼
Flutter 重建 UI
    │
    ▼
显示更新后的界面
```

### 5.2 页面间数据传递

```
┌─────────────────────────────────────────────────────────────┐
│                      GoRouter 路由                          │
│                                                              │
│  /home ──────► HomePage                                     │
│     │              │                                        │
│     │              ▼                                        │
│     │         FileService.listFiles()                       │
│     │              │                                        │
│     │              ▼                                        │
│     │         List<FileItem> ──► GridView ──► FileTile     │
│     │                                                       │
│  /browse ───► BrowsePage                                    │
│     │              │                                        │
│     │              ▼                                        │
│     │         StorageService.getStorageDevices()           │
│     │              │                                        │
│     │              ▼                                        │
│     │         List<Storage> ──► ListView                    │
│     │                                                       │
└─────────────────────────────────────────────────────────────┘
```

---

## 六、关键技术点

### 6.1 响应式布局

使用 `LayoutBuilder` 和 `constraints.maxWidth` 判断屏幕宽度：
- **> 600px**: 显示侧边栏 + 内容区
- **≤ 600px**: 显示底部导航栏

### 6.2 系统命令调用

使用 `Process.run()` 执行系统命令获取存储设备信息：
```dart
final result = await Process.run('df', ['-B1']);
```

### 6.3 文件系统操作

使用 `dart:io` 包进行文件操作：
- `Directory.listSync()` - 列出目录内容
- `File.deleteSync()` - 删除文件
- `Directory.deleteSync()` - 删除目录

---

## 七、总结

本项目采用了 **清晰的分层架构**：

1. **UI 层**: 页面和组件负责展示和用户交互
2. **业务层**: Service 处理核心业务逻辑
3. **数据层**: Model 定义数据结构

数据流向遵循 **单向数据流** 原则：
- 用户操作 → Service → Model → UI 更新

这种架构使得代码易于维护和扩展，适合作为 Flutter 文件管理器应用的开发模板。
