import 'package:flutter/material.dart';

class AddPlayer extends StatefulWidget {
  @override
  _AddPlayerState createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: a.width,
        height: a.height,
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  top: a.width / 15,
                  right: a.width / 25,
                  left: a.width / 25,
                  bottom: a.width / 8.0),
              child: Row(
                children: <Widget>[
                  InkWell(
                    //back btn
                    child: Container(
                      width: a.width / 7,
                      height: a.width / 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(a.width),
                          color: Colors.white),
                      child: Icon(Icons.arrow_back,
                          color: Colors.black, size: a.width / 15),
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: a.width,
              alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "ผู้คนรอบตัว",
                  style: TextStyle(color: Colors.white,fontSize: a.width/7),
                ),
                Text(
                    "พบกับระบบค้นหาผู้คนรอบตัวคุณ \nแล้วปากระดาษใส่พวกเขาได้ทันที เร็วๆนี้",
                    style: TextStyle(color: Colors.white,fontSize: a.width/20))
              ],
            )),
          ],
        ),
      ),
    );
  }
}
