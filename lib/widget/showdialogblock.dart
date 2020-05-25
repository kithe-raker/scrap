import 'dart:ui';
import 'package:flutter/material.dart';

class Showblock extends StatefulWidget {
  @override
  _ShowblockState createState() => _ShowblockState();
}

class _ShowblockState extends State<Showblock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: InkWell(
            child: Text('Block'),
            onTap: () {
              _showdialogblock(context);
            },
          ),
        ),
      ),
    );
  }
}

void _showdialogblock(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Size a = MediaQuery.of(context).size;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            margin: EdgeInsets.only(
                top: a.width / 20,
                right: a.width / 20,
                left: a.width / 20,
                bottom: a.width / 5),
            child: Column(
              children: <Widget>[
                GestureDetector(
                    child: Container(
                      width: a.width,
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.only(
                            top: a.width / 20, bottom: a.width / 15),
                        width: a.width / 12,
                        height: a.width / 12,
                        child: Center(
                          child: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(a.width)),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    }),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xff282828),
                      borderRadius: BorderRadius.circular(a.width / 50)),
                  width: a.width,
                  padding: EdgeInsets.all(a.width / 50),
                  height: a.height / 1.4,
                  child: Scaffold(
                    backgroundColor: Color(0xff282828),
                    body: Container(
                      width: a.width,
                      height: a.height,
                      padding: EdgeInsets.only(
                          top: a.width / 10, bottom: a.width / 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Icon(
                                Icons.block,
                                color: Color(0xff8B8B8B),
                                size: a.width / 2.5,
                              ),
                              Text(
                                "บล๊อคผู้ใช้",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: a.width / 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            "คุณต้องการบล๊อคผู้ใช้รายนี้ไหม\nคุณจะไม่เห็นสแครปจากผู้ใช้รายนี้อีกต่อไป\nและผู้ใช้งานรายนี้จะไม่สามารถปาแครป\nหาคุณได้ด้วย",
                            style: TextStyle(
                                fontSize: a.width / 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Column(
                            children: <Widget>[
                              RaisedButton(
                                  color: Color(0xff797979),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(a.width),
                                  ),
                                  child: Container(
                                    width: a.width / 3.5,
                                    height: a.width / 8.5,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "บล๊อคจ่ะ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  onPressed: () {}),
                              Text(
                                '"แน่ใจนะ"',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}
