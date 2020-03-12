import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:scrap/Page/setting/About.dart';
import 'package:scrap/Page/setting/FeedbackPage.dart';
import 'package:scrap/Page/profile/Dropdown/editProfile.dart';
import 'package:scrap/Page/setting/blockingList.dart';
import 'package:scrap/Page/setting/History.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
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
  bool loading = false;
  Scraps scraps = Scraps();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          StreamBuilder(
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
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            color: Colors.black,
                                            size: a.width / 15),
                                      ),
                                      onTap: () {
                                        Navigator.pop(
                                          context,
                                        );
                                      },
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (val) {
                                        choiceAction(val, info: snapshot.data);
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return Constans.choices
                                            .map((String choice) {
                                          return PopupMenuItem(
                                              value: choice,
                                              child: Text(
                                                choice,
                                                style: TextStyle(
                                                    fontSize: a.width / 15),
                                              ));
                                        }).toList();
                                      },
                                      child: Icon(Icons.more_horiz,
                                          color: Colors.white,
                                          size: a.width / 9),
                                    )
                                  ],
                                ),
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
                                      color: Colors.white,
                                      width: a.width / 150)),
                              width: a.width / 3,
                              height: a.width / 3,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(a.width),
                                  child: snapshot.data['img'] == null
                                      ? Image.asset("assets/userprofile.png")
                                      : CachedNetworkImage(
                                          imageUrl: snapshot.data['img'],
                                          fit: BoxFit.cover,
                                        )),
                            ),

                            // ชื่อของ account
                            Container(
                                margin: EdgeInsets.only(top: a.width / 15),
                                child: Text(
                                  "@" + widget.doc['id'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: a.width / 12),
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
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      softWrap: false,
                                      style: TextStyle(
                                          fontSize: a.width / 16.5,
                                          color:
                                              snapshot?.data['status'] == null
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
                                          color: Colors
                                              .white))), //ใส่เส้นด้านใต้สุด
                              child: Row(
                                // ใส��� Row ��พื่อเรียงแนวนอนของจำนวน ได้แก่ เขียน ผู้หยิบอ่าน ปาใส่
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                              : snapshot.data['written']
                                                  .toString(),
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
                                    width: a.width / 4,
                                    // color: Colors.blue,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          //เพื่อใช้สำหรับ��ห้ จำนวน และ ผ�����้หยิบอ่าน
                                          snapshot.data['read'] == null
                                              ? '0'
                                              : snapshot.data['read']
                                                  .toString(),
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
                                              : snapshot.data['threw']
                                                  .toString(),
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
                                            return snapshot?.data['id'] ==
                                                        null ||
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
                                                            fontSize:
                                                                a.width / 18),
                                                      ),
                                                    ))
                                                : Container(
                                                    child: wrapScrap(
                                                        a, mSet.toList()),
                                                  );
                                          } else {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
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
                                          margin: EdgeInsets.only(
                                              top: a.width / 20),
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
                                        mSet?.length == null ||
                                                mSet?.length == 0
                                            ? Center(
                                                child: Text(
                                                  'ไม่มี',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: a.width / 18),
                                                ),
                                              )
                                            : Container(
                                                width: a.width,
                                                height: a.width / 1,
                                                child:
                                                    listScrap(a, mSet.toList()))
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
          loading ? Loading() : SizedBox()
        ],
      ),
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
            .map(
              (scrap) => InkWell(
                child: LongPaper(
                  scrap: backward(mList, scrap),
                  uid: widget.doc['uid'],
                ),
              ),
            )
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
      String text, String writer, String time, Map scpData, String writerUID) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          Size a = MediaQuery.of(context).size;
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Scaffold(
              backgroundColor: Colors.black,
              resizeToAvoidBottomPadding: false,
              body: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.black,
                    // margin: EdgeInsets.only(
                    //   top: a.height / 8,
                    // ),
                    padding: EdgeInsets.only(
                        left: a.width / 20, right: a.width / 20),
                    width: a.width,
                    height: a.height,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                                  border: Border.all(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          a.width / 10)),
                                              alignment: Alignment.center,
                                              child: Text("ปากลับ"),
                                            ),
                                            onTap: () {
                                              dialogPa(writerUID, writer);
                                            },
                                          )
                                        ],
                                      ),
                                    )),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 25, right: 25),
                                  height: a.height / 1.6,
                                  width: a.width,
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
                              ],
                            ),
                            SizedBox(height: a.width / 15),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(a.width)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(right: a.width / 40),
                                      width: a.width / 6,
                                      height: a.width / 6,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.block,
                                              color: Colors.grey[600],
                                              size: a.width / 14,
                                            ),
                                            Text(
                                              "บล็อค",
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: a.width / 25),
                                            )
                                          ]),
                                    ),
                                    onTap: () {
                                      blockDialog(widget.doc['uid'], writerUID,
                                          scpData);
                                    },
                                  ),
                                  InkWell(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(right: a.width / 40),
                                      width: a.width / 6,
                                      height: a.width / 6,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            // Icon(
                                            //   Icons.delete_outline,
                                            //   color: Colors.grey[600],
                                            //   size: a.width / 15,
                                            // ),
                                            Image.asset(
                                                'assets/garbage_grey.png',
                                                width: a.width / 14,
                                                height: a.width / 14,
                                                fit: BoxFit.cover),
                                            Text(
                                              "ทิ้ง",
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: a.width / 25),
                                            )
                                          ]),
                                    ),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      await ignore(writerUID, scpData);
                                    },
                                  ),
                                  InkWell(
                                    child: Container(
                                      width: a.width / 6,
                                      height: a.width / 6,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.save_alt,
                                              color: Colors.grey[600],
                                              size: a.width / 14,
                                            ),
                                            Text(
                                              "เก็บไว้",
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: a.width / 25),
                                            )
                                          ]),
                                    ),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      await Firestore.instance
                                          .collection('Users')
                                          .document(widget.doc['uid'])
                                          .collection('scraps')
                                          .document('collection')
                                          .setData({
                                        'id':
                                            FieldValue.arrayUnion([writerUID]),
                                        'scraps': {
                                          writerUID:
                                              FieldValue.arrayUnion([scpData])
                                        }
                                      }, merge: true);
                                      await ignore(writerUID, scpData);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Center(
                  //   child: InkWell(
                  //     child: Container(
                  //       width: a.width / 7,
                  //       height: a.width / 12,
                  //       decoration: BoxDecoration(
                  //           border: Border.all(color: Colors.red[200]),
                  //           borderRadius: BorderRadius.circular(a.width / 10)),
                  //       alignment: Alignment.center,
                  //       child: Text("บล็อค"),
                  //     ),
                  //     onTap: () {
                  //       blockDialog(widget.doc['uid'], writerID, scpData);
                  //       //dialogPa(writerID, writer);
                  //     },
                  //   ),
                  // )
                ],
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
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 5),
                              Text(
                                "แก้ไขสเตตัส",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: a.width / 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
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
                            maxLines: null,
                            maxLength: 60,
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
                            //เนื้อหา���ี่กร���กเข้าไปใน text
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
                            maxLength: 250,
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
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "ปาเลย",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: a.width / 15),
                                  )),
                            ),
                            onTap: () async {
                              if (_key.currentState.validate()) {
                                if (await scraps.blocked(
                                    widget.doc['uid'], id)) {
                                  toast('คุณไม่สามารถปาไปหา"$thrown"ได้');
                                } else {
                                  toast(thrown == 'ไม่ระบุตัวตน'
                                      ? 'ปากลับแล้ว'
                                      : 'ปากลับใส่"$thrown"แล้ว');
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  scraps.throwTo(
                                      uid: widget.doc['uid'],
                                      writer: widget.doc['id'],
                                      thrownUID: id,
                                      text: text2,
                                      public: true);
                                }
                              }
                            })
                      ],
                    ),
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

  blockDialog(String userReceive, String userSent, Map scpData) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              child: Text(
                  'คุณต้องการบล็อคผู้ใช้นี้ใช่หรือไม่ (สามารถแก้ไขได้ภายหลัง)'),
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
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await blockCheck(userReceive, userSent, scpData);
                },
              )
            ],
          );
        });
  }

  blockCheck(String userReceive, String userSent, Map scpData) async {
    List blockList = [];
    await Firestore.instance
        .collection("Users")
        .document(userReceive)
        .collection("info")
        .document("blockList")
        .get()
        .then((value) {
      blockList = value?.data['blockList'] ?? [];
    });
    bool check = blockList.where((data) => data['uid'] == userSent).length > 0;
    if (check) {
      toast('คุณบล็อคอยู่แล้ว');
    } else {
      blockFunction(userReceive, userSent, scpData);
      ignore(userSent, scpData);
      toast('ทำการบล็อคแล้ว');
    }
  }

  blockFunction(String userReceive, String userSent, Map scpData) async {
    Map blocked = {
      'uid': userSent,
      'id': scpData['writer'],
      'text': scpData['text'],
      'time': scpData['time']
    };
    await Firestore.instance
        .collection("Users")
        .document(userReceive)
        .collection('info')
        .document('blockList')
        .setData({
      'blockList': FieldValue.arrayUnion([blocked])
    }, merge: true);
  }

  statusEditer(String status) async {
    await Firestore.instance
        .collection('Users')
        .document(widget.doc['uid'])
        .collection('info')
        .document(widget.doc['uid'])
        .updateData({'status': status});
  }

  ignore(String writerID, Map scpData) async {
    Firestore.instance
        .collection('Users')
        .document(widget.doc['uid'])
        .collection('scraps')
        .document('recently')
        .get()
        .then((value) async {
      if (value.data['scraps'][writerID].length == 1) {
        Firestore.instance
            .collection('Users')
            .document(widget.doc['uid'])
            .collection('scraps')
            .document('recently')
            .setData({
          'scraps': {writerID: FieldValue.delete()}
        }, merge: true);
        Firestore.instance
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FeedbackPage()));
        break;
      case Constans.Block:
        Firestore.instance
            .collection('Users')
            .document(widget.doc['uid'])
            .collection('info')
            .document('blockList')
            .get()
            .then((value) {
          value.exists
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BlockingList(uid: widget.doc['uid'])))
              : value.reference.setData({}).then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BlockingList(uid: widget.doc['uid']))));
        });
        break;
      case Constans.About:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => About()));
        break;
      case Constans.SignOut:
        Auth auth = Provider.of(context).auth;
        await auth.signOut().then((value) {
          Navigator.pop(context);
        });
        break;
      case Constans.History:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => History(
                      uid: widget.doc['uid'],
                    )));
        break;
      default:
        break;
    }
  }
}

class Constans {
  static const String Account = 'แก้ไขบัญชี';
  static const String Feedback = 'ให้คำแนะนำ';
  static const String History = 'ประวัติการทิ้ง';
  static const String Block = 'การบล็อค';
  static const String About = 'เกี่ยวกับแอป';
  static const String SignOut = 'ออกจากระบบ';

  static const List<String> choices = <String>[
    Account,
    Feedback,
    History,
    Block,
    About,
    SignOut,
  ];
}
