import 'dart:async';
import 'dart:wasm';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrap/Page/authentication/LoginPage.dart';
import 'package:scrap/function/aboutUser/ReportApp.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/LoadNoBlur.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/guide.dart';
import 'package:scrap/widget/wrap.dart';
import 'package:scrap/widget/ScreenUtil.dart';

//textfield popup
void showPopup(BuildContext context) {
  int _charCount = 0;

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter a) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: screenHeightDp / 2,
                  width: screenWidthDp / 1.1,
                  /*   decoration: BoxDecoration(
                    //  color: Color(0xff1a1a1a),
                    /* color: Colors.black,
                  borderRadius: BorderRadius.circular(5),*/
                    ),*/
                  child: Container(
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      resizeToAvoidBottomPadding: false,
                      body: Container(
                        width: screenWidthDp,
                        height: appBarHeight * 3.65,
                        decoration: BoxDecoration(
                            color: Color(0xff1a1a1a),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '\t\tเพิ่มสเตตัส',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: s52,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(right: appBarHeight / 10),
                                  child: GestureDetector(
                                      child: Container(
                                        height: appBarHeight / 2.8,
                                        width: appBarHeight / 2.8,
                                        decoration: BoxDecoration(
                                            color: Color(0xfff000000),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(appBarHeight))),
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.blue,
                                          size: s42,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      }),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: appBarHeight / 7,
                            ),
                            Divider(
                              height: 1.0,
                              color: Color(0xff222222),
                            ),
                            SizedBox(
                              height: appBarHeight / 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  // color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0))),
                              child: TextField(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: s48,
                                ),
                                minLines: 4,
                                maxLines: 4,
                                maxLength: 60,
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: Color(0xff222222),
                                  border: InputBorder.none,
                                  alignLabelWithHint: true,
                                  hintText: 'เขียนข้อความของคุณ',
                                  hintStyle: TextStyle(
                                    fontSize: s48,
                                    height: 0.08,
                                    color: Color(0xffA2A2A2).withOpacity(0.43),
                                    //color: AppColors.textFieldInput
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Colors.black12,
                                    ),
                                  ),
                                ),
                                onChanged: (String value) {
                                  a(() {
                                    _charCount = value.length;
                                    print(_charCount);
                                  });
                                },
                              ),
                              width: appBarHeight * 4.2,
                              height: appBarHeight * 2.3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  width: screenWidthDp / 5,
                                  height: appBarHeight / 2.3,
                                  decoration: BoxDecoration(
                                      color: Color(0xff000000),
                                      borderRadius: BorderRadius.circular(
                                          screenHeightDp)),
                                  child: Center(
                                    child: Text(
                                      ' ' + _charCount.toString() + '\t/\t60 ',
                                      style: TextStyle(
                                        color: Colors.white30,
                                        fontSize: s42,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: appBarHeight,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        appBarHeight / 3,
                                        appBarHeight / 25,
                                        appBarHeight / 3,
                                        appBarHeight / 25),
                                    decoration: BoxDecoration(
                                        color: Color(0xfff26A4FF),
                                        borderRadius: BorderRadius.circular(
                                            screenHeightDp)),
                                    child: Center(
                                      child: Text(
                                        'เพิ่ม',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                          fontSize: s48,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
      });
}

//การตั้งค่า
class OptionSetting extends StatefulWidget {
  @override
  _OptionSettingState createState() => _OptionSettingState();
}

class _OptionSettingState extends State<OptionSetting> {
  StreamSubscription loadStatus;
  bool loading = false;

  @override
  void initState() {
    loadStatus =
        authService.loading.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    loadStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      //resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      appbarOptionSetting(context),
                      SizedBox(height: appBarHeight / 8),
                      list_OptionSetting(context, Icons.face,
                          ' จัดการบัญชีของฉัน', Manage_MyProfile()),
                      list_OptionSetting(context, Icons.history,
                          ' ประวัติการเขียนสแครป', HistoryScrap()),
                      list_OptionSetting(context, Icons.description,
                          ' ข้อกำหนดการให้บริการ', ComingSoon()),
                      list_OptionSetting(context, Icons.extension,
                          ' อธิบายฟีเจอร์', ComingSoon()),
                      list_OptionSetting(context, Icons.markunread,
                          ' สารจากผู้พัฒนา', ComingSoon()),
                      list_OptionSetting(context, Icons.bug_report,
                          ' แจ้งปัญหาระบบ', ReportToScrap_MyProfile()),
                      list_OptionSetting(context, Icons.block,
                          ' ประวัติการบล็อค', BlockUser_MyProfile()),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ComingSoon()));
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: appBarHeight / 10),
                          /*   margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          //vertical: 5,
                        ),*/
                          margin: EdgeInsets.only(
                              left: appBarHeight / 100,
                              bottom: appBarHeight / 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      width: appBarHeight / 1.8,
                                      child: Image.asset(
                                        'assets/bualoi.png',
                                        scale: 5,
                                      )),
                                  Text(
                                    'เกี่ยวกับ Bualoitech Co.,Ltd.',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: s52),
                                  )
                                ],
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(right: appBarHeight) / 5,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: s42,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      //ออกจากระบบ
                      GestureDetector(
                        child: Container(
                            padding: EdgeInsets.only(left: appBarHeight / 10),
                            margin: EdgeInsets.only(
                                left: appBarHeight / 100,
                                bottom: appBarHeight / 4),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: appBarHeight / 1.5,
                                          child: Icon(
                                            Icons.exit_to_app,
                                            color: Colors.white,
                                            size: s60,
                                          ),
                                        ),
                                        Text(
                                          'ออกจากระบบ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: s52),
                                        )
                                      ])
                                ])),
                        onTap: () {
                          authService.signOut(context);
                        },
                      ),
                    ],
                  ),
                  /* SizedBox(
                  height: appBarHeight * 1,
                ),*/
                  Column(
                    children: [
                      SizedBox(
                        height: appBarHeight / 3,
                      ),
                      GestureDetector(
                        child: ClipRRect(
                          child: Image.asset(
                            'assets/scrapbig.png',
                            scale: appBarHeight / 5,
                          ),
                        ),
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                      ),
                      Text(
                        'version 2.0.1\n\n',
                        style: TextStyle(color: Colors.white, fontSize: s42),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            loading ? Loading() : SizedBox()
          ],
        ),
      ),
    );
  }
}

Widget appbarOptionSetting(BuildContext context) {
  return Container(
    height: appBarHeight / 1.42,
    width: screenWidthDp,
    color: Colors.black,
    /* padding: EdgeInsets.symmetric(
        horizontal: screenWidthDp / 21,
      ),*/
    /*padding: EdgeInsets.symmetric(
        horizontal: screenWidthDp / 21,
      ),*/
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
  ) /*Container(
    height: appBarHeight / 1.35,
    width: screenWidthDp,
    /* margin: EdgeInsets.symmetric(
      horizontal: screenWidthDp / 100,
    ),*/
    //padding: EdgeInsets.only(top: appBarHeight / 1.35),
    margin: EdgeInsets.symmetric(
      horizontal: screenWidthDp / 21,
    ),
    // EdgeInsets.only(left: screenWidthDp / 100, bottom: appBarHeight / 2.5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: s60,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        Text(
          'การตั้งค่า',
          style: TextStyle(
            fontSize: s52,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.more_horiz,
            //color: Colors.white,
          ),
          onPressed: null,
        ),
      ],
    ),
  )*/
      ;
}

// list_OptionSetting เป็น Widget ที่แสดงลิสต์ต่างๆในการตั้งค่า
// (context , ชื่อicon, ชื่อการตั้งค่า, หน้าstatefulที่หลังจากกด)
//  หน้า stateful บางหน้าที่เป็น web view จะเชื่อมต่อไปหน้า stateful ที่ชื่อ ComingSoon()
Widget list_OptionSetting(context, icon, name, stateful) {
  return FlatButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => stateful));
      },
      child: Container(
        /* margin: EdgeInsets.symmetric(
          //horizontal: 10,
          vertical: 5,

        ),*/
        margin:
            EdgeInsets.only(left: appBarHeight / 100, bottom: appBarHeight / 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: s60,
                ),
                Text(
                  name,
                  style: TextStyle(color: Colors.white, fontSize: s52),
                )
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: s42,
            )
          ],
        ),
      ));
}

// Appbar ในหน้า statefulต่างๆ ที่หลังจากกด
Widget appbar_ListOptionSetting(BuildContext context, icon, name) {
  return Container(
    height: appBarHeight / 1.42,
    width: screenWidthDp,
    /* margin: EdgeInsets.symmetric(
      horizontal: screenWidthDp / 100,
    ),*/
    padding: EdgeInsets.symmetric(
      horizontal: screenWidthDp / 21,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: s60,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: s60,
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: s52,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        IconButton(
            icon: Icon(
              Icons.more_horiz,
              //color: Colors.white,
            ),
            onPressed: null),
      ],
    ),
  );
}

//หน้า จัดการบัญชีของฉัน
class Manage_MyProfile extends StatefulWidget {
  @override
  _Manage_MyProfileState createState() => _Manage_MyProfileState();
}

class _Manage_MyProfileState extends State<Manage_MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: [
          Container(
            height: appBarHeight / 2,
          ),
          appbar_ListOptionSetting(context, Icons.face, ' จัดการบัญชีของฉัน'),
          Container(
            margin: EdgeInsets.only(
              bottom: 10,
            ),
            height: screenHeightDp / 5.5,
            width: screenWidthDp / 1.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Color(0xff1a1a1a),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: screenWidthDp / 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: screenWidthDp / 4,
                    width: screenWidthDp / 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(screenHeightDp),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '@naveeharn',
                        style: TextStyle(
                          fontSize: s60,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Join 15/02/2020',
                        style: TextStyle(
                          fontSize: s60,
                          color: Color(0xfff26A4FF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: appBarHeight / 15,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 10,
            ),
            height: screenHeightDp / 3,
            width: screenWidthDp / 1.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Color(0xff1a1a1a),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            child: Text(
                              'เพิ่มสเตตัส',
                              style: TextStyle(
                                fontSize: s48,
                                color: Color(0xfff26A4FF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              showPopup(context);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  height: screenHeightDp / 3.85,
                  margin: EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Color(0xff222222),
                  ),
                  child: Center(
                    child: Text(
                      'ไม่รู้อะไร',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: s42,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 10,
            ),
            height: screenHeightDp / 4.5,
            width: screenWidthDp / 1.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Color(0xff1a1a1a),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'เบอร์โทรศัพท์',
                  style: TextStyle(
                    fontSize: s42,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '044-112-1011',
                  style: TextStyle(
                    fontSize: s65,
                    color: Color(0xfff26A4FF),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: s52,
                    ),
                    Text(
                      ' เปลี่ยนเบอร์โทรศัพท์',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: s42,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: appBarHeight / 9,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: s52,
                    ),
                    Text(
                      ' เปลี่ยนรหัสผ่าน',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: s42,
                        color: Colors.white,
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
  }
}

// หน้า ประวัติการเขียนสแครป
class HistoryScrap extends StatefulWidget {
  @override
  _HistoryScrapState createState() => _HistoryScrapState();
}

class _HistoryScrapState extends State<HistoryScrap> {
  var controller = RefreshController();
  var textGroup = AutoSizeGroup();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isExpired(DocumentSnapshot data) {
    DateTime startTime = data['scrap']['timeStamp'].toDate();
    return DateTime(startTime.year, startTime.month, startTime.day + 1,
            startTime.hour, startTime.second)
        .difference(DateTime.now())
        .isNegative;
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    final user = Provider.of<UserData>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            appbar_ListOptionSetting(
                context, Icons.history, ' ประวัติการเขียนสแครป'),
            Container(
              padding: EdgeInsets.only(top: appBarHeight / 1.35),
              margin: EdgeInsets.symmetric(horizontal: screenWidthDp / 42),
              child: FutureBuilder(
                  future: fireStore
                      .collection(
                          'Users/${user.region}/users/${user.uid}/history')
                      .orderBy('scrap.timeStamp', descending: true)
                      .limit(8)
                      .getDocuments(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List docs = snapshot.data.documents;
                      return StatefulBuilder(
                          builder: (context, StateSetter setList) {
                        return docs.length > 0
                            ? SmartRefresher(
                                enablePullDown: false,
                                enablePullUp: true,
                                controller: controller,
                                onLoading: () async {
                                  if (docs.length > 0) {
                                    var query = await fireStore
                                        .collection(
                                            'Users/${user.region}/users/${user.uid}/history')
                                        .orderBy('scrap.timeStamp',
                                            descending: true)
                                        .startAfterDocument(docs.last)
                                        .limit(8)
                                        .getDocuments();
                                    docs.addAll(query.documents);
                                    query.documents.length > 0
                                        ? setList(
                                            () => controller.loadComplete())
                                        : controller.loadNoData();
                                  } else
                                    controller.loadNoData();
                                },
                                physics: BouncingScrollPhysics(),
                                child: Wrap(
                                    alignment: WrapAlignment.start,
                                    spacing: screenWidthDp / 42,
                                    runSpacing: screenWidthDp / 42,
                                    children:
                                        docs.map((doc) => scrap(doc)).toList()),
                              )
                            : Center(
                                child: guide('ไม่มีประวัติการทิ้ง'),
                              );
                      });
                    } else {
                      return Center(child: LoadNoBlur());
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget scrap(DocumentSnapshot data) {
    return Container(
        height: screenWidthDp / 2.16 * 1.21,
        width: screenWidthDp / 2.16,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/paper-readed.png'),
                fit: BoxFit.cover)),
        child: Stack(children: <Widget>[
          Center(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 64),
            child: AutoSizeText(data['scrap']['text'],
                group: textGroup, style: TextStyle(fontSize: s46)),
          )),
          isExpired(data)
              ? Container(
                  margin: EdgeInsets.all(4),
                  height: screenWidthDp / 2.16 * 1.21,
                  width: screenWidthDp / 2.16,
                  color: Colors.black38,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 50, color: Colors.white),
                        Text('หมดเวลา',
                            style:
                                TextStyle(color: Colors.white, fontSize: s48)),
                      ]))
              : SizedBox()
        ]));
  }

  Widget guide(String text) {
    return Container(
      height: screenHeightDp / 2.4,
      width: screenWidthDp,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/paper.png',
            color: Colors.white60,
            height: screenHeightDp / 10,
          ),
          Text(
            text,
            style: TextStyle(
                fontSize: screenWidthDp / 16,
                color: Colors.white60,
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}

//กระดาษที่หมดเวลาแล้ว
class TimeOut_Paper_Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(4),
          // width: (174/209)*220,//screenWidthDp / 2.2,
          // height: (209/174)*220,//screenHeightDp / 4,
          width: a.width / 2.2,
          height: (a.width / 2.1) * 1.21,
          color: Colors.yellow.shade700,
        ),
        Container(
          margin: EdgeInsets.all(4),
          // width: (174/209)*220,//screenWidthDp / 2.2,
          // height: (209/174)*220,//screenHeightDp / 4,
          width: a.width / 2.2,
          height: (a.width / 2.1) * 1.21,
          color: Colors.black38,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 50,
                color: Colors.white,
              ),
              Text(
                'หมดเวลา',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: s48,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// หน้า แจ้งปัญหาระบบ
class ReportToScrap_MyProfile extends StatefulWidget {
  @override
  _ReportToScrap_MyProfileState createState() =>
      _ReportToScrap_MyProfileState();
}

class _ReportToScrap_MyProfileState extends State<ReportToScrap_MyProfile> {
  String text;
  bool loading = false;
  var key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: appBarHeight / 2,
              ),
              appbar_ListOptionSetting(
                  context, Icons.bug_report, ' แจ้งปัญหาระบบ'),
              SizedBox(
                height: appBarHeight / 3,
              ),
              Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: screenHeightDp / 1.5,
                  width: screenWidthDp / 1.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff202020),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: screenWidthDp / 1.1,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xff383838), width: 1))),
                          child: Text(
                            'ถึงผู้พัฒนา',
                            style:
                                TextStyle(fontSize: s60, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Form(
                            key: key,
                            child: TextFormField(
                              style:
                                  TextStyle(fontSize: s52, color: Colors.white),
                              maxLines: null,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'แจ้งรายละเอียดเกี่ยวกับปัญหา',
                                hintStyle: TextStyle(
                                  fontSize: s54,
                                  height: 0.08,
                                  color: Colors.white30,
                                ),
                              ),
                              validator: (val) {
                                return val.trim() == ''
                                    ? toast.validateToast(
                                        'ไม่อธิบายแล้วเราจะรู้ได้ยังไง')
                                    : null;
                              },
                              onSaved: (val) {
                                final report =
                                    Provider.of<Report>(context, listen: false);
                                report.reportText = val.trim();
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            child: Container(
                              padding: EdgeInsets.only(left: appBarHeight / 15),
                              margin: EdgeInsets.symmetric(
                                horizontal: a.width / 40,
                                vertical: a.width / 40,
                              ),
                              width: a.width / 8,
                              height: a.width / 8,
                              //alignment: Alignment.center,
                              child: Icon(
                                Icons.send,
                                color: Color(0xff26A4FF),
                                size: s60 * 0.8,
                              ),

                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(a.width)),
                            ),
                            onTap: () async {
                              if (key.currentState.validate()) {
                                key.currentState.save();
                                setState(() => loading = true);
                                await reportApp.reportApp(context);
                                setState(() => loading = false);
                                toast.toast('ขอบคุณสำหรับการรายงานปัญหาของคุณ');
                                nav.pop(context);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
          loading ? Loading() : SizedBox()
        ],
      ),
    );
  }
}

// หน้า ประวัติการบล็อค
class BlockUser_MyProfile extends StatefulWidget {
  @override
  _BlockUser_MyProfileState createState() => _BlockUser_MyProfileState();
}

class _BlockUser_MyProfileState extends State<BlockUser_MyProfile> {
  Widget blockUser(username) {
    return Container(
      margin: EdgeInsets.only(
        left: screenWidthDp / 20,
        //top: 5,
        bottom: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenHeightDp),
                ),
              ),
              Text(
                username,
                style: TextStyle(
                  fontSize: s42,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          FlatButton(
            onPressed: () {},
            child: Container(
              width: appBarHeight * 1.2,
              height: appBarHeight / 2.3,
              padding: EdgeInsets.fromLTRB(appBarHeight / 20, appBarHeight / 20,
                  appBarHeight / 120, appBarHeight / 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(screenHeightDp),
              ),
              child: Text(
                'ปลดบล๊อค',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: s42,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                child: appbar_ListOptionSetting(
                    context, Icons.block, ' ประวัติการบล็อค'),
              ),
              Positioned(
                //top: appBarHeight / 1.35,
                child: Container(
                  padding: EdgeInsets.only(top: appBarHeight * 0.9),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      blockUser(' @somename'),
                      blockUser(' @somename'),
                      blockUser(' @somename'),
                      blockUser(' @somename'),
                      blockUser(' @somename'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

// หน้า ComingSoon
class ComingSoon extends StatefulWidget {
  @override
  _ComingSoonState createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: Container(
                //  padding: EdgeInsets.only(top: appBarHeight / 1.35),
                height: appBarHeight / 1.35,
                width: screenWidthDp,
                /*    margin: EdgeInsets.symmetric(
                  horizontal: screenWidthDp / 100,
                ),*/
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                child: Text(
                  'C O M I N G S O O N',
                  style: TextStyle(fontSize: s70, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
