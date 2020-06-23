import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scrap/method/Navigator.dart';
import 'package:scrap/models/TopPlaceModel.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/stream/NearbyStream.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/explore/ScrapNearby.dart';

class PlaceWidget extends StatefulWidget {
  final TopPlaceModel place;
  final int count;
  PlaceWidget({@required this.place, this.count});
  @override
  _PlaceWidgetState createState() => _PlaceWidgetState();
}

class _PlaceWidgetState extends State<PlaceWidget> {
  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return GestureDetector(
      child: Container(
          padding: EdgeInsets.only(bottom: screenWidthDp / 21),
          margin: EdgeInsets.only(top: screenHeightDp / 54),
          decoration: BoxDecoration(
              color: Color(0xff2E2E2E),
              borderRadius: BorderRadius.circular(screenWidthDp / 32)),
          child: Stack(
            children: <Widget>[
              Center(
                  child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: screenWidthDp / 32,
                        vertical: screenHeightDp / 81),
                    child: Row(
                      children: <Widget>[
                        Hero(
                          tag: widget.place.id,
                          child: Container(
                              padding: EdgeInsets.all(screenWidthDp / 64),
                              decoration: BoxDecoration(
                                  color: Color(0xff357EED),
                                  borderRadius:
                                      BorderRadius.circular(screenWidthDp)),
                              child: Icon(Icons.school,
                                  size: s58, color: Colors.black87)),
                        ),
                        SizedBox(width: screenWidthDp / 64),
                        Text(
                          widget.place?.name ?? 'someWhere',
                          style: TextStyle(
                              fontSize: s52,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7.2),
                  Container(
                      height: screenWidthDp / 3.4 * 1.21,
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidthDp / 32),
                      child: recentltScraps())
                ],
              )),
              Positioned(
                  top: screenWidthDp / 42,
                  right: screenWidthDp / 42,
                  child: transactionBox(widget.place.id)),
            ],
          )),
      onTap: () async {
        await nearby.initNearby(context, placeId: widget.place.id);
        nav.push(context, ScrapNearby(place: widget.place));
      },
    );
  }

  Widget recentltScraps() {
    var now = DateTime.now();
    var scraps = widget.place.recentScraps
        .where((scrap) => now.difference(scrap.timeStamp).inHours < 24)
        .toList();
    return scraps.length > 0
        ? ListView(
            scrollDirection: Axis.horizontal,
            children: widget.place.recentScraps
                .map((scrap) => recentScrapWidget(scrap))
                .toList())
        : Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: screenHeightDp / 18),
            child: Text(
              'ไม่มีพบสแครปบริเวณนี้',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.51),
                  fontWeight: FontWeight.bold,
                  fontSize: s52),
            ),
          );
  }

  Widget recentScrapWidget(RecentScrap recentScrap) {
    var fontRatio = s48 / screenWidthDp / 1.04;
    return Container(
        height: screenWidthDp / 3.4 * 1.21,
        width: screenWidthDp / 3.4,
        margin: EdgeInsets.only(right: screenWidthDp / 64),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/paperscrap.jpg'), fit: BoxFit.cover)),
        child: Stack(children: <Widget>[
          Center(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 64),
            child: AutoSizeText(recentScrap?.text ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: screenWidthDp / 3.4 * fontRatio)),
          )),
        ]));
  }

  Future<int> placeTransaction(String placeId) async {
    int count;
    if (widget.count == null) {
      final db = Provider.of<RealtimeDB>(context, listen: false);
      var placeAll = FirebaseDatabase(app: db.placeAll);
      var ref = placeAll.reference().child('places/$placeId/allCount');
      var data = await ref.once();
      count = data?.value ?? 0;
    } else {
      count = widget.count;
    }
    return count;
  }

  Widget transactionBox(String placeId) {
    return FutureBuilder(
        future: placeTransaction(placeId),
        builder: (context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            var trans = snapshot.data;
            return trans < 0
                ? Container(
                    padding: EdgeInsets.only(
                        left: screenWidthDp / 64, right: screenWidthDp / 42),
                    decoration: BoxDecoration(
                        color: Color(0xff585858),
                        borderRadius:
                            BorderRadius.circular(screenWidthDp / 18)),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset('assets/paper.svg',
                            // color: Color(0xfff434343),
                            width: screenWidthDp / 14,
                            height: screenWidthDp / 14,
                            fit: BoxFit.contain),
                        Text(
                          trans.abs().toString(),
                          style:
                              TextStyle(fontSize: s42, color: Colors.white70),
                        )
                      ],
                    ),
                  )
                : SizedBox();
          } else
            return SizedBox();
        });
  }
}
