import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrap/widget/LongPaper.dart';

class Profile extends StatefulWidget {
  final DocumentSnapshot doc;
  Profile({@required this.doc});
  @override
  _ProfileState createState() => _ProfileState();
}

//หน้า Account
class _ProfileState extends State<Profile> {
  int page;
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
                // ||
                // ||   เป็นส่วนของรูปภาพ Profile
                //\  /
                // \/
                Container(
                    margin: EdgeInsets.only(top: a.width / 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(a.width),
                        border: Border.all(
                            color: Colors.white, width: a.width / 150)),
                    width: a.width / 3,
                    height: a.width / 3,
                    child: //widget.doc['img'] == null
                        Image.asset("assets/userprofile.png")
                    //: Image.network(widget.doc['img']),
                    ),
                // ชื่อของ account
                Container(
                    margin: EdgeInsets.only(top: a.width / 15),
                    child: Text(
                      "@", //+ widget.doc['name'],
                      style: TextStyle(
                          color: Colors.white, fontSize: a.width / 12),
                    )),
                // เบอร์โทรของ Account
                Container(
                    margin: EdgeInsets.only(top: a.width / 1000),
                    child: Text(
                      "+66-" + widget.doc['phone'],
                      style: TextStyle(
                          color: Colors.white, fontSize: a.width / 15),
                    )),
                // ใส่ Container เพื่อสร้างกรอบ
                Container(
                  margin: EdgeInsets.only(top: a.width / 30),
                  padding: EdgeInsets.only(top: a.width / 10),
                  height: a.width / 2.5,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: a.width / 1000,
                              color: Colors.white))), //ใส่เส้นด้านใต้สุด
                  child: Row(
                    // ใส่ Row เพื่อเรียงแนวนอนของจำนวน ได้แก่ เขียน ผู้หยิบอ่าน ปาใส่
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child: Column(
                          //เพื่อใช้สำหรับให้ จำนวน และ เขียน
                          children: <Widget>[
                            Text(
                              "12",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 10,
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
                              //เพื่อใช้สำหรับให้ จำนวน และ ผู้หยิบอ่าน
                              "41",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 10,
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
                          //เพื่อใช้สำหรับให้ จำนวน และ โดนปาใส่
                          children: <Widget>[
                            Text(
                              "9",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 10,
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
                  width: a.width,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.white,
                    width: a.width / 1000,
                  ))),
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: a.width,
                        padding: EdgeInsets.only(top: a.width / 20),
                        child: Text(
                          "โดนปาใส่ล่าสุด",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: a.width / 18),
                        ),
                      ),
                      Container(
                        width: a.width,
                        child: StreamBuilder(
                            stream: Firestore.instance
                                .collection('User')
                                .document('scraps')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.active) {
                                List data = snapshot.data['scraps'];
                                return data.length == 0
                                    ? Container(
                                        height: a.height / 12,
                                        child: Center(
                                          child: Text(
                                            'ไม่มี',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: a.width / 18),
                                          ),
                                        ))
                                    : Wrap(
                                        children: data
                                            .map((text) => scrap(
                                                a, data[data.indexOf(text)]))
                                            .toList());
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                      )
                    ],
                  ),
                ),
                StreamBuilder(
                    stream: Firestore.instance
                        .collection('User')
                        .document('scraps')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.active) {
                        return Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: a.width / 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "กระดาษที่เก็บไว้",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 18),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      snapshot.data['collects'].length
                                              .toString() ??
                                          '0' + " แผ่น",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 18),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                width: a.width,
                                height: a.width / 1,
                                child: ListView.builder(
                                  itemCount: snapshot.data['collects'].length,
                                  scrollDirection: Axis.horizontal,
                                  //  children: <Widget>[LongPaper(), LongPaper()],
                                  itemBuilder: (context, index) {
                                    String text = snapshot.data['collects'][
                                        snapshot.data['collects'].length -
                                            (++index)];
                                    return LongPaper(
                                      text: text,
                                    );
                                  },
                                ))
                          ],
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget scrap(Size a, String data) {
    return Container(
      padding: EdgeInsets.all(a.width / 32),
      child: InkWell(
        child: Image.asset(
          './assets/paper.png',
          width: a.width / 6.4,
          height: a.width / 6.4,
          fit: BoxFit.cover,
        ),
        onTap: () {
          dialog(data);
        },
      ),
    );
  }

//ส่วนของ กระดาษที่ถูกปาใส่ เมื่อกด
  dialog(String text) {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              backgroundColor: Colors.transparent,
              content:
                  StatefulBuilder(builder: (context, StateSetter setState) {
                Size a = MediaQuery.of(context).size;
                return Container(
                  width: a.width,
                  height: a.height / 1.76,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: a.width,
                        child: Image.asset(
                          'assets/paper-readed.png',
                          width: a.width,
                          height: a.height / 2.1,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('เขียนโดย : ใครสักคน'),
                                Text('เวลา : 9:00')
                              ],
                            ),
                          )),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: a.width / 1.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  width: a.width / 3.5,
                                  height: a.width / 6.5,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
                                  alignment: Alignment.center,
                                  child: Text("เก็บไว้",
                                      style: TextStyle(
                                          fontSize: a.width / 15,
                                          color: Color(0xff26A4FF))),
                                ),
                                onTap: () async {
                                  await Firestore.instance
                                      .collection('User')
                                      .document('scraps')
                                      .updateData({
                                    'collects': FieldValue.arrayUnion([text]),
                                    'scraps': FieldValue.arrayRemove([text]),
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              InkWell(
                                child: Container(
                                  width: a.width / 3.5,
                                  height: a.width / 6.5,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "ทิ้ง",
                                    style: TextStyle(fontSize: a.width / 15),
                                  ),
                                ),
                                onTap: () async {
                                  await Firestore.instance
                                      .collection('User')
                                      .document('scraps')
                                      .updateData({
                                    'scraps': FieldValue.arrayRemove([text])
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          left: a.width / 16,
                          top: a.height / 12,
                          child: Container(
                            alignment: Alignment.center,
                            height: a.height / 3.2,
                            width: a.width / 1.48,
                            child: Text(
                              text,
                              style: TextStyle(fontSize: a.width / 14),
                            ),
                          ))
                    ],
                  ),
                );
              }));
        });
  }
}
