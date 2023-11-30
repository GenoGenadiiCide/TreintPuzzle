import 'package:flutter/material.dart';
import 'api.dart';
import 'dart:math';
import 'settings.dart';
import 'menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'puzzle.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MenuScreen(),
      routes: {
        '/puzzle': (context) => PuzzleScreen(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}

class PuzzleScreen extends StatefulWidget {
  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  ApiService apiService = ApiService();
  String imageUrl = "";
  late int maxRow, maxCol;
  late double puzzleWidth;
  late double puzzleHeight;
  List<Widget> pieces = [];
  bool isPuzzleCompleted = false;

  int piecesInPlace = 0;

  Future<String> _loadSelectedCategory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedCategory') ?? 'nature';
  }

  @override
  void initState() {
    super.initState();
    maxCol = Random().nextInt(3) + 3;
    maxRow = maxCol * 2;
    loadImage();
  }

  loadImage() async {
    String category = await _loadSelectedCategory();
    String url = await apiService.getRandomImage(category: category);
    setState(() {
      imageUrl = url;
      isPuzzleCompleted = false;
    });
  }

  void bringToTop(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.add(widget);
    });
  }

  void sendToBack(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.insert(0, widget);
      piecesInPlace++;
      if (piecesInPlace == maxRow * maxCol) {
        isPuzzleCompleted = true;
      }
    });
  }

  void _resetPuzzleAndLoadNewImage() {
    setState(() {
      imageUrl = "";
      piecesInPlace = 0;
      loadImage();
    });
  }

  void _downloadImage() async {
    if (imageUrl.isNotEmpty) {
      await GallerySaver.saveImage(imageUrl).then((bool? success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success == true
                ? 'Image saved to Gallery'
                : 'Error saving image'),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    puzzleWidth = MediaQuery.of(context).size.width * 0.8;
    puzzleHeight = MediaQuery.of(context).size.height * 0.75;

    return Scaffold(
      backgroundColor: Color(0xFFE8E6E6),
      body: SafeArea(
        child: Column(
          children: [
            Header(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imageUrl.isNotEmpty
                      ? Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: puzzleWidth,
                              height: puzzleHeight,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                color: Color(0xFFE8E6E6),
                              ),
                            ),
                            ...List.generate(maxRow, (row) {
                              return List.generate(maxCol, (col) {
                                return PuzzlePiece(
                                  image: Image.network(
                                    imageUrl,
                                    width: puzzleWidth,
                                    height: puzzleHeight,
                                    fit: BoxFit.cover,
                                  ),
                                  imageSize: Size(puzzleWidth, puzzleHeight),
                                  row: row,
                                  col: col,
                                  maxRow: maxRow,
                                  maxCol: maxCol,
                                  bringToTop: bringToTop,
                                  sendToBack: sendToBack,
                                );
                              });
                            }).expand((pieces) => pieces).toList(),
                          ],
                        )
                      : const CircularProgressIndicator(),
                  SizedBox(height: 20),
                  _buildButton(
                    title: "Download",
                    iconPath: 'assets/Icon4.svg',
                    onTap: isPuzzleCompleted ? _downloadImage : null,
                    width: puzzleWidth,
                  ),
                  SizedBox(height: 10),
                  _buildButton(
                    title: "Next",
                    onTap:
                        isPuzzleCompleted ? _resetPuzzleAndLoadNewImage : null,
                    width: puzzleWidth,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String title,
    VoidCallback? onTap,
    String? iconPath,
    double? width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap != null ? 1.0 : 0.5,
        child: Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconPath != null) ...[
                SvgPicture.asset(iconPath, width: 24, height: 24),
                SizedBox(width: 6),
              ],
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFF352F2F),
                  fontSize: 16,
                  fontFamily: 'FiraMono',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
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
              onTap: () => Navigator.pop(context),
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
        ],
      ),
    );
  }
}
