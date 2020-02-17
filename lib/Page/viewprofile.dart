import 'package:flutter/material.dart';

class Viewprofile extends StatefulWidget {
  @override
  _ViewprofileState createState() => _ViewprofileState();
}

class _ViewprofileState extends State<Viewprofile> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
        body: 
      Stack(
        children: <Widget>[
          Container(
            color: Colors.black,
            width: a.width,
            height: a.height,
          ),
          Column(
            children: <Widget>[
              Container(
                  color: Colors.black,
                  width: a.width,
                  height: a.height / 6,
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: a.width / 15,
                          right: a.width / 25,
                          left: a.width / 25,
                          bottom: a.width / 30.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                InkWell(
                                  //back btn
                                  child: Container(
                                    width: a.width / 7,
                                    height: a.width / 10,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(a.width),
                                        color: Colors.white),
                                    child: Icon(Icons.arrow_back,
                                        color: Colors.black,
                                        size: a.width / 15),
                                  ),
                                  onTap: () {
                                    Navigator.pop(
                                      context,
                                    );
                                  },
                                ),
                              ],
                            ), //back btn
                          ]))),
              Container(
                color: Colors.black,
                child: Container(
                    margin: EdgeInsets.only(left: 20, right: 13),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(a.width),
                        border: Border.all(
                            color: Colors.white, width: a.width / 190)),
                    width: a.width / 3.2,
                    height: a.width / 3.2,
                    child: Image.asset("assets/userprofile.png")),
              ),
              SizedBox(
                height: a.width / 15,
              ),
              Text(
                "@vinatsataporn",
                style: TextStyle(color: Colors.white, fontSize: a.width / 12),
              ),
             
              Text(
                "Join " + "15/02/2020",
                style: TextStyle(color: Colors.blue, fontSize: a.width / 12),
              ),
              Container(
                          margin: EdgeInsets.only(top: a.width / 30),
                          padding: EdgeInsets.only(top: a.width / 10),
                          height: a.width / 2.5,
                           //ใส่เส้นด้านใต้สุด
                          child: Row(
                            // ใส่ Row เพื่อเรียงแนวนอนของจำนวน ได้แก่ เขียน ผู้หยิบอ่าน ปาใส่
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                
                                child: Column(
                                  //เพื่อใช้สำหรับให้ จำนวน และ เขียน
                                  children: <Widget>[
                                    Text(
                                      "5",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "เขียน",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 21),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: a.width/10,right: a.width/10),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      //เพื่อใช้สำหรับ��ห้ จำนวน และ ผ�����้หยิบอ่าน
                                      "15",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "ผู้คนหยิบอ่าน",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 21),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  //เพื่อใช้สำหรับให้ จำนวน ��ละ โ��นปาใส��
                                  children: <Widget>[
                                    Text(
                                      "20",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "โดนปาใส่",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 21),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),InkWell(
              child: Container(
                width: a.width / 3.6,
                height: a.width / 3.6,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(a.width),
                    border: Border.all(
                        color: Colors.white38, width: a.width / 500)),
                child: Container(
                  margin: EdgeInsets.all(a.width / 35),
                  width: a.width / 5,
                  height: a.width / 5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(a.width),
                      border: Border.all(color: Colors.white)),
                  child: Container(
                    margin: EdgeInsets.all(a.width / 35),
                    width: a.width / 5,
                    height: a.width / 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(a.width),
                        color: Colors.white,
                        border: Border.all(color: Colors.white)),
                    child: Icon(
                      Icons.create,
                      size: a.width / 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              
            ),
            ],
          ),
        ],
      )
    );
  }
}
