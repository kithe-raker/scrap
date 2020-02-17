import 'package:flutter/material.dart';
import 'package:scrap/widget/Arrow_back.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          width: a.width,
          height: a.height,
          color: Colors.black,
          child: Column(
            children: <Widget>[
              Container(
                width: a.width,
                child: Arrow_back(),
              ),
              Container(
                padding: EdgeInsets.only(left: a.width / 15, top: a.width / 10),
                width: a.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Text("เกี่ยวกับแอปพลิเคชัน",style: TextStyle(color: Colors.white,fontSize: a.width/8)),
                  Text("ข้อมูลทั่วไปของแอปพลิเคชัน",style: TextStyle(color: Colors.white,fontSize: a.width/20))
                ],),
              ),
              Container(child: Stack(children: <Widget>[Container(child: Image.asset("assets/paper-readed.png"))],),)
            ],
          ),
        ));
  }
}
