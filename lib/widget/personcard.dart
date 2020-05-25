import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/profile/Other_Profile.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/thrown.dart';

class PersonCard extends StatefulWidget {
  final Map data;
  final String uid;
  final String ref;
  PersonCard({@required this.data, this.uid, this.ref});
  @override
  _PersonCardState createState() => _PersonCardState();
}

class _PersonCardState extends State<PersonCard> {
  Future<DataSnapshot> streamTransaction(String field) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var userDb = FirebaseDatabase(app: db.userTransact);
    return userDb
        .reference()
        .child('users/${widget.uid ?? widget.data['uid']}/$field')
        .once();
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    Size a = MediaQuery.of(context).size;
    return GestureDetector(
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
                SizedBox(
                  width: a.width / 30,
                ),
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
                      Text(widget.data['status'] ?? '',
                          style: TextStyle(color: Colors.grey, fontSize: s38))
                    ],
                  ),
                )
              ],
            ),
            throwButton()
          ],
        ),
      ),
      onTap: () {
        nav.push(context, Other_Profile());
      },
    );
  }

  Widget throwButton() {
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
                      writerScrap(context);
                    })
                : SizedBox();
          } else {
            return SizedBox();
          }
        });
  }
}
