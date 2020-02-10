import 'dart:math';

import 'package:flutter/material.dart';

class PatternScrap extends StatefulWidget {
  final List data;
  PatternScrap({@required this.data});
  @override
  _PatternScrapState createState() => _PatternScrapState();
}

class _PatternScrapState extends State<PatternScrap> {
  int b = 1;
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
        print('object');
        setState(() {
          //patternTop[0].re
          mData.remove(e);
        });
      },
    ));
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
