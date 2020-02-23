import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final Map data;
  Profile({@required this.doc, @required this.data});
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
                                      width: a.width / 1500,
                                      color:
                                          Colors.white))), //ใส่เส้นด้านใต้สุด
                          child: Row(
                            // ใส่ Row เพื่อเรียงแนวนอนของจำนวน ได้แก่ เขียน ผู้หยิบอ่าน ปาใส่
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
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
                                        List users = snapshot?.data['id'];
                                        Map data = snapshot?.data['scraps'];

                                        return snapshot?.data['id'] == null ||
                                                users.length == 0
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
                                            : Wrap(
                                                children: users
                                                    .map((userID) => mScrap(
                                                        a,
                                                        users[users.length -
                                                            1 -
                                                            users.indexOf(
                                                                userID)],
                                                        data))
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
                                modiList(snapshot?.data['id'],
                                    snapshot?.data['scraps'], mSet);
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

  modiList(List users, Map data, Set mSet) {
    if (users != null || data != null) {
      for (var id in users) {
        if (data[id] == null || data[id].length == 0) {
          clearScrap(data[id] == null, id);
        } else {
          for (var scraps in data[id]) {
            mSet.add({'scap': scraps, 'id': id});
          }
        }
      }
    }
  }

  clearScrap(bool onlyID, String id) {
    Firestore.instance
        .collection('Users')
        .document(widget.doc['uid'])
        .collection('scraps')
        .document('collection')
        .updateData({
      'id': FieldValue.arrayRemove([id])
    }).then((value) {
      onlyID
          ? null
          : Firestore.instance
              .collection('Users')
              .document(widget.doc['uid'])
              .collection('scraps')
              .document('collection')
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
                  scrap: mList[mList.length - 1 - mList.indexOf(scrap)],
                  uid: widget.doc['uid'],
                ))
            .toList(),
      ),
    );
  }

//data[data.length - 1 -data.indexOf(userID)]
  Widget mScrap(Size a, String id, Map data) {
    List scraps = data[id];
    return scraps == null
        ? delete(id)
        : Wrap(
            children: scraps
                .map((scrapData) => scrap(
                    a,
                    backward(scraps, scrapData)['text'],
                    backward(scraps, scrapData)['writer'],
                    backward(scraps, scrapData)['time'],
                    backward(scraps, scrapData),
                    id))
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

  Widget scrap(
      Size a, String text, String writer, String time, Map scpData, String id) {
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
          dialog(text, writer, time, scpData, id);
        },
      ),
    );
  }

//ส่วนของ กระดาษที่ถูกปาใส่ เม���่อกด
  dialog(
      String text, String writer, String time, Map scpData, String writerID) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          Size a = MediaQuery.of(context).size;
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Container(
                height: a.height / 1.5,
                margin: EdgeInsets.only(
                    top: a.height / 5,
                    right: a.width / 20,
                    left: 20,
                    bottom: a.width / 8),
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
                          width: a.width / 1.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      border: Border.all(color: Colors.black),
                                      borderRadius:
                                          BorderRadius.circular(a.width / 10)),
                                  alignment: Alignment.center,
                                  child: Text("ปากลับ"),
                                ),
                                onTap: () {
                                  dialogPa(writerID);
                                },
                              )
                            ],
                          ),
                        )),
                    Positioned(
                      bottom: 0,
                      left: a.width / 8,
                      width: a.width / 1.5,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                margin: EdgeInsets.only(left: a.width / 55),
                                width: a.width / 4.5,
                                height: a.width / 8,
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
                                width: a.width / 4.5,
                                height: a.width / 8,
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
                                Navigator.pop(context);
                                await ignore(writerID, scpData);
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
                          width: a.width / 1.2,
                          child: Text(
                            text,
                            style: TextStyle(fontSize: a.width / 14),
                          ),
                        ))
                  ],
                ),
              ),
            );
          });
        },
        fullscreenDialog: true));
  }

  dialogPa(String id) {
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
              child: Column(
                children: <Widget>[
                  Container(
                    height: a.width / 8,
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "ปาใส่กลับโดย : ",
                              style: TextStyle(fontSize: a.width / 20,color:Colors.black),
                            ),
                            Text(
                             "@"+widget.doc['id'],
                              style: TextStyle(
                                  color: Color(0xff26A4FF),
                                  fontSize: a.width / 20),
                            )
                          ],
                        ),
                        InkWell(
                          child: Container(
                              width: a.width / 15,
                              height: a.width / 15,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(a.width)),
                              child: Icon(
                                Icons.clear,color:Colors.white
                              )),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        right: a.width / 40, left: a.width / 40),
                    height: a.width / 3.4,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
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
                          top: a.width / 15, right: a.width / 30),
                      child: Container(
                          width: a.width / 5.5,
                          height: a.width / 11,
                          decoration: BoxDecoration(
                              color: Color(0xff26A4FF),
                              borderRadius: BorderRadius.circular(a.width)),
                          alignment: Alignment.center,
                          child: Text(
                            "ปาเลย",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      throwTo(id, text2);
                    },
                  )
                ],
              ),
            ),
          );
        });
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
