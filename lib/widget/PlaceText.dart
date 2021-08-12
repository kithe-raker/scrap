import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class PlaceText extends StatefulWidget {
  final String placeName;
  final DateTime time;
  PlaceText({@required this.placeName, @required this.time});
  @override
  _PlaceTextState createState() => _PlaceTextState();
}

class _PlaceTextState extends State<PlaceText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.placeName != null
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text('บริเวณ ',
                    style: TextStyle(
                        fontSize: s38,
                        fontFamily: 'ThaiSans',
                        height: 0.8,
                        color: Color(0xff969696))),
                SizedBox(
                  width: screenWidthDp / 1.6,
                  child: AutoSizeText(widget.placeName,
                      maxLines: 1,
                      minFontSize: 18,
                      style: TextStyle(
                          fontSize: s38,
                          height: 0.8,
                          fontFamily: 'ThaiSans',
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff26A4FF))),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text('เมื่อ ',
                    style: TextStyle(
                        fontSize: s38,
                        height: 0.8,
                        fontFamily: 'ThaiSans',
                        color: Color(0xff969696))),
                Text(readTimestamp(widget.time),
                    style: TextStyle(
                        fontSize: s38,
                        height: 0.8,
                        fontFamily: 'ThaiSans',
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
    );
  }

  String readTimestamp(DateTime date) {
    var now = DateTime.now();
    var format = DateFormat('dd/MM/yyyy');
    var diff = now.difference(date);
    var time = '';
    if (diff.inDays < 1) {
      if (diff.inSeconds <= 30) {
        time = 'ไม่กี่วินาทีที่ผ่านมานี้';
      } else if (diff.inSeconds <= 60) {
        time = diff.inSeconds.toString() + ' วินาทีที่แล้ว';
      } else if (diff.inMinutes < 5) {
        time = 'เมื่อไม่นานมานี้';
      } else if (diff.inMinutes < 60) {
        time = diff.inMinutes.toString() + ' นาทีที่แล้ว';
      } else {
        time = diff.inHours.toString() + ' ชั่วโมงที่แล้ว';
      }
    } else if (diff.inDays < 7) {
      diff.inDays == 1
          ? time = 'เมื่อวานนี้'
          : time = diff.inDays.toString() + ' วันที่แล้ว';
    } else {
      diff.inDays == 7 ? time = 'สัปดาที่แล้ว' : time = format.format(date);
    }
    return time;
  }
}
