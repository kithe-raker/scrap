//import 'package:circular_check_box/circular_check_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:scrap/Page/MapScraps.dart';
import 'package:scrap/Page/NotificationHistory.dart';
import 'package:scrap/Page/Search.dart';
import 'package:scrap/Page/addPlayer.dart';
import 'package:scrap/Page/profile/Profile.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';

class HomePage extends StatefulWidget {
  final Position currentLocation;
  final DocumentSnapshot doc;
  HomePage({@required this.doc, @required this.currentLocation});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String type, select, text;
  bool public;
  var _key = GlobalKey<FormState>();
  var currentLocation;

  @override
  void initState() {
    Geolocator().getCurrentPosition().then((curlo) {
      setState(() {
        currentLocation = curlo;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => null,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Stack(
          children: <Widget>[
            scrapPatt(a, context),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(bottom: a.width / 10),
                alignment: Alignment.bottomCenter,
                width: a.width,
                height: a.height / 1.1,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: a.width / 7,
                        height: a.width / 7,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff1a1a1a),
                                blurRadius: 3.0,
                                spreadRadius: 2.0,
                                offset: Offset(
                                  0.0,
                                  3.2,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(a.width),
                            color: Colors.white),
                        child: IconButton(
                          icon: Icon(Icons.people),
                          color: Color(0xff26A4FF),
                          iconSize: a.width / 12,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddPlayer(),
                                ));
                          },
                        ),
                      ),
                      SizedBox(
                        width: a.width / 21,
                      ),
                      Container(
                        width: a.width / 7,
                        height: a.width / 7,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff1a1a1a),
                                blurRadius: 10.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(a.width),
                            color: Color(0xff26A4FF)),
                        child: IconButton(
                          icon: Icon(Icons.refresh),
                          color: Colors.white,
                          iconSize: a.width / 15,
                          onPressed: () {
                            setState(() {});
                            // selectDialog(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: a.height / 42,
              left: a.width / 2.8,
              child: InkWell(
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
                onTap: () {
                  dialog();
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                // ส่วนของ แทบสีดำด้านบน
                color: Colors.black,
                width: a.width,
                height: a.width / 5,
                padding: EdgeInsets.only(
                  top: a.height / 36,
                  right: a.width / 20,
                  left: a.width / 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //Logo
                    Container(
                        margin: EdgeInsets.only(top: a.width / 90),
                        height: a.width / 7,
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/SCRAP.png',
                          width: a.width / 4,
                        )),
                    //ส่วนของ UI ปุ่ม account เพื่อไปหน้า Profile

                    SizedBox(
                      width: a.width / 5,
                    ),
                    Container(
                        height: a.width / 5,
                        alignment: Alignment.center,
                        child: InkWell(
                          child: Container(
                            width: a.width / 10,
                            height: a.width / 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(a.width),
                              border: Border.all(width: 2, color: Colors.white),
                              color: Color(0xff26A4FF),
                            ),
                            child: Icon(Icons.search,
                                color: Colors.white, size: a.width / 15),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Search(
                                          doc: widget.doc,
                                        ))); //ไปยังหน้า Search
                          },
                        )),
                    Container(
                        height: a.width / 5,
                        alignment: Alignment.center,
                        child: InkWell(
                          child: Container(
                            width: a.width / 10,
                            height: a.width / 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(a.width),
                              color: Colors.white,
                            ),
                            child: Icon(Icons.notifications_active,
                                color: Color(0xff26A4FF), size: a.width / 15),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationHistory(
                                          doc: widget.doc,
                                        ))); //ไปยังหน้า NotificationHistory
                          },
                        )),
                    Container(
                        height: a.width / 5,
                        alignment: Alignment.center,
                        child: InkWell(
                          child: Container(
                            width: a.width / 10,
                            height: a.width / 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(a.width),
                              color: Colors.white,
                            ),
                            child: Icon(Icons.person,
                                color: Colors.black, size: a.width / 15),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile(
                                          doc: widget.doc,
                                          data: {'public': public ?? false},
                                        ))); //ไปยังหน้า Profile
                          },
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget changeScrap(String scraps, Size a) {
  //   switch (scraps) {
  //     case 'Analysts':
  //       return scrapPatt(a, 'Analysts');
  //       break;
  //     case 'Diplomats':
  //       return scrapPatt(a, 'Diplomats');
  //       break;
  //     case 'Explorers':
  //       return scrapPatt(a, 'Explorers');
  //       break;
  //     case 'Girl':
  //       return scrapPatt(a, 'Girl');
  //       break;
  //     case 'Sentinels':
  //       return scrapPatt(a, 'Sentinels');
  //       break;
  //     default:
  //       return scrapPatt(a, 'Analysts');
  //       break;
  //   }
  // }

/*
       Set id = {};
            List scraps = [];
            for (var usersID in snap.data['id']) {
              id.add(usersID);
              for (var scrap in snap.data['scraps'][usersID]) {
                scraps.add(scrap);
              } /Users/gPSC1TxFcXVVZ1nQOrPR2kX9SBU2/scraps/collection
            } */
  scrapPatt(Size a, BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Users')
            .document(widget.doc['uid'])
            .collection('scraps')
            .document('collection')
            .snapshots(),
        builder: (context, snap) {
          if (snap.hasData && snap.connectionState == ConnectionState.active) {
            return widget?.currentLocation == null
                ? gpsCheck(a)
                : MapScraps(
                    collection: snap?.data['id'] ?? [],
                    currentLocation: widget?.currentLocation ?? currentLocation,
                    uid: widget.doc['uid'],
                  );
          } else {
            return Loading();
          }
        });
  }

  Widget gpsCheck(Size a) {
    return Center(
      child: Container(
        width: a.width / 1.2,
        height: a.width / 3.2,
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                width: a.width / 3.2,
                height: a.width / 3.2,
                child: FlareActor(
                  'assets/paper_loading.flr',
                  animation: 'Untitled',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'กรุณาตรวจสอบGPSหรืออินเทอร์เน็ตของท่าน',
                  style: TextStyle(fontSize: a.width / 16, color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }

  selectDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              content: StreamBuilder(
                  stream: Firestore.instance.collection('Contents').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active) {
                      Set head = {};
                      QuerySnapshot title = snapshot.data;
                      for (var item in title.documents) {
                        head.add(item.documentID);
                      }
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.height / 1.5,
                                  height:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: ListView(
                                      children: head
                                          .map((e) => choice(e, setState))
                                          .toList()),
                                ),
                                butt()
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }));
        });
  }

  Widget choice(String value, StateSetter setState) {
    return Row(
      children: <Widget>[
        Radio(
          activeColor: Color(0xffEF7D36),
          value: value,
          groupValue: select,
          onChanged: (val) {
            setState(() {
              select = val;
            });
          },
        ),
        Text(
          value,
        )
      ],
    );
  }

  Widget butt() {
    return RaisedButton(
        child: Text('ok'),
        onPressed: () {
          setState(() {
            type = select;
          });
          Navigator.pop(context);
        });
  }

  binScrap(String time) async {
    GeoFirePoint point;
    await Geolocator().getCurrentPosition().then((value) => point =
        Geoflutterfire()
            .point(latitude: value.latitude, longitude: value.longitude));
    await Firestore.instance
        .collection('Scraps')
        .document('hatyai')
        .collection('scrapsPosition')
        .add({
      'uid': widget.doc['uid'],
      'scrap': {
        'text': text,
        'user': public ?? false ? widget.doc['id'] : 'ไม่ระบุตัวตน',
        'time': time
      },
      'position': point.data
    }).then((value) {
      Firestore.instance
          .collection('Scraps')
          .document('hatyai')
          .collection('scrapsPosition')
          .document(value.documentID)
          .updateData({'id': value.documentID});
    });
    await increaseTransaction(widget.doc['uid'], 'written');
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

//ส่วนเมื่อกดปุ่ม Create จะเด้นกล่องนี���ขึ้นมาไว้สร้าง Contents
  void dialog() {
    DateTime now = DateTime.now();
    String time = DateFormat('Hm').format(now);
    String date = DateFormat('d/M/y').format(now);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          Size a = MediaQuery.of(context).size;
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      child: Image.asset(
                        './assets/bg.png',
                        fit: BoxFit.cover,
                        width: a.width,
                        height: a.height,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: a.height / 8,
                        right: a.width / 20,
                        left: 20,
                        bottom: a.width / 8),
                    child: ListView(
                      children: <Widget>[
                        Form(
                          key: _key,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: a.height,
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    //ปุ่มกดหากต้องการที่จะเปิดเผยตัวตน
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: a.width / 13,
                                            height: a.width / 13,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        a.width / 50),
                                                border: Border.all(
                                                    color: Colors.white)),
                                            child: Checkbox(
                                              value: public ?? false,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  public = value;
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              "\t" + "เปิดเผยตัวตน",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: a.width / 20),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    //ออกจากหน้านี้
                                    InkWell(
                                      child: Icon(
                                        Icons.clear,
                                        size: a.width / 10,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              //ส่ว��ของกระดาษที่เขีย���
                              Container(
                                margin: EdgeInsets.only(top: a.width / 150),
                                width: a.width / 1,
                                height: a.height / 1.8,
                                //ทำเป็นชั้นๆ
                                child: Stack(
                                  children: <Widget>[
                                    //ช���้นที่ 1 ส่วนของก���ะดาษ
                                    Container(
                                      child: Image.asset(
                                        'assets/paper-readed.png',
                                        width: a.width / 1,
                                        height: a.height / 1.2,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    //ชั้นที่ 2
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: a.width / 20,
                                          top: a.width / 20),
                                      width: a.width,
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          public ?? false
                                              ? Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "เขียนโดย : ",
                                                      style: TextStyle(
                                                          fontSize:
                                                              a.width / 22,
                                                          color: Colors.grey),
                                                    ),
                                                    Text("@${widget.doc['id']}",
                                                        style: TextStyle(
                                                            fontSize:
                                                                a.width / 22,
                                                            color: Color(
                                                                0xff26A4FF)))
                                                  ],
                                                )
                                              : Text(
                                                  'เขียนโดย : ใครสักคน',
                                                  style: TextStyle(
                                                      fontSize: a.width / 22,
                                                      color: Colors.grey),
                                                ),
                                          Text("เวลา" + " : $time $date",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: a.width / 22))
                                        ],
                                      ),
                                    ),
                                    //ชั้นที่ 3 เอาไว้สำหรับเขียนข้อความ
                                    Container(
                                      width: a.width,
                                      height: a.height,
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width: a.width / 1.5,
                                        child: TextFormField(
                                          textAlign: TextAlign
                                              .center, //เพื่อให้ข้อความอยู่ตรงกลาง
                                          style:
                                              TextStyle(fontSize: a.width / 15),
                                          maxLines: null,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            border: InputBorder
                                                .none, //สำหรับใหเส้นใต้หาย
                                            hintText: 'เขียนข้อความบางอย่าง',
                                            hintStyle: TextStyle(
                                              fontSize: a.width / 18,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          //หากไม่ได้กรอกจะขึ้น
                                          validator: (val) {
                                            return val.trim() == null ||
                                                    val.trim() == ""
                                                ? Taoast().toast(
                                                    "ลองเขียนข้อความบางอย่างสิ")
                                                : null;
                                          },
                                          //เนื้อหาที่กรอกเข้าไปใน text
                                          onChanged: (val) {
                                            text = val;
                                          },
                                        ),
                                      ),
                                    )
                                    //)
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: a.width / 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      child: Container(
                                          width: a.width / 4.5,
                                          height: a.width / 8,
                                          margin: EdgeInsets.only(
                                              right: a.width / 20),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      a.width)),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "ทิ้งไว้",
                                            style: TextStyle(
                                                fontSize: a.width / 15,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      onTap: () async {
                                        if (_key.currentState.validate()) {
                                          _key.currentState.save();
                                          toast('คุณได้ทิ้งกระดาษไว้แล้ว');
                                          Navigator.pop(context);
                                          await binScrap('$time $date');
                                        } else {
                                          print('nope');
                                        }
                                      },
                                    ),
                                    //ปุ่มปาใส่

                                    InkWell(
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(left: a.width / 20),
                                        width: a.width / 4.5,
                                        height: a.width / 8,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(a.width)),
                                        alignment: Alignment.center,
                                        child: Text("ปาใส่",
                                            style: TextStyle(
                                                fontSize: a.width / 15,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      //ให้ dialog แรกหายไปก่อนแล้วเปิด dialog2
                                      onTap: () {
                                        if (_key.currentState.validate()) {
                                          _key.currentState.save();
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Search(
                                                  doc: widget.doc,
                                                  data: {
                                                    'text': text,
                                                    'public': public ?? false
                                                  },
                                                ),
                                              ));
                                        } else {
                                          print('nope');
                                        }
                                      },
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
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

  // throwTo(Map selectedID) async {
  //   await Firestore.instance
  //       .collection('Users')
  //       .document(selectedID['uid'])
  //       .collection('scraps')
  //       .document('recently')
  //       .updateData(
  //     {
  //       'scraps': FieldValue.arrayUnion([text])
  //     },
  //   );
  // }

  chooseUser() {
    String id;
    Map selectedID = {};
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              content:
                  StatefulBuilder(builder: (context, StateSetter setState) {
                Size a = MediaQuery.of(context).size;
                return Container(
                  width: a.width / 1.2,
                  height: a.height / 1.2,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                    child: Icon(Icons.arrow_back,
                                        size: a.width / 15,
                                        color: Colors.white),
                                    onTap: () {
                                      Navigator.pop(context);
                                      dialog();
                                    }),
                                // InkWell(
                                //   child: Icon(Icons.arrow_back,
                                //       size: a.width / 15, color: Colors.white),
                                //   onTap: () {
                                //     Navigator.pop(context);
                                //     dialog();
                                //   },
                                // ),
                                InkWell(
                                  child: Icon(Icons.clear,
                                      size: a.width / 15, color: Colors.white),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          ),
                          selectedID == null || selectedID['id'] == null
                              ? Container(
                                  margin: EdgeInsets.only(top: a.width / 20),
                                  width: a.width / 1.1,
                                  height: a.height / 1.5,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius:
                                          BorderRadius.circular(a.width / 10)),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: a.width / 20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              a.width / 10),
                                          color: Colors.black,
                                        ),
                                        width: a.width / 1.7,
                                        height: a.width / 7,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: a.width / 20),
                                          child: TextFormField(
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: a.width / 15),
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '@someoneuserid',
                                              hintStyle: TextStyle(
                                                fontSize: a.width / 15,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            onChanged: (val) {
                                              setState(() {
                                                id = val;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      id == null || id == ''
                                          ? Center(
                                              child: Text(
                                                  'ค้นหาคนที่คุณต้องการปาใส่'),
                                            )
                                          : id[0] != '@'
                                              ? Center(
                                                  child: Text(
                                                      'ค้นหาคนที่คุณจะปาใส่โดยใส่ @ตามด้วยชื่อid'),
                                                )
                                              : StreamBuilder(
                                                  stream: Firestore.instance
                                                      .collection('Users')
                                                      .where('searchIndex',
                                                          arrayContains:
                                                              id.substring(1))
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData &&
                                                        snapshot.connectionState ==
                                                            ConnectionState
                                                                .active) {
                                                      return snapshot.data
                                                                      ?.documents ==
                                                                  null ||
                                                              snapshot
                                                                      .data
                                                                      .documents
                                                                      .length ==
                                                                  0
                                                          ? Center(
                                                              child: Text(
                                                                  'ไม่พบ id ดังกล่าว'),
                                                            )
                                                          : Container(
                                                              width:
                                                                  a.width / 1.1,
                                                              height:
                                                                  a.height / 2,
                                                              child: ListView
                                                                  .builder(
                                                                      itemCount: snapshot
                                                                          .data
                                                                          .documents
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        DocumentSnapshot
                                                                            doc =
                                                                            snapshot.data.documents[index];
                                                                        return
                                                                            // doc['id'] !=
                                                                            //         widget.doc['id']
                                                                            //     ?
                                                                            InkWell(
                                                                          child: Container(
                                                                              padding: EdgeInsets.all(a.width / 21),
                                                                              width: a.width / 1.1,
                                                                              height: a.height / 10,
                                                                              alignment: Alignment.center,
                                                                              child: Text(
                                                                                '@' + doc['id'],
                                                                                style: TextStyle(fontSize: a.width / 12, color: Colors.white),
                                                                              )),
                                                                          onTap:
                                                                              () {
                                                                            selectedID['id'] =
                                                                                doc['id'];
                                                                            selectedID['uid'] =
                                                                                doc['uid'];
                                                                            setState(() {});
                                                                          },
                                                                        );
                                                                        //: SizedBox();
                                                                      }),
                                                            );
                                                    } else {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }
                                                  })
                                    ],
                                  ),
                                )
                              : Container(
                                  color: Colors.grey,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          child: Text(
                                        'ปาใส่' + selectedID['id'],
                                        style:
                                            TextStyle(fontSize: a.width / 12),
                                      )),
                                      Image.asset(
                                        './assets/paper.png',
                                        width: a.width / 6.4,
                                        height: a.width / 6.4,
                                        fit: BoxFit.cover,
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: a.width / 10),
                                          child: Row(
                                            children: <Widget>[
                                              InkWell(
                                                child: Container(
                                                  width: a.width / 4.5,
                                                  height: a.width / 8,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              a.width)),
                                                  alignment: Alignment.center,
                                                  child: Text("เปลี่ยนคน",
                                                      style: TextStyle(
                                                          fontSize:
                                                              a.width / 15)),
                                                ),
                                                onTap: () {
                                                  id = '';
                                                  selectedID.clear();
                                                  setState(() {});
                                                },
                                              ),
                                              InkWell(
                                                child: Container(
                                                  width: a.width / 4.5,
                                                  height: a.width / 8,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              a.width)),
                                                  alignment: Alignment.center,
                                                  child: Text("ปาเลย",
                                                      style: TextStyle(
                                                          fontSize:
                                                              a.width / 15)),
                                                ),
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  //  await throwTo(selectedID);
                                                },
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                        ],
                      )
                    ],
                  ),
                );
              }));
        });
  }
}
