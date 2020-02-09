import 'package:flutter/material.dart';

class PatternScrap extends StatefulWidget {
  final List data;
  PatternScrap({@required this.data});
  @override
  _PatternScrapState createState() => _PatternScrapState();
}

class _PatternScrapState extends State<PatternScrap> {
  int b = 1;
  Map<int, List<double>> patternTop = {
    1: [48, 4, 1.6, 72, 1.8, 1.9, 2.1, 1.1],
    2: [213.23, 123.213]
  };
  Map<int, List<double>> patternLeft = {
    1: [5, 5.2, 12, 1.6, 2.6, 1.2, 1.1, 1.1],
    2: [123.123, 112.22]
  };
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      height: a.height / 1.2,
      width: a.width,
      child: Stack(
        children: widget.data
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
        color: Colors.yellow,
        height: a.width / 8,
        width: a.width / 8,
        child: Stack(
          children: <Widget>[
            Image.asset(
              './assets/paper.png',
            ),
            Text(e),
          ],
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
