import 'dart:ui';
import 'package:flutter/material.dart';

class Burn extends StatefulWidget {
  @override
  _BurnState createState() => _BurnState();
}

class _BurnState extends State<Burn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: InkWell(
            child: Text('Burn'),
            onTap: () {
              // _showdialogblock(context);
              _whatshot(context);
            },
          ),
        ),
      ),
    );
  }
}

void _whatshot(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Size a = MediaQuery.of(context).size;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                InkWell(
                  child: Container(
                    width: a.width,
                    height: a.height,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  width: a.width,
                  height: a.height,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.whatshot,
                          size: a.width / 3,
                          color: Color(0xffFF8F3A),
                        ),
                        Text(
                          "สแครปนี้โดนเผาแล้ว !",
                          style: TextStyle(
                              fontSize: a.width / 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "ขอบคุณสำหรับการควบคุมเนื้อหา",
                          style: TextStyle(
                              fontSize: a.width / 17,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
