import 'package:flutter/material.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class Block extends StatefulWidget {
  @override
  _BlockState createState() => _BlockState();
}

class _BlockState extends State<Block> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    screenutilInit(context);
    return Container(
      height: screenWidthDp / 2.18 * 1.21,
      width: screenWidthDp / 2.18,
      color: Colors.red,
    );
  }
}
