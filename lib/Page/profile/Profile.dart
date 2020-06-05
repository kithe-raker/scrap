import 'dart:io';
import 'dart:ui';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrap/function/aboutUser/SettingFunction.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/profile/OptionSetting_My_Profile.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrap/widget/dialog/ScrapDialog.dart';
import 'package:scrap/widget/footer.dart';
import 'package:scrap/widget/peoplethrowpaper.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool initInfoFinish = false, initScrapFinish = false;
  bool pickedScrap = true;
  Map profile = {};
  List readScrap = [];
  List<DocumentSnapshot> pickScrap = [], scrapCrate = [];
  int page = 0;
  var refreshController = RefreshController();
  var textGroup = AutoSizeGroup();
  var controller = PageController();

  //Appbar สำหรับหน้าโปรไฟล์ของฉัน
  Widget appbarProfile(BuildContext context) {
    return Container(
      height: appBarHeight / 1.42,
      width: screenWidthDp,
      color: Colors.black,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidthDp / 21,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
              child: Icon(Icons.arrow_back, color: Colors.white, size: s60),
              onTap: () {
                Navigator.pop(context);
              }),
          GestureDetector(
              child: Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: s65,
              ),
              onTap: () {
                //showButtonSheet(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OptionSetting()));
              }),
        ],
      ),
    );
  }

  Timestamp yesterDay() {
    var now = DateTime.now();
    return Timestamp.fromDate(
        DateTime(now.year, now.month, now.day - 1, now.hour, now.minute));
  }

  @override
  void initState() {
    initUser();
    initScraps();
    super.initState();
  }

  Future<void> initUser() async {
    var data = await userinfo.readContents();
    var read = await cacheHistory.getReadScrap();
    readScrap.addAll(read);
    profile = data;
    setState(() => initInfoFinish = true);
  }

  initScraps() async {
    final user = Provider.of<UserData>(context, listen: false);
    var ref =
        fireStore.collection('Users/${user.region}/users').document(user.uid);
    var scrapCollection = await ref
        .collection('scrapCollection')
        .orderBy('timeStamp', descending: true)
        .limit(2)
        .getDocuments();
    var scrapCrates = await ref
        .collection('thrownScraps')
        .where('pick', isEqualTo: true)
        .orderBy('timeStamp', descending: true)
        .limit(2)
        .getDocuments();
    pickScrap.addAll(scrapCollection.documents);
    scrapCrate.addAll(scrapCrates.documents);
    setState(() => initScrapFinish = true);
  }

  @override
  void dispose() {
    controller.dispose();
    refreshController.dispose();
    super.dispose();
  }

  Stream<Event> streamTransaction(String uid, String field) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    return userDb.reference().child('users/$uid/$field').onValue;
  }

  Future<DataSnapshot> futureTransaction(String uid, String field) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    return userDb.reference().child('users/$uid/$field').once();
  }

  //Run
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context, listen: false);
    screenutilInit(context);
    Size a = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: screenHeightDp / 21),
            width: screenWidthDp,
            padding: EdgeInsets.only(top: appBarHeight / 1.35),
            child: SmartRefresher(
              footer: Footer(),
              controller: refreshController,
              enablePullDown: false,
              enablePullUp: true,
              // footer: footerList(),
              onLoading: () async {
                if (pickedScrap
                    ? pickScrap.length > 0
                    : scrapCrate.length > 0) {
                  var ref = pickedScrap
                      ? fireStore
                          .collection(
                              'Users/${user.region}/users/${user.uid}/scrapCollection')
                          .orderBy('timeStamp', descending: true)
                          .startAfterDocument(pickScrap.last)
                      : fireStore
                          .collection(
                              'Users/${user.region}/users/${user.uid}/thrownScraps')
                          .where('pick', isEqualTo: true)
                          .orderBy('timeStamp', descending: true)
                          .startAfterDocument(scrapCrate.last);
                  var docs = await ref.limit(4).getDocuments();
                  pickedScrap
                      ? pickScrap.addAll(docs.documents)
                      : scrapCrate.addAll(docs.documents);
                  docs.documents.length < 1
                      ? refreshController.loadNoData()
                      : refreshController.loadComplete();
                  setState(() {});
                } else
                  refreshController.loadNoData();
              },
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: screenHeightDp / 36),
                  Container(
                    height: screenWidthDp / 3.32,
                    width: screenWidthDp / 3.32,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1.2),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(screenHeightDp),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(screenHeightDp),
                      child: profile['img'] == null
                          ? Image.asset('assets/userprofile.png')
                          : Image.file(File(profile['img']), fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: appBarHeight / 5),
                  Text(
                    '@${profile['id'] ?? 'ชื่อ'}',
                    style: TextStyle(color: Colors.white, fontSize: s60),
                  ),
                  SizedBox(
                    height: appBarHeight / 10,
                  ),
                  Container(
                      child: user.uid == null
                          ? null
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                dataProfile('เก็บไว้', user.uid, field: 'pick'),
                                dataProfile('แอทเทนชัน', user.uid,
                                    field: 'att'),
                                dataProfile('โดนปาใส่', user.uid,
                                    field: 'thrown'),
                              ],
                            )),
                  SizedBox(height: screenHeightDp / 24),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: screenWidthDp / 8.1),
                    child: Text(
                      '${profile['status'] ?? 'สเตตัสของคุณ'}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: s48,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  SizedBox(height: screenHeightDp / 24),
                  Container(
                    child: Column(
                      children: <Widget>[
                        StreamBuilder(
                            stream: fireStore
                                .collection(
                                    'Users/${user.region}/users/${user.uid}/thrownScraps')
                                .orderBy('scrap.timeStamp', descending: true)
                                .where('scrap.timeStamp',
                                    isGreaterThan: yesterDay())
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List recentScraps = snapshot.data.documents;
                                return Column(children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: screenWidthDp / 30),
                                    padding: EdgeInsets.only(
                                        left: a.width / 50,
                                        right: a.width / 50),
                                    /*  margin: EdgeInsets.only(
                                        left: a.width / 25,
                                        right: a.width / 25),*/
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                              recentScraps.length > 0
                                                  ? 'โดนปาใส่ล่าสุด ${recentScraps.length} ก้อน'
                                                  : 'ไม่มีกระดาษที่ปามา',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: s60)),
                                          switchThrow(user.uid)
                                        ]),
                                  ),
                                  recentlyThrown(recentScraps)
                                ]);
                              } else {
                                return SizedBox(
                                    height: screenWidthDp / 8.1,
                                    child: Center(
                                        child: CircularProgressIndicator()));
                              }
                            }),
                        SizedBox(height: 7.2),
                        Divider(color: Colors.grey),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  height: appBarHeight / 2,
                                  decoration: BoxDecoration(
                                    border: pickedScrap
                                        ? Border(
                                            bottom: BorderSide(
                                                width: 2.0,
                                                color: Colors.white),
                                          )
                                        : null,
                                  ),
                                  child: Text(
                                    'เก็บจากที่ทิ้งไว้',
                                    style: TextStyle(
                                        fontSize: s48,
                                        color: Colors.white,
                                        fontWeight: pickedScrap
                                            ? FontWeight.bold
                                            : null),
                                  ),
                                ),
                                onTap: () {
                                  pickedScrap = true;
                                  setState(() {});
                                },
                              ),
                              GestureDetector(
                                  onTap: () {
                                    pickedScrap = false;
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: appBarHeight / 2,
                                    decoration: BoxDecoration(
                                        border: pickedScrap
                                            ? null
                                            : Border(
                                                bottom: BorderSide(
                                                    width: 2.0,
                                                    color: Colors.white))),
                                    child: Text('เก็บจากโดนปาใส่',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: s48,
                                            fontWeight: pickedScrap
                                                ? null
                                                : FontWeight.bold)),
                                  ))
                            ]),
                        Divider(color: Colors.grey, height: 0),
                        SizedBox(height: screenWidthDp / 36),
                        initScrapFinish
                            ? scrapGrid(pickedScrap ? pickScrap : scrapCrate)
                            : Container(
                                height: screenHeightDp / 8,
                                child:
                                    Center(child: CircularProgressIndicator())),
                        SizedBox(height: screenWidthDp / 42),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(top: 0, child: appbarProfile(context)),
          initInfoFinish ? SizedBox() : Loading(),
          Positioned(
            bottom: 0,
            child: Container(
              child: AdmobBanner(
                  adUnitId: AdmobService().getBannerAdId(),
                  adSize: AdmobBannerSize.FULL_BANNER),
            ),
          )
          // adsContainer(),
        ],
      )),
    );
  }

  Widget footerList() {
    return CustomFooter(builder: (BuildContext context, LoadStatus mode) {
      switch (mode) {
        case LoadStatus.loading:
          return Center(child: CircularProgressIndicator());
          break;
        default:
          return SizedBox();
          break;
      }
    });
  }

  void showDialogReport(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 32,
                      width: 32,
                      margin: EdgeInsets.symmetric(
                        horizontal: (screenWidthDp - (screenWidthDp / 1.1)) / 2,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          color: Color(0xffffffff)),
                      child: Icon(
                        Icons.close,
                        color: Colors.blue,
                        size: s48,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: screenHeightDp / 1.7,
                width: screenWidthDp / 1.1,
                decoration: BoxDecoration(
                  color: Color(0xff1a1a1a),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: screenWidthDp / 50,
                      ),
                      child: Scaffold(
                        backgroundColor: Color(0xff1a1a1a),
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Center(
                                child: Report_DropDownButton(),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: TextField(
                                  style: TextStyle(
                                      fontSize: s25, color: Colors.white),
                                  minLines: 17,
                                  maxLines: 17,
                                  decoration: InputDecoration(
                                    // fillColor: Colors.redAccent,
                                    // filled: true,
                                    border: InputBorder.none,
                                    hintText: 'รายงานเจ้าของสแครปรายนี้',
                                    hintStyle: TextStyle(
                                      fontSize: s54,
                                      height: 0.08,
                                      color: Colors.white30,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Positioned(
                                    top: a.width / 0.95,
                                    right: 0,
                                    //bottom: a.height / 10,
                                    // right: 0,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: a.width / 25,
                                        vertical: a.width / 40,
                                      ),
                                      width: a.width / 8,
                                      height: a.width / 8,
                                      alignment: Alignment.center,
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.send,
                                            color: Color(0xff26A4FF),
                                          ),
                                          onPressed: () {}),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(a.width)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: screenHeightDp / 18,
                      ),
                      child: Divider(
                        color: Color(0xff383838),
                        thickness: 2,
                        indent: 5,
                        endIndent: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget recentlyThrown(List docs) {
    Size a = MediaQuery.of(context).size;
    return Container(
      height: screenHeightDp / 10,
      width: screenWidthDp,
      child: docs.length > 0
          ? Container(
              padding: EdgeInsets.only(left: a.width / 25),
              child: ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: docs
                      .map((data) =>
                          scrapPaper(readScrap.contains(data.documentID), data))
                      .toList()),
            )
          : Center(
              child: Text('คุณไม่มีกระดาษที่ปามา',
                  style: TextStyle(color: Colors.white60, fontSize: s46)),
            ),
    );
  }

  Widget switchThrow(String uid) {
    return FutureBuilder(
        future: futureTransaction(uid, 'allowThrow'),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            bool isSwitched = snapshot.data.value;
            return Transform.scale(
                scale: 1.3,
                child: Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      if (value == false)
                        Fluttertoast.showToast(msg: 'ปิดการโดนปาใส่แล้ว');
                      else
                        Fluttertoast.showToast(msg: 'เปิดการโดนปาใส่แล้ว');
                      setting.setAllowThrow(context, value);
                      setState(() {
                        isSwitched = value;
                      });
                    },
                    inactiveTrackColor: Colors.grey,
                    activeTrackColor: Colors.blue,
                    activeColor: Colors.white));
          } else {
            return SizedBox();
          }
        });
  }

  Widget scrapGrid(List<DocumentSnapshot> scraps) {
    return Container(
      child: scraps.length > 0
          ? Wrap(
              spacing: screenWidthDp / 42,
              runSpacing: screenWidthDp / 42,
              alignment: WrapAlignment.start,
              children: scraps.map((doc) => scrap(doc)).toList())
          : Container(
              height: screenHeightDp / 8,
              child: Center(
                child: Text('ไม่มีกระดาษที่คุณเก็บไว้',
                    style: TextStyle(color: Colors.white60, fontSize: s46)),
              ),
            ),
    );
  }

  Widget scrap(DocumentSnapshot data) {
    return GestureDetector(
      child: Container(
          height: screenWidthDp / 2.16 * 1.21,
          width: screenWidthDp / 2.16,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/paperscrap.jpg'),
                  fit: BoxFit.cover)),
          child: Stack(children: <Widget>[
            Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 64),
              child: AutoSizeText(data['scrap']['text'],
                  textAlign: TextAlign.center,
                  group: textGroup,
                  style: TextStyle(fontSize: s46)),
            )),
          ])),
      onTap: () async {
        await showDialog(
            context: context,
            builder: (BuildContext context) => pickedScrap
                ? ScrapDialog(
                    data: data,
                    self: true,
                    showTransaction: false,
                    currentList: pickScrap)
                : Paperstranger(
                    scrap: data,
                    self: true,
                    picked: true,
                    isHistory: true,
                    currentList: scrapCrate));
        setState(() {});
      },
    );
  }

  Widget checkValue(trans) {
    // < K
    if (trans < 1000 && trans >= 0) {
      return Container(
        child: Text(
          '${trans.floor()}',
          style: TextStyle(
              color: Colors.white,
              fontSize: s70 * 1.2,
              fontWeight: FontWeight.bold),
        ),
      );
    }
    // K <= value < M
    else if (trans < 10000) {
      return Container(
        child: Text(
          '${(trans / 1000).toStringAsFixed(2)}K',
          style: TextStyle(
              color: Colors.white,
              fontSize: s70 * 1.2,
              fontWeight: FontWeight.bold),
        ),
      );
    }
    // 10K
    else if (trans < 100000) {
      return Container(
        child: Text(
          '${(trans / 1000).toStringAsFixed(1)}K',
          style: TextStyle(
              color: Colors.white,
              fontSize: s70 * 1.2,
              fontWeight: FontWeight.bold),
        ),
      );
    } else if (trans < 1000000) {
      return Container(
        child: Text(
          '${(trans ~/ 1000)}K',
          style: TextStyle(
              color: Colors.white,
              fontSize: s70 * 1.2,
              fontWeight: FontWeight.bold),
        ),
      );
    }
    // >= M
    else {
      return Container(
        child: Text(
          '${(trans / 1000000).toStringAsFixed(2)}M',
          style: TextStyle(
              color: Colors.white,
              fontSize: s70 * 1.2,
              fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  //ข้อมูลผู้ใช้
//name = [เก็บไว้, คนให้ความสนใจ, โดนปาใส่]
  Widget dataProfile(String name, String uid, {@required String field}) {
    return SizedBox(
      width: screenWidthDp / 5.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          StreamBuilder(
              stream: streamTransaction(uid, field),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var trans = snapshot.data.snapshot.value;
                  return Container(
                      height: screenWidthDp / 6,
                      child: checkValue(trans.abs()));
                } else {
                  return Text(
                    '0',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: s70 * 1.2,
                        fontWeight: FontWeight.bold),
                  );
                }
              }),
          Container(
            child: Text(
              name,
              style: TextStyle(
                height: 0.21,
                color: Color(0xfff727272),
                fontWeight: FontWeight.bold,
                fontSize: s36,
              ),
            ),
          ),
        ],
      ),
    );
  }

//ก้อนกระดาษ
  Widget scrapPaper(bool read, DocumentSnapshot data) {
    return GestureDetector(
        child: Transform.scale(
          scale: 1.1,
          child: Opacity(
            opacity: read ? 0.6 : 1,
            child: Container(
              width: screenWidthDp / 5.5,
              child: SvgPicture.asset('assets/paper.svg',
                  // color: Colors.white60,
                  height: screenWidthDp / 3.2,
                  fit: BoxFit.contain),
            ),
          ),
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext contwxt) =>
                  Paperstranger(scrap: data, self: true));
          if (!read) {
            cacheHistory.addReadScrap(data);
            readScrap.add(data.documentID);
            setState(() {});
          }
        });
  }
}

//โฆษณา Google Ads แสดงด้านล่างสุดของหน้าจอ
Widget adsContainer() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      Container(
        height: appBarHeight,
        width: screenWidthDp,
        color: Colors.grey,
        child: Center(
          child: Text(
            'Google ADS',
            style: TextStyle(fontSize: 48, color: Colors.white),
          ),
        ),
      ),
    ],
  );
}

class Report_DropDownButton extends StatefulWidget {
  @override
  _Report_DropDownButtonState createState() => _Report_DropDownButtonState();
}

class _Report_DropDownButtonState extends State<Report_DropDownButton> {
  dynamic dropdownValue = 'กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย  ';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<dynamic>(
        value: dropdownValue,
        // style: TextStyle(
        //   color: Colors.white,
        //   fontSize: s36
        // ),
        // dropdownColor: Color(0xff1a1a1a),
        icon: Icon(Icons.arrow_drop_down),
        iconSize: s60,
        //elevation: 16,
        //style: TextStyle(color: Colors.deepPurple),
        // underline: Container(
        //   height: 2,
        //   color: Colors.deepPurpleAccent,
        // ),
        onChanged: (dynamic newValue) {
          setState(
            () {
              dropdownValue = newValue;

              // if (dropdownValue == ' สาธารณะ') {
              //   private = false;
              // } else if (dropdownValue == ' ส่วนตัว') {
              //   private = true;
              // }
            },
          );
        },
        items: <dynamic>[
          'กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย  ',
          'ส่งข้อความสแปมไปยังผู้ใช้รายอื่น  ',
          'เขียนเนื้อหาที่ส่งเสริมความรุนแรง  ',
          'เขียนเนื้อหาที่มีการคุกคามทางเพศ  ',
        ].map<DropdownMenuItem<dynamic>>((dynamic value) {
          if (value == 'กล่าวอ้างถึงบุคคลที่สามในทางเสียหาย  ') {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: s54,
                  color: Colors.white,
                ),
              ),
            );
          } else if (value == 'ส่งข้อความสแปมไปยังผู้ใช้รายอื่น  ') {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: s54,
                  color: Colors.white,
                ),
              ),
            );
          } else if (value == 'เขียนเนื้อหาที่ส่งเสริมความรุนแรง  ') {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: s54,
                  color: Colors.white,
                ),
              ),
            );
          } else if (value == 'เขียนเนื้อหาที่มีการคุกคามทางเพศ  ') {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: s54,
                  color: Colors.white,
                ),
              ),
            );
          } else {}
        }).toList(),
      ),
    );
  }
}
