import 'dart:async';

import 'package:countdown/countdown.dart';
import 'package:flutter/material.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class CountDownText extends StatefulWidget {
  final DateTime startTime;
  CountDownText({@required this.startTime});
  @override
  _CountDownTextState createState() => _CountDownTextState();
}

class _CountDownTextState extends State<CountDownText> {
  final now = DateTime.now();
  int secondLeft;
  CountDown countDown;
  StreamSubscription countDownSub;

  @override
  void initState() {
    var duration = widget.startTime.add(Duration(hours: 24)).difference(now);
    countDown = CountDown(Duration(seconds: duration.inSeconds));
    secondLeft = duration.inSeconds;
    countDownSub = countDown.stream.listen((event) {
      setState(() => secondLeft = event.inSeconds);
    });
    super.initState();
  }

  @override
  void didUpdateWidget(CountDownText oldWidget) {
    if (oldWidget.startTime != widget.startTime) {
      countDownSub.cancel();
      var duration = widget.startTime.add(Duration(hours: 24)).difference(now);
      countDown = CountDown(Duration(seconds: duration.inSeconds));
      secondLeft = duration.inSeconds;
      countDownSub = countDown.stream.listen((event) {
        setState(() => secondLeft = event.inSeconds);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    countDownSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return secondLeft < 1
        ? Text('สแครปแผ่นนี้หมดเวลาแล้ว',
            style:
                TextStyle(fontSize: s38, height: 0.8, color: Color(0xff969696)))
        : Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text('เหลือเวลาอีก : ',
                  style: TextStyle(
                      fontSize: s36, height: 0.8, color: Color(0xff969696))),
              Text(formatHHMMSS(secondLeft),
                  style: TextStyle(
                      fontSize: s38,
                      height: 0.8,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          );
  }

  String formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "00:$minutesStr:$secondsStr";
    }
    return "$hoursStr:$minutesStr:$secondsStr";
  }
}
