import 'package:flutter/material.dart';
import 'api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedCategory = 'nature';
  final categories = [
    'Природа',
    'Город',
    'Океан',
    'Животные',
    'Птицы',
    'Космос'
  ];

  Future<void> _saveSelectedCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedCategory', category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Настройки')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            leading: Radio(
              value: categories[index],
              groupValue: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _saveSelectedCategory(selectedCategory);
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
