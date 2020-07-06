import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/bottomBarItem/WriteScrap.dart';
import 'package:scrap/Page/profile/Other_Profile.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/UserInfo.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/provider/WriteScrapProvider.dart';
import 'package:scrap/stream/UserStream.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/showcontract.dart';

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

  Stream<Event> streamTransaction(String field) {
    var userDb = dbRef.userTransact;
    return userDb.child('users/$uid/$field').onValue;
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    Size a = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: a.width / 25),
      child: GestureDetector(
          child: Container(
            color: Colors.transparent,
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
                    SizedBox(width: a.width / 56),
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
                            width: screenWidthDp / 2.4,
                            child: AutoSizeText(widget.data['status'] ?? '',
                                maxLines: 1,
                                minFontSize: 20,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 21)),
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
          onTap: widget.enableNavigator && scrapData.text == null
              ? () => nav.push(
                  context, OtherProfile(data: widget.data, uid: uid, ref: ref))
              : null),
    );
  }

  Widget throwButton() {
    final user = Provider.of<UserData>(context, listen: false);
    return StreamBuilder(
        stream: streamTransaction('allowThrow'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.snapshot.value ?? false
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
                      userStream.papers > 0
                          ? user.promise
                              ? writeScrapLogic()
                              : dialogcontract(context, onPromise: () async {
                                  await userinfo.promiseUser();
                                  user.promise = true;
                                  nav.pop(context);
                                  writeScrapLogic();
                                })
                          : toast.toast('กระดาษของคุณหมดแล้ว');
                    })
                : SizedBox();
          } else {
            return SizedBox();
          }
        });
  }

  writeScrapLogic() {
    final scrapData = Provider.of<WriteScrapProvider>(context, listen: false);
    if (scrapData.text != null) {
      scrap.throwTo(context,
          data: widget.data, thrownUID: uid, collRef: ref, fromMain: true);
      nav.pop(context);
    } else
      nav.push(
          context,
          WriteScrap(
              isThrow: true, data: widget.data, thrownUid: uid, ref: ref));
  }
}
