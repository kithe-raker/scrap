import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PatternScrap extends StatefulWidget {
  final List data;
  PatternScrap({@required this.data});
  @override
  _PatternScrapState createState() => _PatternScrapState();
}

class _PatternScrapState extends State<PatternScrap> {
  int b = 0;
  List mData = [];
  Random rnd = Random();
  Map<int, List<double>> patternTop = {
    0: [48, 4, 1.6, 72, 1.8, 3, 5.2, 1.7],
    1: [48, 4, 1.6, 72, 1.8, 3, 5.2, 1.7],
  };
  Map<int, List<double>> patternLeft = {
    0: [5, 12, 12, 1.6, 2.6, 1.6, 1.3, 1.4],
    1: [5, 12, 12, 1.6, 2.6, 1.6, 1.3, 1.4],
  };
  @override
  void initState() {
    mData = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      height: a.height / 1.2,
      width: a.width,
      child: Stack(
        children: mData
            .map((e) => Positioned(
                top: a.height / (patternTop[b][widget.data.indexOf(e)]),
                left: a.width / (patternLeft[b][widget.data.indexOf(e)]),
                child: scrap(a, e)))
            .toList(),
      ),
    );
  }

  Widget scrap(Size a, String e) {
    return Container(
        child: InkWell(
      child: Stack(
        children: <Widget>[
          Image.asset(
            './assets/paper.png',
            height: a.height / 21,
            fit: BoxFit.cover,
          ),
        ],
      ),
      onTap: () {
        dialog(e);
        setState(() {
          patternTop[0].removeAt(mData.indexOf(e));
          patternLeft[0].removeAt(mData.indexOf(e));
          mData.remove(e);
        });
      },
    ));
  }

  dialog(String text) {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              backgroundColor: Colors.transparent,
              content:
                  StatefulBuilder(builder: (context, StateSetter setState) {
                Size a = MediaQuery.of(context).size;
                return Container(
                  width: a.width,
                  height: a.height / 1.76,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: a.width,
                        child: Image.asset(
                          'assets/paper-readed.png',
                          width: a.width,
                          height: a.height / 2.1,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('เขียนโดย : ใครสักคน'),
                                Text('เวลา : 9:00')
                              ],
                            ),
                          )),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: a.width / 1.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  width: a.width / 3.5,
                                  height: a.width / 6.5,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
                                  alignment: Alignment.center,
                                  child: Text("เก็บไว้",
                                      style: TextStyle(
                                          fontSize: a.width / 15,
                                          color: Color(0xff26A4FF))),
                                ),
                                onTap: () async {
                                  Navigator.pop(context);
                                  await Firestore.instance
                                      .collection('User')
                                      .document('scraps')
                                      .updateData({
                                    'collects': FieldValue.arrayUnion([text])
                                  });
                                },
                              ),
                              InkWell(
                                child: Container(
                                  width: a.width / 3.5,
                                  height: a.width / 6.5,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "ทิ้งไว้",
                                    style: TextStyle(fontSize: a.width / 15),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          left: a.width / 16,
                          top: a.height / 12,
                          child: Container(
                            alignment: Alignment.center,
                            height: a.height / 3.2,
                            width: a.width / 1.48,
                            child: Text(
                              text,
                              style: TextStyle(fontSize: a.width / 14),
                            ),
                          ))
                    ],
                  ),
                );
              }));
        });
  }
}

/*
 List<String> hashList = [];
   snapshot.data['hashTag'].forEach((dat) => hashList.add(dat.toString()));
  DocumentSnapshot hash = snapshot.data;

    return Container(
                                height: scr.height / 8,
                                width: scr.width,
                                child: ListView(
                                  children: <Widget>[
                                    hashList.length == 0
                                        ? Text(
                                            'เลือกhasgTagของร้านคุณ',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : Wrap(
                                            children: hashList
                                                .map((hash) =>
                                                    chip(context, hash))
                                                .toList()),
                                  ],
                                ),
                              );
 */
