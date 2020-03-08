import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrap/Page/viewprofile.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/services/jsonConverter.dart';
import 'package:scrap/widget/Toast.dart';

class Search extends StatefulWidget {
  final DocumentSnapshot doc;
  final Map data;
  Search({@required this.doc, this.data});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String id;
  var _key = GlobalKey<FormState>();
  DocumentSnapshot cache;
  Scraps scraps = Scraps();
  JsonConverter jsonConverter = JsonConverter();
  List friends = [];

  @override
  void initState() {
    initeFriend();
    super.initState();
  }

  initeFriend() async {
    friends = await jsonConverter.readContents();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
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
                  Column(
                    children: <Widget>[
                      Row(
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
                              Navigator.pop(context, true);
                            },
                          ),
                        ],
                      ), //back btn
                      SizedBox(height: a.height / 12.5),
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
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
                      Form(
                        key: _key,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 30),
                                width: a.width / 1.4,
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
                                    hintStyle:
                                        TextStyle(color: Colors.grey[700]),
                                  ),
                                  validator: (val) {
                                    return val.trim() == ""
                                        ? Taoast().toast("โปรดใส่ไอดี")
                                        : val[0] == '@'
                                            ? null
                                            : Taoast().toast(
                                                "ค้นหาคนที่คุณจะปาใส่โดยใส่@ตามด้วยชื่อid");
                                  },
                                  onSaved: (value) {
                                    id = value.trim();
                                    setState(() {});
                                  },
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                  margin: EdgeInsets.only(bottom: 30),
                                  alignment: Alignment.center,
                                  width: a.width / 8,
                                  height: a.width / 8,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(a.width),
                                    border: Border.all(
                                        width: 2, color: Colors.white),
                                    color: Color(0xff26A4FF),
                                  ),
                                  child: Text(
                                    '@',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: a.width / 11,
                                        color: Colors.white),
                                  )),
                              onTap: () {
                                if (_key.currentState.validate()) {
                                  _key.currentState.save();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  id == null ||
                          id == '' ||
                          id.length < 2 ||
                          id.substring(1) == widget.doc['id']
                      ? guide(
                          a,
                          'ค้นหาคนที่คุณต้องการปาใส่',
                          a.height / 2.1,
                        )
                      : StreamBuilder(
                          stream: Firestore.instance
                              .collection('SearchUsers')
                              .document(id[1])
                              .collection('users')
                              .where('id', isEqualTo: id.substring(1))
                              .limit(1)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.active) {
                              List docs = snapshot.data.documents;
                              return docs?.length == null || docs?.length == 0
                                  ? guide(
                                      a,
                                      'ขออภัยค่ะเราไม่พบผู้ใช้ดังกล่าว',
                                      a.height / 1.5,
                                    )
                                  : Column(
                                      children: docs
                                          .map((data) =>
                                              cardStream(a, data['uid']))
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
                          })
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  dynamic backward(List list, dynamic value) {
    return list[list.length - 1 - list.indexOf(value)];
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

  Widget cardStream(Size a, String searchID) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Users')
            .document(searchID)
            .collection('info')
            .document(searchID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            return StreamBuilder(
                stream: Firestore.instance
                    .collection('Users')
                    .document(searchID)
                    .snapshots(),
                builder: (context, snap) {
                  if (snap.hasData &&
                      snap.connectionState == ConnectionState.active) {
                    return userCard(a, snapshot.data['img'], searchID,
                        snap.data['id'], snapshot.data['createdDay'],
                        accDoc: snap.data, infoDoc: snapshot.data);
                  } else {
                    return SizedBox();
                  }
                });
          } else {
            return SizedBox();
          }
        });
  }

  Widget userCard(
      Size a, String img, String tID, String throwID, String created,
      {DocumentSnapshot infoDoc, DocumentSnapshot accDoc}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
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
                      margin: EdgeInsets.only(left: 20, right: 13),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(a.width),
                          border: Border.all(
                              color: Colors.white, width: a.width / 190)),
                      width: a.width / 3.3,
                      height: a.width / 3.3,
                      child: ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl: img,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(a.width),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: a.width / 2.2,
                          height: a.width / 10,
                          child: Text(
                            throwID,
                            style: TextStyle(
                                fontSize: a.width / 13, color: Colors.white),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Join $created',
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
            friends.where((data) => data['id'].contains(throwID)).length == 1
                ? Center(
                    child: Text('เพื่อน'),
                  )
                : Center(
                    child: RaisedButton(
                        child: Text('add'),
                        onPressed: () async {
                          await addFriend(tID, throwID, img, created);
                          Taoast().toast("เพิ่ม $throwID เป็นสหายแล้ว");
                        }),
                  ),
            Positioned(
              right: 10.0,
              top: 10.0,
              child: Icon(
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
                      id: throwID,
                      self: widget.doc,
                    ),
                  ))
              : warnDialog(throwID, tID);
        },
      ),
    );
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
                child: Text('ตกลง'),
                onPressed: () async {
                  if (await blocked(widget.doc['uid'], thrownID)) {
                    toast('คุณไม่สามารถปาไปหา"$user"ได้');
                  } else {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    await scraps.throwTo(
                        uid: widget.doc['uid'],
                        writer: widget.doc['id'],
                        thrownID: thrownID,
                        text: widget.data['text'],
                        public: widget.data['public']);
                    toast('ปาใส่"$user"แล้ว');
                  }
                },
              )
            ],
          );
        });
  }

  Future<bool> blocked(String uid, String thrownID) async {
    List blockList = [];
    await Firestore.instance
        .collection('Users')
        .document(thrownID)
        .collection('info')
        .document('blockList')
        .get()
        .then((value) {
      value?.data == null
          ? blockList = []
          : blockList = value?.data['blockList'] ?? [];
    });
    return blockList.contains(uid);
  }

  addFriend(String uid, String newFriend, String img, String join) async {
    await Firestore.instance
        .collection('Users')
        .document(widget.doc['uid'])
        .collection('info')
        .document('friends')
        .setData({
      'friendList': FieldValue.arrayUnion([uid])
    }, merge: true);
    jsonConverter.addContent(id: newFriend, imgUrl: img, joinD: join);
    setState(
        () => friends.add({'id': newFriend, 'imgUrl': img, 'joinD': join}));
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
}
