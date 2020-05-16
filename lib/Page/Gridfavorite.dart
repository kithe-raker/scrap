import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scrap/services/admob_service.dart';

class Gridfavorite extends StatefulWidget {
  @override
  _GridfavoriteState createState() => _GridfavoriteState();
}

class _GridfavoriteState extends State<Gridfavorite> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
            width: a.width,
            height: a.width / 5,
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  child: Container(
                      width: a.width / 12,
                      child: Image.asset(
                        "assets/sss.png",
                        fit: BoxFit.contain,
                        width: a.width / 10,
                      )),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  child: Text(
                    "สแครปที่คุณที่ตามในวันนี้",
                    style:
                        TextStyle(color: Colors.white, fontSize: a.width / 20),
                  ),
                ),
                Container(
                  child: Text("     "),
                )
              ],
            ),
          ),
          page == 1
              ? Container(
                  width: a.width,
                  height: a.height,
                  margin: EdgeInsets.only(top: a.width / 5),
                  child: ListView(
                    children: <Widget>[
                      Wrap(
                          spacing: a.width / 42,
                          runSpacing: a.width / 42,
                          alignment: WrapAlignment.center,
                          children: [
                            block(),
                            block(),
                            block(),
                            block(),
                            block(),
                            block(),
                          ]),
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
                            color: Colors.black,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(a.width)),
                        ),
                        SizedBox(height: a.width/20,),
                        Text("คุณยังไม่ได้ติดสแครปในวันนี้",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,fontSize: a.width/20)),
                        Text("ลองกดหัวใจเพื่อการเคลื่อนไหว",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,fontSize: a.width/20)),
                        Text("ในสแครปที่ดูสนใจสิ",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,fontSize: a.width/20))
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
    );
  }

  Widget block() {
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
                "datata",
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(a.width / 50),
              alignment: Alignment.center,
              width: a.width / 7,
              height: a.width / 13,
              decoration: BoxDecoration(
                  color: Color(0xff000000),
                  borderRadius: BorderRadius.circular(a.width / 80)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "1.2K",
                    style:
                        TextStyle(color: Colors.white, fontSize: a.width / 30),
                  ),
                  Icon(
                    Icons.sms,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        // controller.refreshCompleted();
      },
    );
  }
}
