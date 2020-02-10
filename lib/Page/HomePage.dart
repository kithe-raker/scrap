import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrap/Page/pattern.dart';

import 'Profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(bottom: a.width / 10),
              alignment: Alignment.bottomCenter,
              width: a.width,
              height: a.height / 1.119,
              color: Colors.black87,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: a.width / 7,
                      height: a.width / 7,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 10.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                0.0,
                                3.0,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.circular(a.width),
                          color: Colors.white),
                      child: Icon(
                        Icons.person_add,
                        color: Colors.black,
                        size: a.width / 15,
                      ),
                    ),
                    InkWell(
                      child: Container(
                        width: a.width / 4,
                        height: a.width / 4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(a.width),
                            border: Border.all(
                                color: Colors.white, width: a.width / 500)),
                        child: Container(
                          margin: EdgeInsets.all(a.width / 35),
                          width: a.width / 5,
                          height: a.width / 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(a.width),
                              border: Border.all(color: Colors.white)),
                          child: Container(
                            margin: EdgeInsets.all(a.width / 35),
                            width: a.width / 5,
                            height: a.width / 5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(a.width),
                                color: Colors.white,
                                border: Border.all(color: Colors.white)),
                            child: Icon(
                              Icons.create,
                              size: a.width / 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        dialog();
                      },
                    ),
                    Container(
                      width: a.width / 7,
                      height: a.width / 7,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 10.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                0.0,
                                3.0,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.circular(a.width),
                          color: Color(0xff26A4FF)),
                      child: Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: a.width / 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              color: Colors.black,
              width: a.width,
              height: a.width / 4,
              padding: EdgeInsets.only(
                top: a.height / 36,
                right: a.width / 20,
                left: a.width / 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      height: a.width / 5,
                      alignment: Alignment.center,
                      child: Text("SCRAP.",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: a.width / 15,
                          ))),
                  Container(
                      height: a.width / 5,
                      alignment: Alignment.center,
                      child: InkWell(
                        child: Container(
                          width: a.width / 10,
                          height: a.width / 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(a.width),
                            color: Colors.white,
                          ),
                          child: Icon(Icons.person,
                              color: Colors.black, size: a.width / 15),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile()));
                        },
                      ))
                ],
              ),
            ),
          ),
          StreamBuilder(
              stream: Firestore.instance
                  .collection('Contents')
                  .document('FunnyQuote')
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData ||
                    snap.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  Set mData = {};
                  Random rand = Random();
                  while (mData.length < 8) {
                    mData.add(snap.data['Content']
                        [rand.nextInt(snap.data['Content'].length)]);
                  }
                  return Center(
                    child: Container(
                        height: a.height / 1.4,
                        width: a.width,
                        child: PatternScrap(data: mData.toList())),
                  );
                }
              }),
          Center(
            child: Image.asset(
              './assets/yourlocation-icon-xl.png',
              height: a.height / 9,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }

  dialog() {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              content:
                  StatefulBuilder(builder: (context, StateSetter setState) {
                Size a = MediaQuery.of(context).size;
                return Container(
                  width: a.width / 1.2,
                  height: a.height / 1.5,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            width: a.width,
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: a.width / 10,
                                        height: a.width / 10,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white)),
                                      ),
                                      Container(
                                        child: Text(
                                          "   เปิดเผยตัวตน",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: a.width / 20),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  child: Icon(
                                    Icons.clear,
                                    size: a.width / 10,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: a.width / 20),
                            width: a.width / 1.2,
                            height: a.width / 1.2,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  child: Image.asset('assets/paper-readed.png'),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: a.width / 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                    width: a.width / 3.5,
                                    height: a.width / 6.5,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(a.width)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "ทิ้งไว้",
                                      style: TextStyle(fontSize: a.width / 15),
                                    )),
                                InkWell(
                                  child: Container(
                                    width: a.width / 3.5,
                                    height: a.width / 6.5,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(a.width)),
                                    alignment: Alignment.center,
                                    child: Text("ปาใส่",
                                        style:
                                            TextStyle(fontSize: a.width / 15)),
                                  ),
                                  onTap: () {
                                    dialog2();
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }));
        });
  }

  dialog2() {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              content:
                  StatefulBuilder(builder: (context, StateSetter setState) {
                Size a = MediaQuery.of(context).size;
                return Container(
                  width: a.width / 1.2,
                  height: a.height / 1.2,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  child: Icon(Icons.arrow_back,
                                      size: a.width / 10, color: Colors.white),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                InkWell(
                                  child: Icon(Icons.clear,
                                      size: a.width / 10, color: Colors.white),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: a.width / 20),
                            width: a.width / 1.1,
                            height: a.width,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.circular(a.width / 10)),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: a.width / 20),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(a.width / 10),
                                    color: Colors.black,
                                  ),
                                  width: a.width / 2,
                                  height: a.width / 7,
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: a.width / 10),
                              child: InkWell(
                                child: Container(
                                  width: a.width / 3.5,
                                  height: a.width / 6.5,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
                                  alignment: Alignment.center,
                                  child: Text("ปาใส่",
                                      style: TextStyle(fontSize: a.width / 15)),
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                );
              }));
        });
  }
}
