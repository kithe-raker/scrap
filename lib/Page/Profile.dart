import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrap/widget/LongPaper.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Material(
      color: Colors.black,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: a.width / 20,
                right: a.width / 25,
                left: a.width / 25,
                bottom: a.width / 2.8),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
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
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        child: Icon(Icons.more_horiz,
                            color: Colors.white, size: a.width / 9),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: a.width / 10),
                  child: CircleAvatar(
                    maxRadius: a.width / 5,
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: a.width / 15),
                    child: Text(
                      "@vinatsataporn",
                      style: TextStyle(
                          color: Colors.white, fontSize: a.width / 20),
                    )),
                Container(
                    margin: EdgeInsets.only(top: a.width / 25),
                    child: Text(
                      "+66-633038380",
                      style: TextStyle(
                          color: Colors.white, fontSize: a.width / 25),
                    )),
                Container(
                  margin: EdgeInsets.only(top: a.width / 30),
                  padding: EdgeInsets.only(top: a.width / 10),
                  height: a.width / 2.5,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "12",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "เขียน",
                              style: TextStyle(
                                  color: Colors.white, fontSize: a.width / 25),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "41",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "ผู้คนหยิบอ่าน",
                              style: TextStyle(
                                  color: Colors.white, fontSize: a.width / 25),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "9",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "โดนปาใส่",
                              style: TextStyle(
                                  color: Colors.white, fontSize: a.width / 25),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: a.width / 1.5,
                  width: a.width,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white))),
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: a.width / 20),
                        child: Text(
                          "โดนปาใส่ล่าสุด",
                          style: TextStyle(
                              color: Colors.white, fontSize: a.width / 18),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: a.width / 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "กระดาษที่เก็บไว้",
                          style: TextStyle(
                              color: Colors.white, fontSize: a.width / 18),
                        ),
                      ),
                      Container(
                        child: Text(
                          "15" + " แผ่น",
                          style: TextStyle(
                              color: Colors.white, fontSize: a.width / 18),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: a.width,
                  height: a.width / 1,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[LongPaper(), LongPaper()],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
