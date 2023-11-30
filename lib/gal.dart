import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GalPage extends StatefulWidget {
  @override
  _GalPageState createState() => _GalPageState();
}

class _GalPageState extends State<GalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8E6E6),
      body: Column(
        children: [
          Header(
            onSave: () {},
          ),
        ],
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
                'Gallery',
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
