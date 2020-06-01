import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrap/widget/Toast.dart';

class BlockingList extends StatefulWidget {
  final String uid;
  BlockingList({@required this.uid});
  @override
  _BlockingListState createState() => _BlockingListState();
}

class _BlockingListState extends State<BlockingList> {
  @override
  Widget build(BuildContext context) {
    Size scr = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar:
            // AppBar(
            //   backgroundColor: Colors.black,
            //   title: Text(
            //     'การบล็อค',
            //     style: TextStyle(color: Colors.white, fontSize: scr.width / 14),
            //   ),
            // ),
            PreferredSize(
          preferredSize: Size(double.infinity, scr.width / 4),
          child: Container(
            margin: MediaQuery.of(context).padding,
            width: scr.width,
            color: Colors.black,
            padding: EdgeInsets.only(
                top: scr.width / 18,
                right: scr.width / 25,
                left: scr.width / 25,
                bottom: scr.width / 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  child: Container(
                    width: scr.width / 7,
                    height: scr.width / 10,
                    margin: EdgeInsets.only(right: scr.width / 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(scr.width),
                        color: Colors.white),
                    child: Icon(Icons.arrow_back,
                        color: Colors.black, size: scr.width / 15),
                  ),
                  onTap: () {
                    Navigator.pop(
                      context,
                    );
                  },
                ),
                Text('การบล็อค',
                    style: TextStyle(
                      fontSize: scr.width / 14,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        body: Center(
            child: nullReturn(scr, 'ไม่มีผู้ใช้ที่คุณบล็อค', scr.height / 2))
        // StreamBuilder(
        //     stream: Firestore.instance
        //         .collection('Users')
        //         .document(widget.uid)
        //         .collection('info')
        //         .document('blockList')
        //         .snapshots(),
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData &&
        //           snapshot.connectionState == ConnectionState.active) {
        //         List blockList = snapshot?.data['blockList'] ?? [];
        //         return blockList?.length == null || blockList?.length == 0
        //             ? Center(
        //                 child: nullReturn(
        //                     scr, 'ไม่มีผู้ใช้ที่คุณบล็อค', scr.height / 2))
        //             : dataReturn(blockList.reversed.toList(), scr);
        //       } else
        //         return Container(
        //           height: scr.height,
        //           width: scr.width,
        //           child: Center(
        //             child: Container(
        //               width: scr.width / 3.6,
        //               height: scr.width / 3.6,
        //               decoration: BoxDecoration(
        //                   color: Colors.white.withOpacity(0.42),
        //                   borderRadius: BorderRadius.circular(12)),
        //               child: FlareActor(
        //                 'assets/paper_loading.flr',
        //                 animation: 'Untitled',
        //                 fit: BoxFit.cover,
        //               ),
        //             ),
        //           ),
        //         );
        //     })
        );
  }

  Widget nullReturn(Size a, String text, double heigth) {
    return Container(
      height: heigth,
      width: a.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/paper.png',
            color: Colors.white60,
            height: a.height / 10,
          ),
          Text(
            text,
            style: TextStyle(
                fontSize: a.width / 16,
                color: Colors.white60,
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  Widget dataReturn(List blockList, Size scr) {
    return Container(
        padding: EdgeInsets.all(scr.width / 42),
        width: scr.width,
        height: scr.height,
        child: GridView.builder(
            itemCount: blockList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7383,
                crossAxisSpacing: 3.6,
                mainAxisSpacing: 3.6),
            itemBuilder: (context, index) {
              return blockScrap(blockList[index], scr);
            }));
  }

  Widget blockScrap(Map data, Size scr) {
    return Container(
      child: Center(
        child: InkWell(
          child: Stack(
            children: <Widget>[
              Image.asset(
                'assets/paperscrap.jpg',
                width: scr.width / 2.1,
                height: scr.height,
                fit: BoxFit.cover,
              ),
              Container(
                width: scr.width / 2.1,
                height: scr.height,
                alignment: Alignment.center,
                child: SizedBox(
                    height: scr.height / 6,
                    child: Center(
                        child: Text(
                      data['text'],
                      style: TextStyle(fontSize: scr.width / 22),
                      textAlign: TextAlign.center,
                    ))),
              ),
              Container(
                  margin: EdgeInsets.only(left: 3.6, top: 3.6),
                  padding: EdgeInsets.all(2.8),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1.6,
                          spreadRadius: 0.1,
                          offset: Offset(
                            0.0,
                            1.0,
                          ),
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    data['time'],
                    style: TextStyle(
                        fontSize: scr.width / 24,
                        color: Color(0xff26A4FF),
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
          onTap: () {
            dialog(data['text'], data['id'], data['time'], data['uid']);
          },
        ),
      ),
    );
  }

  dialog(String text, String writer, String time, String uid) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          Size a = MediaQuery.of(context).size;
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.black,
                    margin: EdgeInsets.only(
                      top: a.height / 8,
                    ),
                    padding: EdgeInsets.only(
                        left: a.width / 20, right: a.width / 20),
                    width: a.width,
                    height: a.height,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
                                  width: a.width,
                                  child: Image.asset(
                                    'assets/paperscrap.jpg',
                                    width: a.width,
                                    height: a.height / 1.6,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                    top: 12,
                                    left: 12,
                                    child: Container(
                                      width: a.width / 1.2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('เขียนโดย : $writer'),
                                              Text('เวลา : $time')
                                            ],
                                          ),
                                          InkWell(
                                            child: Container(
                                                width: a.width / 12,
                                                height: a.width / 12,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Color(0xff26A4FF)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            a.width)),
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.flag,
                                                  color: Color(0xff26A4FF),
                                                  size: a.width / 16,
                                                )),
                                            onTap: () {
                                              reportDialog(
                                                  a, writer, uid, text);
                                            },
                                          ),
                                        ],
                                      ),
                                    )),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 25, right: 25),
                                  height: a.height / 1.6,
                                  // width: a.width / 1.2,
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      fontSize: a.width / 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  // onTap: () {
                                  //   dialogPa(writerID, writer);
                                  // },
                                ),
                                Positioned(
                                    bottom: a.width / 21,
                                    right: a.width / 21,
                                    child: InkWell(
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                            a.width / 42,
                                            a.width / 56,
                                            a.width / 42,
                                            a.width / 56),
                                        decoration: BoxDecoration(
                                            color: Color(0xff26A4FF),
                                            borderRadius:
                                                BorderRadius.circular(a.width)),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.lock_open,
                                                color: Colors.white,
                                                size: a.width / 21),
                                            Text(' ปลดบล็อค',
                                                style: TextStyle(
                                                    fontSize: a.width / 21,
                                                    color: Colors.white))
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        warnDialog({
                                          'id': writer,
                                          'text': text,
                                          'time': time,
                                          'uid': uid
                                        });
                                      },
                                    ))
                              ],
                            ),
                            SizedBox(height: a.width / 15),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(width: a.width / 20),
                                  InkWell(
                                    child: Container(
                                      width: a.width / 6.5,
                                      height: a.width / 6.5,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[800],
                                          borderRadius:
                                              BorderRadius.circular(a.width)),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: a.width / 15,
                                      ),
                                      // Text(
                                      //   "ปิด",
                                      //   style:
                                      //       TextStyle(fontSize: a.width / 15),
                                      // ),
                                    ),
                                    onTap: () async {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  SizedBox(width: a.width / 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        },
        fullscreenDialog: true));
  }

  reportDialog(Size a, String id, String reportedUID, String text) {
    String describe;
    showDialog(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
              child: Container(
                height: a.height / 2.8,
                padding: EdgeInsets.all(a.width / 56),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: a.width / 8.1,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[300]))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 5),
                                  Text(
                                    "รายงาน : ",
                                    style: TextStyle(
                                        fontSize: a.width / 20,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "@$id",
                                    style: TextStyle(
                                        color: Color(0xff26A4FF),
                                        fontSize: a.width / 18),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              right: a.width / 40, left: a.width / 40),
                          height: a.width / 3.4,
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none, //สำหรับใหเส้���ใต้หาย
                              hintText:
                                  'เขียนข้อความให้เราทราบพฤติกรรมของผู้ใช้รายนี้..',
                              hintStyle: TextStyle(
                                fontSize: a.width / 21,
                                color: Colors.grey,
                              ),
                            ),
                            validator: (val) {
                              return val.trim() == null || val.trim() == ""
                                  ? Taoast().toast("เขียนข้อความด้วยอย่างสิ")
                                  : null;
                            },
                            //เนื้อหาที่กรอกเข้าไปใน text
                            onChanged: (val) {
                              describe = val;
                            },
                          ),
                        ),
                        Container(
                          width: a.width,
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(
                              top: a.width / 15, right: a.width / 33),
                          child: InkWell(
                              child: Container(
                                  width: a.width / 5.5,
                                  height: a.width / 11,
                                  decoration: BoxDecoration(
                                      color: Color(0xff26A4FF),
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "ราบงาน",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: a.width / 15),
                                  )),
                              onTap: () async {
                                report(reportedUID, widget.uid, text, describe);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Taoast().toast('รายงานเรียบร้อยแล้ว');
                              }),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 2,
                      top: 2,
                      child: InkWell(
                        child: Container(
                            width: a.width / 15,
                            height: a.width / 15,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(a.width)),
                            child: Icon(Icons.clear, color: Colors.white)),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  report(String reportedUID, String reporterUID, String text,
      String describe) async {
    DateTime now = DateTime.now();
    String date = DateFormat('y-M-d').format(now);
    Firestore.instance
        .collection('Report')
        .document('reportUser')
        .collection(date)
        .add({
      'reported': reportedUID,
      'reporter': reporterUID,
      'text': text,
      'describe': describe,
      'timeStamp': FieldValue.serverTimestamp()
    });
  }

  warnDialog(Map map) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              child: Text('คุณต้องการปลดบล็อคใช่หรือไม่'),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ยกเลิก')),
              FlatButton(
                child: Text('ปลดบล็อค'),
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  unBlock(map);
                  Taoast().toast('ปลดบล็อคแล้ว');
                },
              )
            ],
          );
        });
  }

  unBlock(Map user) {
    Firestore.instance
        .collection('Users')
        .document(widget.uid)
        .collection('info')
        .document('blockList')
        .updateData({
      'blockList': FieldValue.arrayRemove([user])
    });
  }
}
