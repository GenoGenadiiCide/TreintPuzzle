import 'package:flutter/material.dart';
import 'api.dart';

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
        onPressed: () {
          ApiService().getRandomImage(category: selectedCategory);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
