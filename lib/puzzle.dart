import 'dart:math';
import 'package:flutter/material.dart';

class PuzzlePiece extends StatefulWidget {
  final Image image;
  final Size imageSize;
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;
  final Function bringToTop;
  final Function sendToBack;

  const PuzzlePiece(
      {Key? key,
      required this.image,
      required this.imageSize,
      required this.row,
      required this.col,
      required this.maxRow,
      required this.maxCol,
      required this.bringToTop,
      required this.sendToBack})
      : super(key: key);

  @override
  PuzzlePieceState createState() => PuzzlePieceState();
}

class PuzzlePieceState extends State<PuzzlePiece> {
  double? top;
  double? left;
  bool isMovable = true;
  double opacity = 1.0;
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    final imageWidth = widget.imageSize.width;
    final imageHeight = widget.imageSize.height;
    final pieceWidth = imageWidth / widget.maxCol;
    final pieceHeight = imageHeight / widget.maxRow;

    top ??= Random().nextInt((imageHeight - pieceHeight).ceil()).toDouble() -
        widget.row * pieceHeight;
    left ??= Random().nextInt((imageWidth - pieceWidth).ceil()).toDouble() -
        widget.col * pieceWidth;

    return Positioned(
      top: top,
      left: left,
      width: imageWidth,
      child: GestureDetector(
        onTap: () {
          if (isMovable) {
            widget.bringToTop(widget);
          }
        },
        onPanStart: (_) {
          if (isMovable) {
            widget.bringToTop(widget);
          }
        },
        onPanEnd: (_) {
          if (isDragging && isMovable) {
            if (-10 < top! && top! < 10 && -10 < left! && left! < 10) {
              setState(() {
                top = 0;
                left = 0;
                opacity = 0.9;
                isMovable = false;
                widget.sendToBack(widget);
              });
            }
            isDragging = false;
          }
        },
        onPanUpdate: (dragUpdateDetails) {
          if (isMovable) {
            setState(() {
              top = (top ?? 0) + dragUpdateDetails.delta.dy;
              left = (left ?? 0) + dragUpdateDetails.delta.dx;
            });
            isDragging = true;
          }
        },
        child: Opacity(
          opacity: opacity,
          child: isMovable
              ? ClipPath(
                  clipper: PuzzlePieceClipper(
                      widget.row, widget.col, widget.maxRow, widget.maxCol),
                  child: widget.image,
                )
              : IgnorePointer(
                  child: ClipPath(
                    clipper: PuzzlePieceClipper(
                        widget.row, widget.col, widget.maxRow, widget.maxCol),
                    child: widget.image,
                  ),
                ),
        ),
      ),
    );
  }
}

class PuzzlePieceClipper extends CustomClipper<Path> {
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;

  PuzzlePieceClipper(this.row, this.col, this.maxRow, this.maxCol);

  @override
  Path getClip(Size size) {
    return getPiecePath(size, row, col, maxRow, maxCol);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class PuzzlePiecePainter extends CustomPainter {
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;

  PuzzlePiecePainter(this.row, this.col, this.maxRow, this.maxCol);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0x80FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(getPiecePath(size, row, col, maxRow, maxCol), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

Path getPiecePath(Size size, int row, int col, int maxRow, int maxCol) {
  final width = size.width / maxCol;
  final height = size.height / maxRow;
  final offsetX = col * width;
  final offsetY = row * height;
  final bumpSize = height / 4;

  var path = Path();
  path.moveTo(offsetX, offsetY);

  if (row == 0) {
    path.lineTo(offsetX + width, offsetY);
  } else {
    path.lineTo(offsetX + width / 3, offsetY);
    path.cubicTo(
        offsetX + width / 6,
        offsetY - bumpSize,
        offsetX + width / 6 * 5,
        offsetY - bumpSize,
        offsetX + width / 3 * 2,
        offsetY);
    path.lineTo(offsetX + width, offsetY);
  }

  if (col == maxCol - 1) {
    path.lineTo(offsetX + width, offsetY + height);
  } else {
    path.lineTo(offsetX + width, offsetY + height / 3);
    path.cubicTo(
        offsetX + width - bumpSize,
        offsetY + height / 6,
        offsetX + width - bumpSize,
        offsetY + height / 6 * 5,
        offsetX + width,
        offsetY + height / 3 * 2);
    path.lineTo(offsetX + width, offsetY + height);
  }

  if (row == maxRow - 1) {
    path.lineTo(offsetX, offsetY + height);
  } else {
    path.lineTo(offsetX + width / 3 * 2, offsetY + height);
    path.cubicTo(
        offsetX + width / 6 * 5,
        offsetY + height - bumpSize,
        offsetX + width / 6,
        offsetY + height - bumpSize,
        offsetX + width / 3,
        offsetY + height);
    path.lineTo(offsetX, offsetY + height);
  }

  if (col == 0) {
    path.close();
  } else {
    path.lineTo(offsetX, offsetY + height / 3 * 2);
    path.cubicTo(
        offsetX - bumpSize,
        offsetY + height / 6 * 5,
        offsetX - bumpSize,
        offsetY + height / 6,
        offsetX,
        offsetY + height / 3);
    path.close();
  }

  return path;
}
