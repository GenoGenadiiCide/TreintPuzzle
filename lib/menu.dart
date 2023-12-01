import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treintpuzzle/gal.dart';
import 'main.dart';
import 'settings.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: MainMenu(),
        ),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          width: screenWidth,
          height: screenHeight,
          padding: const EdgeInsets.only(
            top: 252,
            left: 40,
            right: 40,
            bottom: 52,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Color(0xFFE8E6E6)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PuzzleScreen()),
                    );
                  },
                  child: SizedBox(
                    width: 148,
                    height: 130,
                    child: SvgPicture.asset("assets/Playbutton.svg"),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.2),
              _buildButton(
                title: 'Gallery',
                iconPath: 'assets/Icon1.svg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GalPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildButton(
                title: 'Settings',
                iconPath: 'assets/Icon2.svg',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
      {required String title, VoidCallback? onTap, String? iconPath}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null) ...[
              SvgPicture.asset(iconPath, width: 24, height: 24),
              const SizedBox(width: 6),
            ],
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF352F2F),
                fontSize: 16,
                fontFamily: 'FiraMono',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
