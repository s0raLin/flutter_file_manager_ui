import 'package:file_manager_ui/models/FileItem/index.dart';
import 'package:file_manager_ui/utils/fileTypeUtil.dart';
import 'package:flutter/material.dart';

class FileTile extends StatelessWidget {
  final FileItem file;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onStar;
  final VoidCallback onCopy;
  final VoidCallback onMove;
  final VoidCallback onDetails;
  final VoidCallback onDelete;

  const FileTile({
    super.key,
    required this.file,
    required this.onTap,
    required this.onShare,
    required this.onCopy,
    required this.onMove,
    required this.onDetails,
    required this.onDelete,
    required this.onStar,
  });

  @override
  Widget build(BuildContext context) {
    // return ListTile(
    //   leading: Icon(
    //     file.isDirectory ? Icons.folder : Icons.insert_drive_file,
    //     color: file.isDirectory ? Colors.orange : Colors.grey,
    //   ),
    //   title: Text(file.name),
    //   onTap: onTap,
    // );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: FolderCard(
        file: file,
        onShare: onShare,
        onStar: onStar,
        onCopy: onCopy,
        onMove: onMove,
        onDetails: onDetails,
        onDelete: onDelete,
      ),
    );
  }
}

class FolderCard extends StatelessWidget {
  final FileItem file;
  final VoidCallback? onShare;
  final VoidCallback? onCopy;
  final VoidCallback? onMove;
  final VoidCallback? onDetails;
  final VoidCallback? onDelete;
  final VoidCallback? onStar;

  const FolderCard({
    super.key,
    required this.file,
    this.onShare,
    this.onCopy,
    this.onMove,
    this.onDetails,
    this.onDelete,
    this.onStar,
  });

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.share, color: Colors.blue),
              title: Text('分享'),
              onTap: () {
                Navigator.pop(context);
                onShare?.call();
              },
            ),
            ListTile(
              leading: Icon(Icons.star_border),
              title: Text("收藏"),
              onTap: () {
                Navigator.pop(context);
                onStar?.call();
              },
            ),
            ListTile(
              leading: Icon(Icons.copy, color: Colors.orange),
              title: Text('复制'),
              onTap: () {
                Navigator.pop(context);
                onCopy?.call();
              },
            ),
            ListTile(
              leading: Icon(Icons.drive_file_move, color: Colors.purple),
              title: Text('移动'),
              onTap: () {
                Navigator.pop(context);
                onMove?.call();
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.green),
              title: Text('文件详情'),
              onTap: () {
                Navigator.pop(context);
                onDetails?.call();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('删除'),
              onTap: () {
                Navigator.pop(context);
                onDelete?.call();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //顶部操作
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => _showMoreOptions(context),
                  child: Icon(Icons.more_vert),
                ),
              ],
            ),

            SizedBox(height: 10),

            // 文件夹图标区域
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 233, 221, 255),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                //   child: Icon(
                //     file.isDirectory ? Icons.folder : Icons.insert_drive_file,
                //     size: 40,
                //     color: Color.fromARGB(255, 101, 85, 143),
                //   ),
                // ),
                child: buildFileThumbnail(file),
              ),
            ),
            SizedBox(height: 12),

            // 文件夹名字
            Text(
              file.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 4),

            Text(file.date, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
