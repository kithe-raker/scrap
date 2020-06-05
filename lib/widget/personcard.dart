import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/profile/Other_Profile.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/thrown.dart';

class PersonCard extends StatefulWidget {
  final Map data;
  final String uid;
  final String ref;
  final bool enableNavigator;
  PersonCard(
      {@required this.data, this.uid, this.ref, this.enableNavigator = false});
  @override
  _PersonCardState createState() => _PersonCardState();
}

class _PersonCardState extends State<PersonCard> {
  String uid, ref;

  @override
  void initState() {
    widget.uid == null ? uid = widget.data['uid'] : uid = widget.uid;
    widget.ref == null ? ref = widget.data['ref'] : ref = widget.ref;
    super.initState();
  }

  Future<DataSnapshot> streamTransaction(String field) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    return userDb.reference().child('users/$uid/$field').once();
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    Size a = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(left: a.width / 25, right: a.width / 25),
      child: GestureDetector(
          child: Container(
            color: Colors.transparent,
            width: a.width,
            height: a.width / 5,
            margin: EdgeInsets.only(bottom: a.width / 100, left: a.width / 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: a.width / 6,
                      height: a.width / 6,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(a.width),
                          image: widget.data['img'] == null
                              ? null
                              : DecorationImage(
                                  image: NetworkImage(widget.data['img']),
                                  fit: BoxFit.cover)),
                    ),
                    SizedBox(width: a.width / 30),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("@${widget.data['id']}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 18,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: screenHeightDp / 24,
                            width: screenWidthDp / 2.1,
                            child: Text(widget.data['status'] ?? '',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: s38)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                throwButton()
              ],
            ),
          ),
          onTap: widget.enableNavigator
              ? () => nav.push(
                  context, OtherProfile(data: widget.data, uid: uid, ref: ref))
              : null),
    );
  }

  Widget throwButton() {
    final user = Provider.of<UserData>(context, listen: false);
    return FutureBuilder(
        future: streamTransaction('allowThrow'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.value ?? false
                ? GestureDetector(
                    child: Container(
                      width: screenWidthDp / 6,
                      height: screenWidthDp / 10,
                      margin: EdgeInsets.only(
                          top: screenWidthDp / 30, right: screenWidthDp / 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(screenWidthDp),
                          color: Colors.white),
                      alignment: Alignment.center,
                      child: Text(
                        "ปาใส่",
                        style: TextStyle(
                            color: Color(0xff26A4FF),
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidthDp / 20),
                      ),
                    ),
                    onTap: () {
                      user.papers > 0
                          ? writerScrap(context,
                              isThrow: true,
                              data: widget.data,
                              thrownUID: uid,
                              ref: ref)
                          : toast.toast('กระดาษของคุณหมดแล้ว');
                    })
                : SizedBox();
          } else {
            return SizedBox();
          }
        });
  }
}
