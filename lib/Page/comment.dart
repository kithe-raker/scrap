import 'package:flutter/material.dart';
import 'package:scrap/widget/Arrow_back.dart';

class Comment extends StatefulWidget {
  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: a.width,
                height: a.width / 3.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        child: Column(children: <Widget>[
                      Container(
                          color: Colors.black,
                          width: a.width / 4,
                          height: a.height / 7,
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
                                                    BorderRadius.circular(
                                                        a.width),
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
                    ])),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(
                        top: a.width / 15,
                        right: a.width / 25,
                      ),
                      child: Text(
                        "ความเห็น",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                            color: Colors.white, fontSize: a.width / 10),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    lconta("ชอบ", "1", 0xff13AD8F),
                    lconta("ไม่ชอบ", "1", 0xffAD1313),
                    lconta("เฉยๆ", "1", 0xff656565)
                  ],
                ),
              ),
              Container(
                width: a.width,
                height: a.height / 1.28,
                child: ListView(
                  children: <Widget>[
                    card("@somename","10:58"," 18 March 2020","หน้ากินจุง","ชอบ", 0xff13AD8F),
                     card("@somename","10:58"," 18 March 2020","ลงเหี้ยอะไรตอนนี้","ไม่ชอบ", 0xffAD1313),
                      card("@somename","10:58"," 18 March 2020","อีกไหมคับ","เฉยๆ", 0xff656565),
                  ],
                ),
              )
            ],
          ),
          Container(
            width: a.width,
            height: a.width / 5,
            color: Color(0xff272727),
            margin: EdgeInsets.only(top: a.height / 1.1),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: a.width / 25,
                      bottom: a.width / 25,
                      left: a.width / 30),
                  width: a.width / 1.2,
                  height: a.width / 12,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(a.width),
                      border: Border.all(color: Color(0xff707070))),
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: EdgeInsets.only(left: a.width / 20),
                      child: Text(
                        "แสดงความคิดเห็น",
                        style: TextStyle(
                            fontSize: a.width / 18, color: Color(0xff707070)),
                      )),
                ),
                Container(
                    margin: EdgeInsets.only(left: a.width / 20),
                    child: Icon(Icons.send, color: Colors.white))
              ],
            ),
          )
        ],
      ),
    );
  }

  lconta(String text01, String num01, int color) {
    Size a = MediaQuery.of(context).size;
    return Container(
        width: a.width / 5,
        height: a.width / 15,
        decoration: BoxDecoration(
            color: Color(color), borderRadius: BorderRadius.circular(a.width)),
        margin: EdgeInsets.only(left: a.width / 20),
        alignment: Alignment.center,
        child: Text(text01 + " :" + num01,
            style: TextStyle(color: Colors.white, fontSize: a.width / 20)));
  }

  card(String text001,text002,text003,text004,text005,int color001) {
    Size a = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: a.width / 25,right:a.width / 25,bottom: a.width / 25),
      padding: EdgeInsets.only(top:a.width / 30,bottom: a.width / 30,left: a.width / 30),
      decoration: BoxDecoration(
          color: Color(0xff272727),
          borderRadius: BorderRadius.circular(a.width / 30)),
      width: a.width,
      height: a.width / 3.2,
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: a.width/40),
                    width: a.width / 8,
                    height: a.width / 8,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(a.width),
                        border: Border.all(color: Colors.white)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    Text(text001,style: TextStyle(color:Color(0xff26A4FF),fontSize: a.width/18,)),
                    Text(text002+text003,style: TextStyle(color: Colors.white,fontSize: a.width/18,),)
                  ],)
                ],
              ),
              Container(     
                width: a.width/2,
                height: a.width/10,
                alignment: Alignment.bottomLeft,
                child: Text(text004,style: TextStyle(color: Colors.white,fontSize: a.width/15),))
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            width: a.width/2.59,
            height: a.width/8,
          
            child: Container(
              width: a.width/7.5,
            height: a.width/15,
            decoration: BoxDecoration(color: Color(color001),borderRadius: BorderRadius.only(topLeft: Radius.circular(a.width),bottomLeft:  Radius.circular(a.width))),
            alignment: Alignment.center,
            child: Text(text005,style: TextStyle(color: Colors.white,fontSize: a.width/20),),
            ),
          )
        ],
      ),
    );
  }
}
