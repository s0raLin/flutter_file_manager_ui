import 'package:file_manager_ui/models/file_item.dart';
import 'package:flutter/material.dart';

class FileTile extends StatelessWidget {
  final FileItem file;
  final VoidCallback onTap;

  const FileTile({super.key, required this.file, required this.onTap});

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
      child: FolderCard(file: file),
    );
  }
}

class FolderCard extends StatelessWidget {
  final FileItem file;

  const FolderCard({super.key, required this.file});

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.check_box_outline_blank),
                Icon(Icons.more_vert),
              ],
            ),

            SizedBox(height: 10),

            // 文件夹图标区域
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  file.isDirectory ? Icons.folder : Icons.insert_drive_file,
                  size: 40,
                  color: Colors.blueGrey,
                ),
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

            Text("Feb 15", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
