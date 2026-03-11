import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedLanguage = 'en_US';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language'), centerTitle: true),
      body: ListView(
        children: [
          RadioListTile(
            title: const Text('English (US)'),
            value: 'en_US',
            groupValue: _selectedLanguage,
            onChanged: (val) => setState(() => _selectedLanguage = val!),
          ),
          RadioListTile(
            title: const Text('中文 (简体)'),
            value: 'zh_CN',
            groupValue: _selectedLanguage,
            onChanged: (val) => setState(() => _selectedLanguage = val!),
          ),
          RadioListTile(
            title: const Text('日本语 (JP)'),
            value: 'ja_JP',
            groupValue: _selectedLanguage,
            onChanged: (val) => setState(() => _selectedLanguage = val!),
          ),
        ],
      ),
    );
  }
}
