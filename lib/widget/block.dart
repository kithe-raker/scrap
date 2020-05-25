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
      height: 407 / 365 / 1.035 * s65 * s17,
      width: 365 / 407 / 1.035 * s65 * s17,
      color: Colors.red,
    );
  }
}
