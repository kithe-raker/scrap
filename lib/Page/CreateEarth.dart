import 'package:flutter/material.dart';
import 'package:scrap/Page/Createtype.dart';
import 'package:scrap/widget/Arrow_back.dart';

class CreateEarth extends StatefulWidget {
  @override
  _CreateEarthState createState() => _CreateEarthState();
}

class _CreateEarthState extends State<CreateEarth> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          ArrowBack(),
          Image.asset("assets/M10.png", width: a.width / 1.4),
          Container(
              width: a.width / 1.5,
              height: a.width / 6.5,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(a.width)),
              alignment: Alignment.center,
              child: Text(
                "ชื่อโลก",
                style: TextStyle(color: Colors.grey, fontSize: a.width / 12),
              )),
          SizedBox(
            height: a.width / 30,
          ),
          InkWell(
            child: Container(
              width: a.width / 1.5,
              height: a.width / 6.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(a.width),
                  color: Colors.white),
              alignment: Alignment.center,
              child:Text(
                  "ต่อไป",
                  style: TextStyle(color: Color(0xff26A4FF), fontSize: a.width / 12,),
                )
            ),
             onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> Createtype001()));},
          ),
          SizedBox(
            height: a.width / 30,
          ),
          Text(
            "ทำไมต้องสร้างโลก?",
            style: TextStyle(color: Colors.white,decoration: TextDecoration.underline,),
          )
        ],
      ),
    );
  }
}
