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
  String type = 'Analysts';
  String select;

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
              height: a.height / 1.1,
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
                              color: Color(0xff1a1a1a),
                              blurRadius: 3.0,
                              spreadRadius: 2.0,
                              offset: Offset(
                                0.0,
                                3.2,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.circular(a.width),
                          color: Colors.white),
                      child: Icon(
                        Icons.location_on,
                        color: Color(0xff26A4FF),
                        size: a.width / 12,
                      ),
                    ),
                    SizedBox(
                      width: a.width / 21,
                    ),
                    Container(
                      width: a.width / 7,
                      height: a.width / 7,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff1a1a1a),
                              blurRadius: 10.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                0.0,
                                2.0,
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.circular(a.width),
                          color: Color(0xff26A4FF)),
                      child: IconButton(
                        icon: Icon(Icons.refresh),
                        color: Colors.white,
                        iconSize: a.width / 15,
                        onPressed: () {
                          selectDialog(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          scrapPatt(a, type, context),
          Positioned(
            bottom: a.height / 42,
            left: a.width / 2.8,
            child: InkWell(
              child: Container(
                width: a.width / 3.6,
                height: a.width / 3.6,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(a.width),
                    border: Border.all(
                        color: Colors.white38, width: a.width / 500)),
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
                      size: a.width / 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              onTap: () {
                dialog();
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              color: Colors.black,
              width: a.width,
              height: a.width / 5,
              padding: EdgeInsets.only(
                top: a.height / 36,
                right: a.width / 20,
                left: a.width / 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: a.width / 6,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/SCRAP.png',
                        width: a.width / 4,
                      )),
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
        ],
      ),
    );
  }

  // Widget changeScrap(String scraps, Size a) {
  //   switch (scraps) {
  //     case 'Analysts':
  //       return scrapPatt(a, 'Analysts');
  //       break;
  //     case 'Diplomats':
  //       return scrapPatt(a, 'Diplomats');
  //       break;
  //     case 'Explorers':
  //       return scrapPatt(a, 'Explorers');
  //       break;
  //     case 'Girl':
  //       return scrapPatt(a, 'Girl');
  //       break;
  //     case 'Sentinels':
  //       return scrapPatt(a, 'Sentinels');
  //       break;
  //     default:
  //       return scrapPatt(a, 'Analysts');
  //       break;
  //   }
  // }

  scrapPatt(Size a, String scrap, BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Contents')
            .document(scrap)
            .snapshots(),
        builder: (context, snap) {
          if (snap.hasData && snap.connectionState == ConnectionState.active) {
            Set mData = {};
            Random rand = Random();
            while (mData.length < 8 &&
                mData.length != snap.data['Contents'].length) {
              mData.add(snap.data['Contents']
                  [rand.nextInt(snap.data['Contents'].length)]);
            }
            return Center(
              child: Container(
                  height: a.height / 1.4,
                  width: a.width,
                  child: Stack(
                    children: <Widget>[
                      PatternScrap(data: mData.toList()),
                      Center(
                        child: Image.asset(
                          './assets/yourlocation-icon-xl.png',
                          height: a.height / 9,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  )),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  selectDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
              content: StreamBuilder(
                  stream: Firestore.instance.collection('Contents').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active) {
                      Set head = {};
                      QuerySnapshot title = snapshot.data;
                      for (var item in title.documents) {
                        head.add(item.documentID);
                      }
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: Column(
                              children: <Widget>[
                                Column(
                                    children: head
                                        .map((e) => choice(e, setState))
                                        .toList()),
                                butt()
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }));
        });
  }

  Widget choice(String value, StateSetter setState) {
    return Row(
      children: <Widget>[
        Radio(
          activeColor: Color(0xffEF7D36),
          value: value,
          groupValue: select,
          onChanged: (val) {
            setState(() {
              select = val;
            });
          },
        ),
        Text(
          value,
        )
      ],
    );
  }

  Widget butt() {
    return RaisedButton(
        child: Text('ok'),
        onPressed: () {
          setState(() {
            type = select;
          });
          print(type);
          Navigator.pop(context);
        });
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
                  width: a.width,
                  height: a.height / 1.3,
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
                                        width: a.width / 15,
                                        height: a.width / 15,
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
                            margin: EdgeInsets.only(top: a.width / 50),
                            width: a.width / 1,
                            height: a.height / 2,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  child: Image.asset(
                                    'assets/paper-readed.png',
                                    width: a.width / 1,
                                    height: a.height / 2,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: a.width / 20, top: a.width / 20),
                                  width: a.width,
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "เขียนโดย" + " : " + "ใครสักคน",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text("เวลา" + " : " + "09.37",
                                          style: TextStyle(color: Colors.grey))
                                    ],
                                  ),
                                ),
                                Container(
                                  width: a.width,
                                  height: a.height,
                                  alignment: Alignment.center,
                                  child: TextField(
                                      textAlign: TextAlign.center,style: TextStyle(fontSize: a.width/15),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'เขียนข้อความบางอย่าง',
                                        hintStyle: TextStyle(
                                          fontSize: a.width / 15,
                                          color: Colors.grey,
                                        ),
                                      )),
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
                                    width: a.width / 4,
                                    height: a.width / 7,
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
                                    width: a.width / 4,
                                    height: a.width / 7,
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
                                  width: a.width / 1.7,
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
