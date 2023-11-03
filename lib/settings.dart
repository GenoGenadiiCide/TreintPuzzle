import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedCategory = 'nature';
  final categories = [
    'Nature',
    'City',
    'Ocean',
    'Animal',
    'Bird',
    'Space',
    'Other'
  ];
  final TextEditingController _customCategoryController =
      TextEditingController();
  bool _isOtherSelected = false;

  Future<void> _saveSelectedCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedCategory', category);
  }

  @override
  void dispose() {
    _customCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView.builder(
        itemCount: categories.length + (_isOtherSelected ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < categories.length) {
            return ListTile(
              title: Text(categories[index]),
              leading: Radio(
                value: categories[index],
                groupValue: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                    _isOtherSelected = selectedCategory == 'Other';
                  });
                },
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _customCategoryController,
                decoration: InputDecoration(
                  hintText: 'Forest',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^[a-zA-Z]{0,12}$')),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_isOtherSelected && _customCategoryController.text.isNotEmpty) {
            await _saveSelectedCategory(_customCategoryController.text);
          } else {
            await _saveSelectedCategory(selectedCategory);
          }
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
