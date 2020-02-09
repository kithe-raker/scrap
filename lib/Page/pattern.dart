import 'package:flutter/material.dart';

class Pattern extends StatefulWidget {
  final dynamic data;
  Pattern({@required this.data});
  @override
  _PatternState createState() => _PatternState();
}

class _PatternState extends State<Pattern> {
  int a;
  @override
  Widget build(BuildContext context) {
    // switch ( a) {
    //   case 1:
    //     return 
    //     break;
    //   default: 
    //     return;
    // }
  }
  scrap(List title){
    
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
