import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scrap/Page/setting/About.dart';
import 'package:scrap/Page/setting/FeedbackPage.dart';
import 'package:scrap/Page/profile/Dropdown/editProfile.dart';
import 'package:scrap/services/auth.dart';
import 'package:scrap/services/provider.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/LongPaper.dart';
import 'package:scrap/widget/Toast.dart';

class Profile extends StatefulWidget {
  final DocumentSnapshot doc;
  Profile({@required this.doc});
  @override
  _ProfileState createState() => _ProfileState();
}

//หน้า Account
class _ProfileState extends State<Profile> {
  int page;
  String text2;
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('Users')
              .document(widget.doc['uid'])
              .collection('info')
              .document(widget.doc['uid'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.active) {
              return ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: a.width / 20,
                        right: a.width / 25,
                        left: a.width / 25,
                        bottom: a.width / 8.0),
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
                                      borderRadius:
                                          BorderRadius.circular(a.width),
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
                              PopupMenuButton<String>(
                                //setting menu
                                onSelected: (val) {
                                  choiceAction(val, info: snapshot.data);
                                },
                                itemBuilder: (BuildContext context) {
                                  return Constans.choices.map((String choice) {
                                    return PopupMenuItem(
                                        value: choice,
                                        child: Text(
                                          choice,
                                          style:
                                              TextStyle(fontSize: a.width / 15),
                                        ));
                                  }).toList();
                                },
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(a.width),
                            child: snapshot.data['img'] == null
                                ? Image.asset("assets/userprofile.png")
                                : Image.network(
                                    snapshot.data['img'],
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        // ชื่อของ account
                        Container(
                            margin: EdgeInsets.only(top: a.width / 15),
                            child: Text(
                              "@" + widget.doc['id'],
                              style: TextStyle(
                                  color: Colors.white, fontSize: a.width / 12),
                            )),
                        // เบอร์โทรของ Account
                        Container(
                            margin: EdgeInsets.only(top: a.width / 1000),
                            child: Text(
                              "Join " + snapshot.data['createdDay'],
                              style: TextStyle(
                                  fontSize: a.width / 11,
                                  color: Color(0xff26A4FF)),
                            )),
                        InkWell(
                          child: Container(
                              margin: EdgeInsets.only(top: a.width / 14),
                              child: SizedBox(
                                width: a.width / 1.6,
                                child: Text(
                                  snapshot?.data['status'] ??
                                      'แตะเพื่อเพิ่มสเตตัส',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: a.width / 15,
                                      color: snapshot?.data['status'] == null
                                          ? Colors.grey
                                          : Colors.white,
                                      fontStyle:
                                          snapshot?.data['status'] == null
                                              ? null
                                              : FontStyle.italic),
                                ),
                              )),
                          onTap: () {
                            editStatus(snapshot?.data['status'], "thrown");
                          },
                        ),
                        // ใส่ Container เพื่อสร้างกรอบ
                        Container(
                          margin: EdgeInsets.only(top: a.width / 30),
                          padding: EdgeInsets.only(top: a.width / 10),
                          height: a.width / 2.5,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: a.width / 1500,
                                      color:
                                          Colors.white))), //ใส่เส้นด้านใต้สุด
                          child: Row(
                            // ใส��� Row ��พื่อเรียงแนวนอนของจำนวน ได้แก่ เขียน ผู้หยิบอ่าน ปาใส่
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                //color: Colors.black,
                                width: a.width / 4.5,
                                child: Column(
                                  //เพื่อใช้สำหรับให้ จำนวน และ เขียน
                                  children: <Widget>[
                                    Text(
                                      snapshot.data['written'] == null
                                          ? '0'
                                          : snapshot.data['written'].toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "เขียน",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 18),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: a.width / 4.5,
                                // color: Colors.blue,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      //เพื่อใช้สำหรับ��ห้ จำนวน และ ผ�����้หยิบอ่าน
                                      snapshot.data['read'] == null
                                          ? '0'
                                          : snapshot.data['read'].toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "ผู้คนหยิบอ่าน",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 18),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: a.width / 4.5,
                                //  color: Colors.blue,
                                child: Column(
                                  //เพื่อใช้สำหรับให้ จำนวน ��ละ โ��นปาใส��
                                  children: <Widget>[
                                    Text(
                                      snapshot.data['threw'] == null
                                          ? '0'
                                          : snapshot.data['threw'].toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "โดนปาใส่",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: a.width / 18),
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
                            width: a.width / 1500,
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
                                margin: EdgeInsets.only(bottom: 25.0),
                                width: a.width,
                                child: StreamBuilder(
                                    stream: Firestore.instance
                                        .collection('Users')
                                        .document(widget.doc['uid'])
                                        .collection('scraps')
                                        .document('recently')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.connectionState ==
                                              ConnectionState.active) {
                                        Set mSet = {};
                                        modiList(
                                            snapshot?.data['id'],
                                            snapshot?.data['scraps'],
                                            mSet,
                                            'recently');
                                        return snapshot?.data['id'] == null ||
                                                mSet.length == 0
                                            ? Container(
                                                height: a.height / 12,
                                                child: Center(
                                                  child: Text(
                                                    'ไม่มี',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: a.width / 18),
                                                  ),
                                                ))
                                            : Container(
                                                child:
                                                    wrapScrap(a, mSet.toList()),
                                              );
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
                                .collection('Users')
                                .document(widget.doc['uid'])
                                .collection('scraps')
                                .document('collection')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.active) {
                                Set mSet = {};
                                modiList(
                                    snapshot?.data['id'],
                                    snapshot?.data['scraps'],
                                    mSet,
                                    'collection');
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: a.width / 20),
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
                                              mSet?.length == null ||
                                                      mSet?.length == 0
                                                  ? '0' + " แผ่น"
                                                  : mSet.length.toString() +
                                                      ' แผ่น',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: a.width / 18),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    mSet?.length == null || mSet?.length == 0
                                        ? Center(
                                            child: Text(
                                              'ไม่มี',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: a.width / 18),
                                            ),
                                          )
                                        : Container(
                                            width: a.width,
                                            height: a.width / 1,
                                            child: listScrap(a, mSet.toList()))
                                  ],
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),

                        Container(
                          margin: EdgeInsets.only(top: 100),
                          child: InkWell(
                            child: Container(
                                width: a.width / 2,
                                height: a.width / 6,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(a.width),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: a.width / 400,
                                    )),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.feedback,
                                        color: Colors.white,
                                        size: a.width / 15),
                                    SizedBox(width: 5),
                                    Text(
                                      'Feedback',
                                      style: TextStyle(
                                        fontSize: a.width / 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FeedbackPage())); //ไปยังหน้า Profile
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Loading());
            }
          }),
    );
  }

  modiList(List users, Map data, Set mSet, String key) {
    if (users != null || data != null) {
      for (var id in users) {
        if (data[id] == null || data[id].length == 0) {
          clearScrap(data[id] == null, id, key);
        } else {
          for (var scraps in data[id]) {
            mSet.add({'scap': scraps, 'id': id});
          }
        }
      }
    }
  }

  clearScrap(bool onlyID, String id, String key) {
    Firestore.instance
        .collection('Users')
        .document(widget.doc['uid'])
        .collection('scraps')
        .document(key)
        .updateData({
      'id': FieldValue.arrayRemove([id])
    }).then((value) {
      onlyID
          ? null
          : Firestore.instance
              .collection('Users')
              .document(widget.doc['uid'])
              .collection('scraps')
              .document(key)
              .setData({
              'scraps': {id: FieldValue.delete()}
            }, merge: true);
    });
  }

  Widget listScrap(Size a, List mList) {
    return Container(
      width: a.width,
      height: a.width,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: mList
            .map((scrap) => LongPaper(
                  scrap: backward(mList, scrap),
                  uid: widget.doc['uid'],
                ))
            .toList(),
      ),
    );
  }

//data[data.length - 1 -data.indexOf(userID)]
  Widget wrapScrap(Size a, List scraps) {
    return Wrap(
      children: scraps
          .map((scrapData) => scrap(a, backward(scraps, scrapData)))
          .toList(),
    );
  }

  dynamic backward(List list, dynamic value) {
    return list[list.length - 1 - list.indexOf(value)];
  }

  Widget delete(String id) {
    Firestore.instance
        .collection('Users')
        .document(widget.doc['uid'])
        .collection('scraps')
        .document('recently')
        .updateData({
      'id': FieldValue.arrayRemove([id])
    });
    return SizedBox();
  }

  Widget scrap(Size a, Map scrap) {
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
          dialog(scrap['scap']['text'], scrap['scap']['writer'],
              scrap['scap']['time'], scrap['scap'], scrap['id']);
        },
      ),
    );
  }

//ส่วนของ กระดาษที่ถูกปาใ��่ เม���่อกด
  dialog(
      String text, String writer, String time, Map scpData, String writerID) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          Size a = MediaQuery.of(context).size;
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Container(
                color: Colors.black,
                margin: EdgeInsets.only(
                  top: a.height / 8,
                ),
                padding:
                    EdgeInsets.only(left: a.width / 20, right: a.width / 20),
                width: a.width,
                height: a.height / 1.3,
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: a.width,
                          child: Image.asset(
                            'assets/paper-readed.png',
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
                                      width: a.width / 7,
                                      height: a.width / 12,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius: BorderRadius.circular(
                                              a.width / 10)),
                                      alignment: Alignment.center,
                                      child: Text("ปากลับ"),
                                    ),
                                    onTap: () {
                                      dialogPa(writerID, writer);
                                    },
                                  ),
                                  InkWell(
                                    child: Container(
                                      width: a.width / 7,
                                      height: a.width / 12,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.red[200]),
                                          borderRadius: BorderRadius.circular(
                                              a.width / 10)),
                                      alignment: Alignment.center,
                                      child: Text("บล็อค"),
                                    ),
                                    onTap: () {
                                      blockDialog(widget.doc['id'], writerID, writer, time, text, scpData);
                                      

                                      //dialogPa(writerID, writer);
                                    },
                                  )
                            
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
                        )
                      ],
                    ),
                    SizedBox(height: a.width / 15),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(width: a.width / 20),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: a.width / 55, right: a.width / 55),
                              width: a.width / 3.5,
                              height: a.width / 6.5,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(a.width)),
                              alignment: Alignment.center,
                              child: Text("เก็บไว้",
                                  style: TextStyle(
                                      fontSize: a.width / 15,
                                      color: Color(0xff26A4FF))),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              await Firestore.instance
                                  .collection('Users')
                                  .document(widget.doc['uid'])
                                  .collection('scraps')
                                  .document('collection')
                                  .setData({
                                'id': FieldValue.arrayUnion([writerID]),
                                'scraps': {
                                  writerID: FieldValue.arrayUnion([scpData])
                                }
                              }, merge: true);
                              await ignore(writerID, scpData);
                            },
                          ),
                          InkWell(
                            child: Container(
                              width: a.width / 3.5,
                              height: a.width / 6.5,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(a.width)),
                              alignment: Alignment.center,
                              child: Text(
                                "ทิ้ง",
                                style: TextStyle(fontSize: a.width / 15),
                              ),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              await ignore(writerID, scpData);
                            },
                          ),
                          SizedBox(width: a.width / 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
        fullscreenDialog: true));
  }

  editStatus(String status, String thrown) {
    String edit;
    var tx = TextEditingController();
    tx.text = status;
    var _key = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Size a = MediaQuery.of(context).size;
          return Dialog(
            child: Container(
              height: a.width / 1.6,
              padding: EdgeInsets.only(
                  left: a.width / 100,
                  right: a.width / 100,
                  top: a.width / 100),
              child: Stack(
                children: <Widget>[
                  Form(
                    key: _key,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: a.width / 1.32,
                          height: a.width / 8,
                          padding: EdgeInsets.only(top: 6),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[300]))),
                          child: Text(
                            "แก้ไขสเตตัส",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: a.width / 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              right: a.width / 40, left: a.width / 40),
                          height: a.width / 3.4,
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: a.width / 17,
                            ),
                            controller: tx,
                            decoration: InputDecoration(
                              border: InputBorder.none, //สำหรับใหเส้นใต้หาย
                              hintText: 'เขียนข้อความของคุณ',
                              hintStyle: TextStyle(
                                fontSize: a.width / 17,
                                color: Colors.grey,
                              ),
                            ),
                            validator: (val) {
                              return val.trim() == null || val.trim() == ""
                                  ? toast('เขียนบางอย่างสิ')
                                  : null;
                            },
                            //เนื้อหาที่กรอกเข้าไปใน text
                            onSaved: (val) {
                              edit = val;
                            },
                          ),
                        ),
                        InkWell(
                          child: Container(
                            width: a.width,
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(
                                top: a.width / 15, right: a.width / 33),
                            child: Container(
                                width: a.width / 5.5,
                                height: a.width / 11,
                                decoration: BoxDecoration(
                                    color: Color(0xff26A4FF),
                                    borderRadius:
                                        BorderRadius.circular(a.width)),
                                alignment: Alignment.center,
                                child: Text(
                                  "แก้ไข",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: a.width / 15),
                                )),
                          ),
                          onTap: () {
                            if (_key.currentState.validate()) {
                              _key.currentState.save();
                              Navigator.pop(context);
                              statusEditer(edit);
                              toast('แก้ไขสเตตัสเรียนร้อย');
                            }
                            // throwTo(id, text2);
                          },
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: InkWell(
                      child: Container(
                          width: a.width / 12,
                          height: a.width / 12,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(a.width)),
                          child: Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: a.width / 21,
                          )),
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
  }

  dialogPa(String id, String thrown) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Size a = MediaQuery.of(context).size;
          return Dialog(
            child: Container(
              height: a.width / 1.6,
              padding: EdgeInsets.only(
                  left: a.width / 100,
                  right: a.width / 100,
                  top: a.width / 100),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: a.width / 8,
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
                                  "ปาใส่กลับโดย : ",
                                  style: TextStyle(
                                      fontSize: a.width / 20,
                                      color: Colors.black),
                                ),
                                Text(
                                  "@" + widget.doc['id'],
                                  style: TextStyle(
                                      color: Color(0xff26A4FF),
                                      fontSize: a.width / 20),
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
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none, //สำหรับใหเส้นใต้หาย
                            hintText: 'เขียนข้อความบางอย่าง',
                            hintStyle: TextStyle(
                              fontSize: a.width / 25,
                              color: Colors.grey,
                            ),
                          ),
                          validator: (val) {
                            return val.trim() == null || val.trim() == ""
                                ? Taoast().toast("ลองเขียนข้อความบางอย่างสิ")
                                : null;
                          },
                          //เนื้อหาที่กรอกเข้าไปใน text
                          onChanged: (val) {
                            text2 = val;
                          },
                        ),
                      ),
                      InkWell(
                        child: Container(
                          width: a.width,
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(
                              top: a.width / 15, right: a.width / 33),
                          child: Container(
                              width: a.width / 5.5,
                              height: a.width / 11,
                              decoration: BoxDecoration(
                                  color: Color(0xff26A4FF),
                                  borderRadius: BorderRadius.circular(a.width)),
                              alignment: Alignment.center,
                              child: Text(
                                "ปาเลย",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: a.width / 15),
                              )),
                        ),
                        onTap: () {
                          toast(thrown == 'ไม่ระบุตัวตน'
                              ? 'ปากลับแล้ว'
                              : 'ปากลับใส่"$thrown"แล้ว');
                          Navigator.pop(context);
                          Navigator.pop(context);
                          throwTo(id, text2);
                        },
                      )
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
  }
  blockDialog(String userReceive, String userSent, String writer, String time, String text, Map scpData){
    return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              child: Text('คุณต้องการบล็อคผู้ใช้นี้ใช่หรือไม่ (สามารถแก้ไขได้ภายหลัง)'),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ยกเลิก')),
              FlatButton(
                child: Text('ตกลง'),
                onPressed: () async {
                  toast('ทำการบล็อคแล้ว');
                  Navigator.pop(context);
                  Navigator.pop(context);
                  //await throwTo(widget.data, thrownID);
                  await blockFunction(userReceive, userSent, writer, time, text, scpData);
                },
              )
            ],
          );
  }

  blockFunction(String userReceive,String userSent, String writer, String time, String text, Map scpData) async {
    blockAddUser(userReceive, userSent);
    blockAddPaper(userReceive, writer, time, text, scpData);
  }

  blockAddUser(String userReceive,String userSent) async {
    await Firestore.instance
    .collection("Users")
    .document(userReceive)
    .updateData({'blockList': FieldValue.arrayUnion([userSent]) })
    ;
  }

  blockAddPaper(String userReceive,String writer, String time, String text, Map scpData) async {
    List paperData = [writer,time,text,scpData];
    await Firestore.instance
    .collection("Users")
    .document(userReceive)
    .updateData({'blockPaperList' : FieldValue.arrayUnion([paperData])})
    ;
  }

  statusEditer(String status) async {
    await Firestore.instance
        .collection('Users')
        .document(widget.doc['uid'])
        .collection('info')
        .document(widget.doc['uid'])
        .updateData({'status': status});
  }

  throwTo(String thrownID, String text) async {
    DateTime now = DateTime.now();
    String time = DateFormat('Hm').format(now);
    String date = DateFormat('d/M/y').format(now);
    await Firestore.instance
        .collection('Users')
        .document(thrownID)
        .collection('scraps')
        .document('recently')
        .setData({
      'id': FieldValue.arrayUnion([widget.doc['uid']]),
      'scraps': {
        widget.doc['uid']: FieldValue.arrayUnion([
          {'text': text, 'writer': widget.doc['id'], 'time': '$time $date'}
        ])
      }
    }, merge: true);
    await notifaication(thrownID, date, time);
    await updateHistory(widget.doc['uid'], thrownID);
    await increaseTransaction(widget.doc['uid'], 'written');
    await increaseTransaction(thrownID, 'threw');
  }

  updateHistory(String uid, String thrown) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document('searchHist')
        .updateData({
      'history': FieldValue.arrayUnion([thrown])
    });
  }

  notifaication(String who, String date, String time) async {
    await Firestore.instance.collection('Notifications').add({'uid': who});
    await Firestore.instance
        .collection('Users')
        .document(who)
        .collection('notification')
        .add({'writer': widget.doc, 'date': date, 'time': time});
  }

  increaseTransaction(String uid, String key) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document(uid)
        .get()
        .then((value) => Firestore.instance
            .collection('Users')
            .document(uid)
            .collection('info')
            .document(uid)
            .updateData(
                {key: value?.data[key] == null ? 1 : ++value.data[key]}));
  }

  ignore(String writerID, Map scpData) async {
    await Firestore.instance
        .collection('Users')
        .document(widget.doc['uid'])
        .collection('scraps')
        .document('recently')
        .get()
        .then((value) async {
      if (value.data['scraps'][writerID].length == 1) {
        await Firestore.instance
            .collection('Users')
            .document(widget.doc['uid'])
            .collection('scraps')
            .document('recently')
            .setData({
          'scraps': {writerID: FieldValue.delete()}
        }, merge: true);
        await Firestore.instance
            .collection('Users')
            .document(widget.doc['uid'])
            .collection('scraps')
            .document('recently')
            .updateData({
          'id': FieldValue.arrayRemove([writerID])
        });
      } else {
        Firestore.instance
            .collection('Users')
            .document(widget.doc['uid'])
            .collection('scraps')
            .document('recently')
            .setData({
          'scraps': {
            writerID: FieldValue.arrayRemove([scpData])
          }
        }, merge: true);
      }
    });
  }

  toast(String text) {
    return Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.white60,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  void choiceAction(String choice, {DocumentSnapshot info}) async {
    switch (choice) {
      case Constans.Account:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditProfile(
                      doc: widget.doc,
                      info: info,
                    )));
        break;
      case Constans.Feedback:
        print('Feedback');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FeedbackPage()));
        break;
      case Constans.About:
        print('About');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => About()));
        break;
      case Constans.SignOut:
        Auth auth = Provider.of(context).auth;
        await auth.signOut().then((value) {
          Navigator.pop(context);
        });
        break;
      default:
        print('About');
        break;
    }
  }
}

class Constans {
  static const String Account = 'แก้ไขบัญชี';
  static const String Feedback = 'ให้คำแนะนำ';
  static const String About = 'เกี่ยวกับแอป';
  static const String SignOut = 'ออกจากระบบ';

  static const List<String> choices = <String>[
    Account,
    Feedback,
    About,
    SignOut,
  ];
}
