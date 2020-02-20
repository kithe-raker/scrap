import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scrap/Page/viewprofile.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/guide.dart';
import 'package:scrap/widget/warning.dart';

class Search extends StatefulWidget {
  final DocumentSnapshot doc;
  final Map data;
  Search({@required this.doc, this.data});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String id;
  bool search = false;

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(children: <Widget>[
        Container(
          color: Colors.black,
          width: a.width,
          child: Padding(
            padding: EdgeInsets.only(
                top: a.width / 20,
                right: a.width / 25,
                left: a.width / 25,
                bottom: a.width / 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                search
                    ? Row(
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: a.width / 12,
                              ),
                              onPressed: () {
                                setState(() {
                                  search = false;
                                });
                              }),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              width: a.width * 9 / 12,
                              height: a.width / 6.5,
                              decoration: BoxDecoration(
                                color: Color(0xff282828),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(300)),
                                border: Border.all(
                                    width: 2, color: Colors.grey[800]),
                              ),
                              child: TextFormField(
                                autofocus: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 14,
                                  fontWeight: FontWeight.w300,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '@somename',
                                  hintStyle: TextStyle(color: Colors.grey[700]),
                                ),
                                onChanged: (value) {
                                  id = value.trim();
                                  setState(() {});
                                },
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      color: Colors.black, size: a.width / 15),
                                ),
                                onTap: () {
                                  Navigator.pop(
                                    context,
                                  );
                                },
                              ),
                            ],
                          ), //back btn

                          SizedBox(height: a.height / 12.5),

                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'ค้นหาผู้ใช้',
                                  style: TextStyle(
                                      fontSize: a.width / 6.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  'ค้นหาคนที่คุณรู้จักแล้วปากระดาษใส่พวกเขากัน',
                                  style: TextStyle(
                                      fontSize: a.width / 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: a.width / 13,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              width: a.width,
                              height: a.width / 6.5,
                              decoration: BoxDecoration(
                                color: Color(0xff282828),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(300)),
                                border: Border.all(
                                    width: 2, color: Colors.grey[800]),
                              ),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 14,
                                  fontWeight: FontWeight.w300,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '@somename',
                                  hintStyle: TextStyle(color: Colors.grey[700]),
                                ),
                                onTap: () {
                                  setState(() {
                                    search = true;
                                  });
                                },
                                // onChanged: (value) {
                                //   id = value.trim();
                                //   setState(() {});
                                // },
                                //textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                        ],
                      ),
                search
                    ? id == null || id == ''
                        ? guide(
                            a,
                            'ค้นหาคนที่คุณต้องการปาใส่',
                            a.height / 1.5,
                          )
                        : id[0] != '@'
                            ? guide(
                                a,
                                'ค้นหาคนที่คุณจะปาใส่โดยใส่@ตามด้วยชื่อid',
                                a.height / 1.5,
                              )
                            : StreamBuilder(
                                stream: Firestore.instance
                                    .collection('Users')
                                    .where('searchIndex',
                                        arrayContains: id.substring(1))
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.connectionState ==
                                          ConnectionState.active) {
                                    List docs = snapshot.data.documents;
                                    return docs?.length == null ||
                                            docs?.length == 0
                                        ? guide(
                                            a,
                                            'ขออภัยค่ะเราไม่พบผู้ใช้ดังกล่าว',
                                            a.height / 1.5,
                                          )
                                        : Column(
                                            children: docs
                                                .map((data) =>
                                                    userCard(a, data, false))
                                                .toList(),
                                          );
                                  } else {
                                    return Container(
                                      height: a.height / 2.1,
                                      width: a.width,
                                      child: Center(
                                        child: Container(
                                          width: a.width / 3.6,
                                          height: a.width / 3.6,
                                          decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withOpacity(0.42),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: FlareActor(
                                            'assets/paper_loading.flr',
                                            animation: 'Untitled',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )
                    : StreamBuilder(
                        stream: Firestore.instance
                            .collection('Users')
                            .document(widget.doc['uid'])
                            .collection('info')
                            .document('searchHist')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.active) {
                            List users = snapshot?.data['history'];
                            return users == null || users.length == null
                                ? guide(
                                    a,
                                    'คุณไม่มีประวัติการปา',
                                    a.height / 2.4,
                                  )
                                : Column(
                                    children: users
                                        .map((data) => userCard(
                                            a,
                                            users[users.length -
                                                1 -
                                                users.indexOf(data)],
                                            true))
                                        .toList(),
                                  );
                          } else {
                            return Container(
                              height: a.height / 2.1,
                              width: a.width,
                              child: Center(
                                child: Container(
                                  width: a.width / 3.6,
                                  height: a.width / 3.6,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.42),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: FlareActor(
                                    'assets/paper_loading.flr',
                                    animation: 'Untitled',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }
                        })
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget guide(Size a, String text, double heigth) {
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

  Widget userCard(Size a, DocumentSnapshot doc, bool hist) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Users')
            .document(doc.data['uid'])
            .collection('info')
            .document(doc.data['uid'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            return doc.data['id'] != widget.doc['id']
                ? Padding(
                    padding:
                        const EdgeInsets.only(top: 50.0, left: 5.0, right: 5.0),
                    child: InkWell(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: a.height / 4.5,
                            width: a.width,
                            decoration: BoxDecoration(
                                color: Color(0xff282828),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0),
                                )),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 13),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(a.width),
                                        border: Border.all(
                                            color: Colors.white,
                                            width: a.width / 190)),
                                    width: a.width / 3.3,
                                    height: a.width / 3.3,
                                    child: ClipRRect(
                                      child: Image.network(
                                        snapshot.data['img'],
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(a.width),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '@${doc.data['id']}',
                                        style: TextStyle(
                                            fontSize: a.width / 13,
                                            color: Colors.white),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Join ${snapshot.data['createdDay']}',
                                            style: TextStyle(
                                                fontSize: a.width / 11,
                                                color: Color(0xff26A4FF)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Positioned(
                            right: 10.0,
                            top: 10.0,
                            child: hist
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: Color(0xffA3A3A3),
                                      size: 30.0,
                                    ),
                                    onPressed: () {
                                      warnClear(snapshot.data['id'],
                                          snapshot.data['uid']);
                                    })
                                : Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xffA3A3A3),
                                    size: 30.0,
                                  ),
                          )
                        ],
                      ),
                      onTap: () {
                        widget.data == null
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Viewprofile(
                                    info: snapshot.data,
                                    account: doc,
                                    self: widget.doc,
                                  ),
                                ))
                            : Dg().warnDialog(
                                context, doc.data['id'], doc.data['uid']);
                      },
                    ),
                  )
                : SizedBox();
          } else {
            return SizedBox();
          }
        });
  }

  warnDialog(String user, String thrownID) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              child: Text('คุณต้องการปาใส่' + user + 'ใช่หรือไม่'),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ยกเลิก')),
              FlatButton(
                child: Text('ok'),
                onPressed: () async {
                  toast('ปาใส่"$user"แล้ว');
                  Navigator.pop(context);
                  Navigator.pop(context);
                  await throwTo(widget.data, thrownID);
                },
              )
            ],
          );
        });
  }

  warnClear(String user, String thrownID) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              child: Text('คุณต้องนำ' + user + 'อกกจากประวัติใช่หรือไม่'),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ยกเลิก')),
              FlatButton(
                child: Text('ok'),
                onPressed: () async {
                  toast('ลบ"$user"ออกแล้ว');
                  Navigator.pop(context);
                  await clearHist(thrownID);
                },
              )
            ],
          );
        });
  }

  clearHist(String thrown) async {
    await Firestore.instance
        .collection('Users')
        .document(widget.doc['uid'])
        .collection('info')
        .document('searchHist')
        .updateData({
      'history': FieldValue.arrayRemove([thrown])
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

  throwTo(Map data, String thrownID) async {
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
          {
            'text': data['text'],
            'writer':
                data['public'] ?? false ? widget.doc['id'] : 'ไม่ระบุตัวตน',
            'time': time
          }
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
        .add({
      'writer':
          widget.data['public'] ?? false ? widget.doc['id'] : 'ไม่ระบุตัวตน',
      'date': date,
      'time': time
    });
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
}
