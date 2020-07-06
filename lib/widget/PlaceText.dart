import 'package:flutter/cupertino.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class PlaceText extends StatefulWidget {
  final String placeName;
  PlaceText({@required this.placeName});
  @override
  _PlaceTextState createState() => _PlaceTextState();
}

class _PlaceTextState extends State<PlaceText> {
  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Container(
      child: widget.placeName != null
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text('บริเวณ ',
                    style: TextStyle(
                        fontSize: s38, height: 0.8, color: Color(0xff969696))),
                Text(widget.placeName,
                    style: TextStyle(
                        fontSize: s38,
                        height: 0.8,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff26A4FF))),
              ],
            )
          : SizedBox(),
    );
  }
}
