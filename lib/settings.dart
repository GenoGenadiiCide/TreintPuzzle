import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedCategory = 'Nature';
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
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: Header(
            onSave: () async {
              if (_isOtherSelected &&
                  _customCategoryController.text.isNotEmpty) {
                await _saveSelectedCategory(_customCategoryController.text);
              } else {
                await _saveSelectedCategory(selectedCategory);
              }
            },
          ),
        ),
        body: Container(
          color: Color(0xFFE8E6E6),
          child: ListView(
            children: [
              ...categories
                  .map((category) => _buildCategoryRow(category))
                  .toList(),
              if (_isOtherSelected) _buildOtherCategoryInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryRow(String category) {
    return ListTile(
      title: Text(
        category,
        style: TextStyle(
          color: Color(0xFF352F2F),
          fontSize: 16,
          fontFamily: 'FiraMono',
        ),
      ),
      leading: Radio<String>(
        value: category,
        groupValue: selectedCategory,
        onChanged: (value) {
          setState(() {
            selectedCategory = value!;
            _isOtherSelected = selectedCategory == 'Other';
          });
        },
        activeColor: Color(0xFF80C668),
      ),
    );
  }

  Widget _buildOtherCategoryInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: TextField(
        controller: _customCategoryController,
        decoration: InputDecoration(
          hintText: 'Mountains',
          hintStyle: TextStyle(color: Color(0xFFA79494)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF352F2F)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF80C668)),
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final Function onSave;

  Header({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(color: Color(0xFFE8E6E6)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 4, left: 16, right: 12, bottom: 4),
            child: GestureDetector(
              onTap: () {
                onSave();
                Navigator.pop(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/Icon3.svg', width: 24, height: 24),
                  SizedBox(width: 8),
                  Text(
                    'Back',
                    style: TextStyle(
                      color: Color(0xFF352F2F),
                      fontSize: 18,
                      fontFamily: 'FiraMono',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Color(0xFF352F2F),
                  fontSize: 24,
                  fontFamily: 'FiraMono',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Divider(color: Color(0xFF352F2F)),
        ],
      ),
    );
  }
}
