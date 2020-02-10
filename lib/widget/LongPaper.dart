import 'package:flutter/material.dart';

class LongPaper extends StatefulWidget {
  final String text;
  LongPaper({@required this.text});
  @override
  _LongPaperState createState() => _LongPaperState();
}

class _LongPaperState extends State<LongPaper> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(right: a.width / 15, top: a.width / 20),
        width: a.width / 1.5,
        height: a.width / 4,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(a.width / 40),
              width: a.width,
              height: a.width / 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("เขียนโดย : " + "ใครสักคน"),
                      Text("เวลา : " + "11.11"),
                    ],
                  ),
                  Icon(
                    Icons.delete,
                    color: Colors.black,
                    size: a.width / 12,
                  )
                ],
              ),
            ),
            Container(
              width: a.width,
              height: a.width,
              alignment: Alignment.center,
              child: Text(
                widget.text,
                style: TextStyle(fontSize: a.width / 15),
              ),
            )
          ],
        ));
  }
}
