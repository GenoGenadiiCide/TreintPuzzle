import 'package:flutter/material.dart';
import 'api.dart';
import 'puzzle.dart';
import 'dart:math';
import 'settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PuzzleScreen(),
      routes: {
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

  int piecesInPlace = 0;

  @override
  void initState() {
    super.initState();
    maxCol = Random().nextInt(3) + 3;
    maxRow = maxCol * 2;
    loadImage();
  }

  loadImage() async {
    String url = await apiService.getRandomImage();
    setState(() {
      imageUrl = url;
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
    });
  }

  void _showCompletedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Puzzle Completed!"),
          actions: [
            TextButton(
              child: const Text("Next"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetPuzzleAndLoadNewImage();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetPuzzleAndLoadNewImage() {
    setState(() {
      imageUrl = "";
      piecesInPlace = 0;
      loadImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    puzzleWidth = MediaQuery.of(context).size.width * 0.8;
    puzzleHeight = MediaQuery.of(context).size.height * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text('Puzzle'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: imageUrl.isNotEmpty
              ? Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: puzzleWidth,
                      height: puzzleHeight,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        color: Colors.grey,
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
                          sendToBack: (widget) {
                            sendToBack(widget);
                            piecesInPlace++;
                            if (piecesInPlace == maxRow * maxCol) {
                              _showCompletedDialog();
                            }
                          },
                        );
                      });
                    }).expand((pieces) => pieces).toList(),
                  ],
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
