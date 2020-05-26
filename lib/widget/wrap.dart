import 'package:flutter/material.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/block.dart';

class Wrapblock extends StatefulWidget {
  @override
  _WrapblockState createState() => _WrapblockState();
}

class _WrapblockState extends State<Wrapblock> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    screenutilInit(context);
    return Container(
      margin: EdgeInsets.only(bottom: screenHeightDp/10),
      child: Wrap(
        spacing: a.width / 42,
        runSpacing: a.width / 42,
        alignment: WrapAlignment.start,
        children: <Widget>[
          Block(),
          Block(),
          Block(),
          Block(),
          Block(),
          Block(),
          Block(),
        ],
      ),
    );
  }
}
