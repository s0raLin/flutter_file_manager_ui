import 'package:flutter/material.dart';

class ThemeColorPage extends StatelessWidget {
  const ThemeColorPage({super.key});

  final List<Color> colors = const [Colors.deepPurple, Colors.blue, Colors.teal, Colors.orange];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Color')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: colors.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () { /* 这里更新全局主题 */ },
            child: CircleAvatar(backgroundColor: colors[index]),
          );
        },
      ),
    );
  }
}