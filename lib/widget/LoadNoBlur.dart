import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class LoadNoBlur extends StatefulWidget {
  @override
  _LoadNoBlurState createState() => _LoadNoBlurState();
}

class _LoadNoBlurState extends State<LoadNoBlur> {
  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Container(
        width: screenWidthDp / 3.6,
        height: screenWidthDp / 3.6,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.42),
            borderRadius: BorderRadius.circular(12)),
        child: FlareActor('assets/loadingpaper.flr',
            animation: 'Untitled', fit: BoxFit.cover));
  }
}
