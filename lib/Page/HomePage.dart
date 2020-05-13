import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scrap/Page/Gridsubscripe.dart';
import 'package:scrap/Page/MapScraps.dart';
import 'package:scrap/Page/friendList.dart';
import 'package:scrap/Page/profile/Profile.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/services/jsonConverter.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/warning.dart';

class HomePage extends StatefulWidget {
  final DocumentSnapshot doc;
  HomePage({@required this.doc});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String type, select, text, img;
  int scraps;
  bool public, initInfoFinish = false;
  var _key = GlobalKey<FormState>();
  Scraps scrap = Scraps();
  JsonConverter jsonConverter = JsonConverter();
 
  @override
  void initState() {
    Admob.initialize(AdmobService().getAdmobAppId());
    initUser();
    super.initState();
    FirebaseAdMob.instance.initialize(appId: AdmobService().getAdmobAppId());
    
  }

  initUser() async {
    var data = await userinfo.readContents();
    img = data['img'];
    setState(() => initInfoFinish = true);
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Dg().warnDialog(context, 'คุณต้องการออกจากScrapใช่หรือไม่', () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        });
        return null;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Stack(
          children: <Widget>[
            MapScraps(uid: widget.doc['uid']),
            Positioned(
                bottom: 0,
                child: Container(
                    padding: EdgeInsets.only(bottom: a.width / 10),
                    alignment: Alignment.bottomCenter,
                    width: a.width,
                    height: a.height / 1.1,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          scrapLeft(a),
                          Container(
                            width: a.width / 7,
                            height: a.width / 7,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white,
                                      blurRadius: 3.0,
                                      spreadRadius: 2.0,
                                      offset: Offset(0.0, 3.2))
                                ],
                                borderRadius: BorderRadius.circular(a.width),
                                color: Color(0xff26A4FF)),
                            child: IconButton(
                              icon: Icon(Icons.dashboard),
                              color: Colors.white,
                              iconSize: a.width / 12,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Gridsubscripe(),
                                    ));
                              },
                            ),
                          ),
                          InkWell(
                            child: Container(
                              width: a.width / 3.8,
                              height: a.width / 3.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(a.width),
                                  border: Border.all(
                                      color: Colors.white38,
                                      width: a.width / 500)),
                              child: Container(
                                margin: EdgeInsets.all(a.width / 40),
                                width: a.width / 6,
                                height: a.width / 6,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(a.width),
                                    border: Border.all(color: Colors.white)),
                                child: Container(
                                  margin: EdgeInsets.all(a.width / 40),
                                  width: a.width / 6,
                                  height: a.width / 6,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(a.width),
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
                              if (scraps > 0) {
                                dialog();
                              } else
                                toast('กระดาษคุณหมดแล้ว');
                            },
                          ),
                        ],
                      ),
                    ))),

            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: a.width,
                child: Column(
                  children: [
                    Container(
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
                          //��่วนของ UI ปุ่ม account เพื่อไปหน้า Profile
                          SizedBox(width: a.width / 2.7),
                          Container(
                              height: a.width / 5,
                              alignment: Alignment.center,
                              child: InkWell(
                                child: Container(
                                  width: a.width / 10,
                                  height: a.width / 10,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(a.width),
                                    color: Colors.white,
                                  ),
                                  child: Icon(Icons.people,
                                      color: Colors.black, size: a.width / 15),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FriendList(doc: widget.doc)));
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
                                      borderRadius:
                                          BorderRadius.circular(a.width),
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Colors.white)),
                                  child: initInfoFinish
                                      ? ClipRRect(
                                          child: CachedNetworkImage(
                                              errorWidget:
                                                  (context, string, odject) {
                                                return Image.asset(
                                                    'assets/userprofile.png',
                                                    fit: BoxFit.cover);
                                              },
                                              imageUrl: img,
                                              fit: BoxFit.cover),
                                          borderRadius: BorderRadius.circular(
                                              a.width / 10),
                                        )
                                      : Icon(Icons.person,
                                          color: Colors.black,
                                          size: a.width / 15),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Profile(
                                              doc: widget
                                                  .doc))); //ไปยังหน้า Profile
                                },
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: AdmobBanner(
                          adUnitId: AdmobService().getBannerAdId(),
                          adSize: AdmobBannerSize.FULL_BANNER),
                    )
                  ],
                ),
              ),
            ),
            // Positioned(
            //     // left: a.width/4.8,
            //     width: a.width,
            //     top: a.height / 7.2,
            //     child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: <Widget>[
            //           SizedBox(
            //             width: 1,
            //           ),
            //           scrapLeft(a),
            //           SizedBox(
            //             width: 1,
            //           )
            //         ])),
          ],
        ),
      ),
    );
  }

  Widget scrapLeft(Size scr) {
    Size a = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Users')
          .document(widget.doc['uid'])
          .collection('info')
          .document(widget.doc['uid'])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.active) {
          scraps = 15 - (snapshot?.data['scraps']?.length ?? 0);
          return InkWell(
            child: Container(
              margin: EdgeInsets.only(left: a.width / 20, right: a.width / 20),
              padding: EdgeInsets.fromLTRB(scr.width / 24, scr.width / 36,
                  scr.width / 24, scr.width / 36),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6.0,
                      spreadRadius: 3.0,
                      offset: Offset(
                        0.0,
                        3.2,
                      ),
                    )
                  ],
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(scr.width / 14.2)),
              child: scraps < 1
                  ? Text(
                      'กระดาษของคุณหมดแล้ว',
                      style: TextStyle(
                        fontSize: scr.width / 18,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: scr.width / 18,
                                color: Colors.white,
                                fontFamily: 'ThaiSans'),
                            children: <TextSpan>[
                              TextSpan(text: ' เหลือกระดาษ '),
                              TextSpan(
                                  text: '$scraps',
                                  style: TextStyle(
                                      fontSize: scr.width / 16,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: ' แผ่น',
                              )
                            ],
                          ),
                        )
                      ],
                    ),
            ),
            //00
            onTap: () {
              scraps == 15
                  ? toast('กระดาษของคุณยังเต็มอยู่')
                  : scrapReseter(snapshot?.data, snapshot.data['lastReset']);
            },
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  scrapReseter(DocumentSnapshot data, String lastReset) async {
    DateTime now = DateTime.now();
    String date = "20/04/1520";
    lastReset == date
        ? toast('คุณขอรับกระดาษได้แค่ 1 ครั้ง ต่อวัน')
        : warnClear(data);
  }

  warnClear(DocumentSnapshot data) {
    bool loading = false;
    showDialog(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Stack(
              children: <Widget>[
                AlertDialog(
                  backgroundColor: Colors.white,
                  title: Text('คุณต้องขอกระดาษใหม่ใช่หรือไม่'),
                  content: Text(
                      'หลังจากขอกระดาษใหม่กระดาษที่คุณทิ้งไว้จะหายไปทั้งหมด'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('ยกเลิก'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text('ขอกระดาษใหม่'),
                      onPressed: () async {
                        InterstitialAd(adUnitId: AdmobService().getVideoAdId())..load()..show();
                        setState(() => loading = true);
                        await scrap.resetScrap(
                            data['scraps'], widget.doc['uid']);
                        setState(() => loading = false);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                loading ? Loading() : SizedBox()
              ],
            );
          });
        });
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

  Widget gpsCheck(Size a, String text) {
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
                  text,
                  style: TextStyle(fontSize: a.width / 16, color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }

  void dialog() {
    DateTime now = DateTime.now();
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
                                    //ออกจาก��น้านี้
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
                              //ส่ว��ข���งกระดาษที่เขีย���
                              Container(
                                margin: EdgeInsets.only(top: a.width / 150),
                                width: a.width / 1,
                                height: a.height / 1.8,
                                //ทำเป���น�������ั้นๆ
                                child: Stack(
                                  children: <Widget>[
                                    //ช������้นที่ 1 ส่วนของก���ะดาษ
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
                                          Text(
                                              now.minute < 10
                                                  ? 'เวลา: ${now.hour}:0${now.minute}'
                                                  : 'เวลา: ${now.hour}:${now.minute}',
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
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 25, right: 25),
                                        width: a.width,
                                        child: TextFormField(
                                          maxLength: 250,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              height: 1.35,
                                              fontSize: a.width / 14),
                                          maxLines: null,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            counterText: "",
                                            counterStyle: TextStyle(
                                                color: Colors.transparent),
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
                                          //เนื้อหาท��่กรอกเข้าไปใน text
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
                                          await scrap.binScrap(
                                              text, public, widget.doc);
                                        }
                                      },
                                    ),
                                    public == null || !public
                                        ? SizedBox()
                                        : InkWell(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: a.width / 20),
                                              width: a.width / 4.5,
                                              height: a.width / 8,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          a.width)),
                                              alignment: Alignment.center,
                                              child: Text("ปาใส่",
                                                  style: TextStyle(
                                                      fontSize: a.width / 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            //ให้ dialog แรกหายไปก่อนแล้วเปิด dialog2
                                            onTap: () {
                                              if (_key.currentState
                                                  .validate()) {
                                                _key.currentState.save();

                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FriendList(
                                                        doc: widget.doc,
                                                        data: {'text': text},
                                                      ),
                                                    ));
                                              }
                                            })
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

  checkScrap() async {
    await Firestore.instance
        .collection('Users')
        .document(widget.doc['uid'])
        .collection('info')
        .document(widget.doc['uid'])
        .get()
        .then((dat) async {
      int scraps = dat.data['scraps']?.length ?? 0;
      if (scraps < 15) {
        toast('คุณได้ทิ้งกระดาษไว้แล้ว');
        Navigator.pop(context);
        await scrap.binScrap(text, public, widget.doc);
      } else {
        toast('กระดาษคุณหมดแล้ว');
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
}
