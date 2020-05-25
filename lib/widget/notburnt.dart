//เผาไม่สำเร็จ
import 'dart:ui';
import 'package:flutter/material.dart';

class NotBurn extends StatefulWidget {
  @override
  _NotBurnState createState() => _NotBurnState();
}

class _NotBurnState extends State<NotBurn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: InkWell(
            child: Text('Burnt not success'),
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
                          color: Color(0xff909090),
                        ),
                        SizedBox(
                          height: a.width / 100,
                        ),
                        Text(
                          "สแครปนี้ยังไม่โดนเผา",
                          style: TextStyle(
                              fontSize: a.width / 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "ต้องการผู้เผามากกว่านี้",
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
