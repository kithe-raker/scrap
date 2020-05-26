import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrap/Page/setting/blockingList.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/FriendsCache.dart';
import 'package:scrap/function/follows/FollowsFunction.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Ads.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/block.dart';
import 'package:scrap/widget/thrown.dart';
import 'package:scrap/widget/wrap.dart';

bool value = false, pickedScrap = false;
/*
List Problem
- Text ก่อน wrap() ไม่อยู่ตรงกลาง ( control+F => ยุบพรรคอนาโค้งใหม่ )
- wrap() : ต้องเปลี่ยนเป็น "ตารางสแครปยอดนิยมและจากคนที่เราติดตาม" ตามใน XD
*/

// หน้า Profile ของคนอื่น
class Other_Profile extends StatefulWidget {
  final Map data;
  final String uid;
  final String ref;
  Other_Profile({@required this.data, this.uid, this.ref});
  @override
  _Other_ProfileState createState() => _Other_ProfileState();
}

class _Other_ProfileState extends State<Other_Profile> {
  int page = 0;
  String uid;
  List followList = [], pickScraps = [];
  bool loading = true;
  var refreshController = RefreshController();
  var controller = PageController();

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

  @override
  void initState() {
    initList();
    super.initState();
  }

  Future<void> initList() async {
    followList = await cacheFriends.getFollowing();
    uid = widget.uid;
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context, listen: false);
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: appBarHeight / 1.35),
              child: SingleChildScrollView(
                // controller: refreshController,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: screenWidthDp / 3,
                      width: screenWidthDp / 3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(screenHeightDp),
                          image: DecorationImage(
                              image: NetworkImage(widget.data['img']),
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(height: appBarHeight / 5),
                    Text('@${widget.data['id']}',
                        style: TextStyle(color: Colors.white, fontSize: s60)),
                    SizedBox(height: appBarHeight / 10),
                    Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                          dataProfile('เก็บไว้', uid, field: 'pick'),
                          dataProfile('แอทเทนชัน', uid, field: 'att'),
                          dataProfile('โดนปาใส่', uid, field: 'thrown'),
                        ])),
                    Container(height: screenHeightDp / 100),
                    SizedBox(height: appBarHeight / 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[followButton(), throwButton()]),
                    Container(height: screenHeightDp / 40),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidthDp / 30),
                      child: Text('${widget.data['status'] ?? ''}',
                          style: TextStyle(color: Colors.white, fontSize: s40),
                          textAlign: TextAlign.center),
                    ),
                    Container(height: screenHeightDp / 40),
                    Divider(color: Colors.grey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            pickedScrap = true;
                            setState(() {});
                          },
                          child: Container(
                            height: appBarHeight / 2,
                            decoration: BoxDecoration(
                              border: pickedScrap
                                  ? Border(
                                      bottom: BorderSide(
                                          width: 2.0, color: Colors.white),
                                    )
                                  : null,
                            ),
                            child: Text(
                              'เก็บจากที่ทิ้งไว้',
                              style: TextStyle(
                                  fontSize: s48,
                                  color: Colors.white,
                                  fontWeight:
                                      pickedScrap ? FontWeight.bold : null),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            pickedScrap = false;
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: pickedScrap
                                    ? null
                                    : Border(
                                        bottom: BorderSide(
                                            width: 2.0, color: Colors.white))),
                            child: Text(
                              'เก็บจากโดนปาใส่',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: s48,
                                  fontWeight:
                                      pickedScrap ? null : FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey, height: 0),
                    SizedBox(height: screenWidthDp / 36),
                    scrapGrid()
                  ],
                ),
              ),
            ),
            Positioned(
                top: 0,
                child: Container(
                  child: appbar_OtherProfile(context),
                )),
            Positioned(
                bottom: 0,
                child: Container(
                  child: Ads(),
                )),
          ],
        ),
      ),
    );
  }

  Widget followButton() {
    return StatefulBuilder(builder: (context, StateSetter setButton) {
      return GestureDetector(
          child: Container(
            padding: EdgeInsets.fromLTRB(appBarHeight / 3, appBarHeight / 50,
                appBarHeight / 3, appBarHeight / 50),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xfff26A4FF)),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              followList.contains(uid) ? 'กำลังติดตาม' : 'ติดตาม',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xfff26A4FF),
                  fontSize: s52),
            ),
          ),
          onTap: () {
            if (followList.contains(uid)) {
              followFunc.unFollowUser(context,
                  otherUid: uid,
                  otherCollRef: widget.ref ?? widget.data['ref'],
                  followingCounts: followList.length);
              followList.remove(uid);
              setButton(() {});
            } else {
              followFunc.followUser(context,
                  otherUid: uid,
                  otherCollRef: widget.ref ?? widget.data['ref'],
                  followingCounts: followList.length);
              followList.add(uid);
              setButton(() {});
            }
          });
    });
  }

  Widget throwButton() {
    final user = Provider.of<UserData>(context, listen: false);
    return FutureBuilder(
        future: futureTransaction(uid, 'allowThrow'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.value ?? false
                ? Container(
                    child: GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(left: appBarHeight / 6),
                          width: appBarHeight * 1.55,
                          padding: EdgeInsets.fromLTRB(
                              appBarHeight / 5,
                              appBarHeight / 50,
                              appBarHeight / 5,
                              appBarHeight / 50),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'ปาสแครป',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xfff26A4FF),
                              fontSize: s52,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          user.papers > 0
                              ? writerScrap(context,
                                  isThrow: true,
                                  thrownUID: uid,
                                  ref: widget.ref)
                              : toast.toast('กระดาษคุณหมดแล้ว');
                        }))
                : SizedBox();
          } else {
            return SizedBox();
          }
        });
  }

  // Appbar สำหรับ หน้า Profile ของคนอื่น
  Widget appbar_OtherProfile(BuildContext context) {
    return Container(
      height: appBarHeight / 1.35,
      width: screenWidthDp,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidthDp / 21,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
              child: Icon(Icons.arrow_back, color: Colors.white, size: s54),
              onTap: () {
                nav.pop(context);
              }),
          GestureDetector(
              child: Icon(Icons.more_horiz, color: Colors.white, size: s54),
              onTap: () {
                showButtonSheet(context);
              }),
        ],
      ),
    );
  }

  Widget followed() {
    return Container(
      child: GestureDetector(
        onTap: () {},
        //color: Colors.grey,
        child: Container(
          padding: EdgeInsets.fromLTRB(appBarHeight / 3, appBarHeight / 50,
              appBarHeight / 3, appBarHeight / 50),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xfff26A4FF)),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            'ติดตาม',
            style: TextStyle(
              color: Colors.white,
              fontSize: s40,
            ),
          ),
        ),
      ),
    );
  }

  Widget scrapGrid() {
    return Container(
        margin: EdgeInsets.only(bottom: screenHeightDp / 10),
        child: Wrap(
            spacing: screenWidthDp / 42,
            runSpacing: screenWidthDp / 42,
            alignment: WrapAlignment.start,
            children: <Widget>[
              Block(),
              Block(),
              Block(),
              Block(),
              Block(),
            ]));
  }

  Widget dataProfile(String name, String uid, {@required String field}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        StreamBuilder(
            stream: streamTransaction(uid, field),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var trans = snapshot.data.snapshot.value;
                return Text(
                  '$trans',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: s70 * 1.2,
                      fontWeight: FontWeight.bold),
                );
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
    );
  }
}

// void bottomSheet ใช้กับ icon_horiz
void showButtonSheet(context) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: appBarHeight * 3.4,
          decoration: BoxDecoration(
            color: Color(0xff202020),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 12, bottom: 4),
                    width: screenWidthDp / 3.2,
                    height: screenHeightDp / 81,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenHeightDp / 42),
                      color: Color(0xff929292),
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(
                  bottom: appBarHeight - 20,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Container(
                                height: 50,
                                width: 50,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(screenHeightDp)),
                                child:
                                    Icon(Icons.block, size: appBarHeight / 3)),
                            onTap: () {
                              nav.push(context, BlockingList(uid: null));
                            },
                          ),
                          Text(
                            'บล็อคผู้ใช้',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: s42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(screenHeightDp)),
                            child: IconButton(
                                icon: Icon(
                                  Icons.report_problem,
                                  size: appBarHeight / 3,
                                ),
                                onPressed: null),
                          ),
                          Text(
                            'รายงาน',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: s42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    child: Ads(),
                  )),
            ],
          ),
        );
      });
}
