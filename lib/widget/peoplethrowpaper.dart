import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class Paperstranger extends StatefulWidget {
  @override
  _PaperstrangerState createState() => _PaperstrangerState();
}

class _PaperstrangerState extends State<Paperstranger> {
  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: appBarHeight) / 2,
            child: Center(
              child: Stack(
                children: <Widget>[
                  Positioned(
                      child: Container(
                    height: 407 * appBarHeight / 75,
                    width: 365 * appBarHeight / 75,
                    color: Colors.white,
                  )),
                  Positioned(
                      right: 0,
                      child: Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Color(0xfff707070),
                            size: s70,
                          ),
                          onPressed: () {},
                        ),
                        //color: Colors.yellow,
                      )),
                  Positioned(
                      top: 407 * appBarHeight / 80 / 2,
                      left: 365 * appBarHeight / 80 / 2.5,
                      child: Container(
                          child: Text(
                        'เบื่อไอป้อม',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: s52),
                      ))),
                ],
              ),
            ),
          ),
          SizedBox(
            height: appBarHeight / 10,
          ),
          Container(
              height: appBarHeight * 1,
              // color: Colors.green,
              child: Stack(
                children: <Widget>[
                  /*  Positioned(
                      // left: appBarHeight / 3,
                      child: Container(
                    // color: Colors.red,
                    width: screenWidthDp,
                    height: appBarHeight / 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        '@MIKE',
                                        style: TextStyle(
                                            fontSize: s58,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xfff26A4FF)),
                                      ),
                                      Container(
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.more_horiz,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {}),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'เหลือเวลาอีก : ',
                                      style:
                                          TextStyle(color: Color(0xfff969696)),
                                    ),
                                    Text(
                                      '23:47:01 ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ]),
                        ),
                        SizedBox(
                          width: appBarHeight * 1.3,
                        ),
                      ],
                    ),
                  )),*/
                ],
              )),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(
            height: appBarHeight / 10,
          ),
          Container(
            height: appBarHeight,
            width: screenWidthDp,
            child: Stack(children: <Widget>[
              Positioned(
                  left: appBarHeight / 5,
                  child: Container(
                      child: IconButton(
                          icon: Icon(
                            Icons.move_to_inbox,
                            size: s60 * 1.2,
                            color: Color(0xfff0099FF),
                          ),
                          onPressed: () {}),
                      height: appBarHeight / 1.5,
                      width: appBarHeight / 1.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ))),
              Positioned(
                  left: appBarHeight * 1.05,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.reply,
                              size: s60 * 1.2,
                              color: Colors.white,
                            ),
                            Text('ปากลับ',
                                style: TextStyle(
                                  fontSize: s52,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                        height: appBarHeight / 1.5,
                        width: appBarHeight * 1.5,
                        decoration: BoxDecoration(
                          color: Color(0xfff26A4FF),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        )),
                  )),
              Positioned(
                  left: appBarHeight * 4,
                  child: Column(
                    children: <Widget>[
                      Container(
                          child: IconButton(
                              icon: Icon(
                                Icons.forward,
                                size: s60 * 1.2,
                              ),
                              onPressed: () {}),
                          height: appBarHeight / 1.5,
                          width: appBarHeight / 1.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          )),
                      SizedBox(
                        height: appBarHeight / 10,
                      ),
                      Text(
                        'ต่อไป',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: s40,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
            ]),
          ),
        ])));
  }
}
