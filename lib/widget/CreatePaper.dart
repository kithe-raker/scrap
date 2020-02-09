import 'package:flutter/material.dart';

class CreatePaper extends StatefulWidget {
  @override
  _CreatePaperState createState() => _CreatePaperState();
}

class _CreatePaperState extends State<CreatePaper> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
        width: a.width / 1.5,
        height: a.width / 4,
        color: Colors.grey,
        child: ListView(
          children: <Widget>[
            Stack(
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
                     
                    ],
                  ),
                ),
                
              ],
            ),
          ],
        ));
  }
}
