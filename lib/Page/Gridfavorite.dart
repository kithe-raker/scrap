import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/services/admob_service.dart';
import 'dart:math' as math;

class Gridfavorite extends StatefulWidget {
  @override
  _GridfavoriteState createState() => _GridfavoriteState();
}

class _GridfavoriteState extends State<Gridfavorite> {
  int page = 0;
  List scraps = [];
  bool loading = true;

  @override
  void initState() {
    initScrap();
    super.initState();
  }

  initScrap() async {
    scraps = await cacheHistory.readHistory(field: 'like');
    scraps.sort((a, b) => DateTime.parse(a['timeStamp'])
        .compareTo(DateTime.parse(b['timeStamp'])));
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              width: a.width,
              height: a.width / 5,
              color: Colors.black,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: a.width / 20,
                    left: a.width / 30,
                    child: Container(
                      child: InkWell(
                        child: Container(
                            width: a.width / 15,
                            child: Image.asset(
                              "assets/Group 74.png",
                              //   fit: BoxFit.contain,
                              width: a.width / 12,
                            )),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: a.width / 20,
                    left: a.width / 3.5,
                    child: Container(
                      child: Text(
                        'สแครปที่คุณติดตามในวันนี้',
                        style: TextStyle(
                            color: Colors.white, fontSize: a.width / 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            scraps.length > 0
                ? Container(
                    width: a.width,
                    height: a.height,
                    margin: EdgeInsets.only(top: a.width / 5.4),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        Wrap(
                            spacing: a.width / 42,
                            runSpacing: a.width / 42,
                            alignment: WrapAlignment.center,
                            children:
                                scraps.map((scrap) => block(scrap)).toList()),
                        SizedBox(height: a.width / 5)
                      ],
                    ),
                  )
                : Container(
                    width: a.width,
                    height: a.height,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: a.width / 3,
                            height: a.width / 3,
                            child: Icon(
                              Icons.favorite,
                              size: a.width / 5,
                              color: Colors.grey,
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xff3C3C3C),
                                borderRadius: BorderRadius.circular(a.width)),
                          ),
                          SizedBox(height: a.width / 20),
                          text("คุณยังไม่ได้ติดสแครปในวันนี้"),
                          text("ลองกดหัวใจเพื่อการเคลื่อนไหว"),
                          text("ในสแครปที่ดูสนใจสิ")
                        ],
                      ),
                    )),
            Positioned(
              bottom: 0,
              child: AdmobBanner(
                  adUnitId: AdmobService().getBannerAdId(),
                  adSize: AdmobBannerSize.FULL_BANNER),
            )
          ],
        ),
      ),
    );
  }

  Widget text(String textt) {
    Size a = MediaQuery.of(context).size;
    return Text(textt,
        style: TextStyle(
            color: Color(0xff3B3B3B),
            fontWeight: FontWeight.bold,
            fontSize: a.width / 15));
  }

  Widget block(Map data) {
    final db = Provider.of<RealtimeDB>(context, listen: false);
    var scrapAll = FirebaseDatabase(app: db.scrapAll);
    int ments;
    Size a = MediaQuery.of(context).size;
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            width: a.width / 2.2,
            height: (a.width / 2.1) * 1.21,
            color: Colors.white,
            child: Center(
              child: Text(
                data['text'],
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FutureBuilder(
                future:
                    scrapAll.reference().child('scraps/${data['id']}').once(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    ments = snapshot.data.value['comment'];
                    return Container(
                      margin: EdgeInsets.all(a.width / 45),
                      alignment: Alignment.center,
                      width: a.width / 5.5,
                      height: a.width / 11,
                      decoration: BoxDecoration(
                          color: ments == data['comments']
                              ? Color(0xfff707070)
                              : Color(0xfff0077CC),
                          borderRadius: BorderRadius.circular(a.width / 80)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${ments.abs()}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: a.width / 20),
                          ),
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: Icon(
                              Icons.sms,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: a.width / 64)
                        ],
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
          ),
        ],
      ),
      onTap: () {
        if (ments != null) {
          cacheHistory.updateFollowingScrap(data['id'], ments);
          scraps.firstWhere((scrap) => scrap['id'] == data['id'])['comments'] =
              ments;
          setState(() {});
        }
      },
    );
  }
}
