import 'dart:ui';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:flutter/material.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class Showfinishpaper extends StatefulWidget {
  @override
  _ShowfinishpaperState createState() => _ShowfinishpaperState();
}

class _ShowfinishpaperState extends State<Showfinishpaper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: InkWell(
            child: Text('Paper'),
            onTap: () {
              dialogfinishpaper(context);
            },
          ),
        ),
      ),
    );
  }
}

void dialogfinishpaper(BuildContext context) {
  showDialog(
      context: context,
      builder: (builder) {
        Size a = MediaQuery.of(context).size;
        return Scaffold(
          body: Container(
            width: a.width,
            height: a.height,
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                //ADS here !!!!
                /*  Positioned(
                    bottom: 0,
                    child: AdmobBanner(
                        adUnitId: AdmobService().getBannerAdId(),
                        adSize: AdmobBannerSize.FULL_BANNER),
                  ),*/

                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/allpaper.png",
                        width: a.width / 1.3,
                      ),
                      Container(
                        width: a.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.check,
                              color: Colors.white,
                              size: a.width / 12,
                            ),
                            Text(
                              "คุณได้รับการเติมกระดาษแล้ว",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: a.width / 13,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: a.width / 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                  width: a.width / 2.85,
                                  height: a.width / 6.8,
                                  //   margin: EdgeInsets.only(right: a.width / 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(a.width)),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          width: a.width / 17,
                                          child: Image.asset(
                                            "assets/Group 74.png",
                                            color: Color(0xff26A4FF),
                                            fit: BoxFit.contain,
                                            //  width: a.width / 3 / 2,
                                          )),
                                      SizedBox(
                                        width: screenWidthDp / 25,
                                      ),
                                      Text(
                                        "หน้าหลัก",
                                        style: TextStyle(
                                            color: Color(0xff26A4FF),
                                            fontSize: a.width / 15 / 1.2,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      child: AdmobBanner(
                          adUnitId: AdmobService().getBannerAdId(),
                          adSize: AdmobBannerSize.FULL_BANNER),
                    )),
              ],
            ),
          ),
        );
      });
}
