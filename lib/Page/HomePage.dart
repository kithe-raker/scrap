import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Material(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.black,
            width: a.width,
            height: a.width / 5,
            padding: EdgeInsets.only(
              right: a.width / 20,
              left: a.width / 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    height: a.width / 5,
                    alignment: Alignment.center,
                    child: Text("SCRAP.",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: a.width / 15,
                        ))),
                Container(
                    height: a.width / 5,
                    alignment: Alignment.center,
                    child: Container(
                      width: a.width / 10,
                      height: a.width / 10,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(a.width),color: Colors.white,),
                      child: Icon(Icons.person,color: Colors.black,size: a.width/15),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
