import 'dart:io';
import 'dart:ui';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/BottomBarItem/Profile.dart';
import 'package:scrap/Page/suppeople.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/services/admob_service.dart';
import 'package:scrap/unusedFile/Gridfavorite.dart';
import 'package:scrap/unusedFile/MapScraps.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/warning.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String type, select, text;
  bool private = false, initInfoFinish = false;
  Scraps scrap = Scraps();

  // _showModalBottomSheet(context) {
  //   Size a = MediaQuery.of(context).size;
  //   showModalBottomSheet(
  //       backgroundColor: Colors.transparent,
  //       context: context,
  //       builder: (BuildContext context) {
  //         Size a = MediaQuery.of(context).size;
  //         return Stack(
  //           children: <Widget>[
  //             Container(
  //               child: Container(
  //                 width: a.width,
  //                 height: a.width / 1.8,
  //                 decoration: BoxDecoration(
  //                     color: Color(0xff282828),
  //                     borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(a.width / 20),
  //                       topRight: Radius.circular(a.width / 20),
  //                     )),
  //                 child: Column(
  //                   children: <Widget>[
  //                     Container(
  //                       margin: EdgeInsets.only(
  //                           top: a.width / 40, bottom: a.width / 15),
  //                       width: a.width / 3,
  //                       height: a.width / 50,
  //                       decoration: BoxDecoration(
  //                           color: Colors.grey,
  //                           borderRadius: BorderRadius.circular(a.width)),
  //                     ),
  //                     Container(
  //                       width: a.width,
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: <Widget>[
  //                           Column(
  //                             children: <Widget>[
  //                               InkWell(
  //                                 child: Container(
  //                                   margin:
  //                                       EdgeInsets.only(bottom: a.width / 50),
  //                                   width: a.width / 6,
  //                                   height: a.width / 6,
  //                                   child: Icon(
  //                                     Icons.whatshot,
  //                                     size: a.width / 13,
  //                                     color: Color(0xffFF8F3A),
  //                                   ),
  //                                   decoration: BoxDecoration(
  //                                     color: Colors.white,
  //                                     borderRadius:
  //                                         BorderRadius.circular(a.width),
  //                                   ),
  //                                 ),
  //                                 onTap: () {
  //                                   //ต้องแก้
  //                                   //  _showdialogwhatshot(context);
  //                                 },
  //                               ),
  //                               Text(
  //                                 "เผากระดาษ",
  //                                 style: TextStyle(color: Colors.white),
  //                               )
  //                             ],
  //                           ),
  //                           SizedBox(
  //                             width: a.width / 10,
  //                           ),
  //                           InkWell(
  //                             child: Column(
  //                               children: <Widget>[
  //                                 Container(
  //                                   margin:
  //                                       EdgeInsets.only(bottom: a.width / 50),
  //                                   width: a.width / 6,
  //                                   height: a.width / 6,
  //                                   child: Icon(
  //                                     Icons.block,
  //                                     size: a.width / 13,
  //                                     color: Color(0xff8B8B8B),
  //                                   ),
  //                                   decoration: BoxDecoration(
  //                                       color: Colors.white,
  //                                       borderRadius:
  //                                           BorderRadius.circular(a.width)),
  //                                 ),
  //                                 Text(
  //                                   "บล็อคผู้ใช้",
  //                                   style: TextStyle(color: Colors.white),
  //                                 )
  //                               ],
  //                             ),
  //                             onTap: () {
  //                               //ต้องแก้
  //                               //   _showdialogblock(context);
  //                             },
  //                           ),
  //                           SizedBox(
  //                             width: a.width / 10,
  //                           ),
  //                           InkWell(
  //                             child: Column(
  //                               children: <Widget>[
  //                                 Container(
  //                                   margin:
  //                                       EdgeInsets.only(bottom: a.width / 50),
  //                                   width: a.width / 6,
  //                                   height: a.width / 6,
  //                                   child: Icon(
  //                                     Icons.report_problem,
  //                                     size: a.width / 13,
  //                                     color: Color(0xff8B8B8B),
  //                                   ),
  //                                   decoration: BoxDecoration(
  //                                       color: Colors.white,
  //                                       borderRadius:
  //                                           BorderRadius.circular(a.width)),
  //                                 ),
  //                                 Text(
  //                                   "รายงาน",
  //                                   style: TextStyle(color: Colors.white),
  //                                 )
  //                               ],
  //                             ),
  //                             onTap: () {
  //                               //ต้องแก้
  //                               // _showdialogreport(context);
  //                               // _showdialogreport(context);
  //                             },
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Positioned(
  //               bottom: 0,
  //               child: AdmobBanner(
  //                   adUnitId: AdmobService().getBannerAdId(),
  //                   adSize: AdmobBannerSize.FULL_BANNER),
  //             )
  //           ],
  //         );
  //       });
  // }

  @override
  void initState() {
    initUser();
    super.initState();
  }

  initUser() async {
    setState(() => initInfoFinish = true);
  }

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    Size a = MediaQuery.of(context).size;
    final user = Provider.of<UserData>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        Dg().warnDialog(context, 'คุณต้องการออกจาก Scrap ใช่หรือไม่', () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        });
        return null;
      },
      child: Scaffold(
        backgroundColor: Colors.black, //
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              MapScraps(),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: a.width,
                  child: Column(
                    children: [
                      Container(
                        // ส่วนของ แทบสีดำด้านบน
                        color: Colors.black,
                        height: appBarHeight / 1.42,
                        width: screenWidthDp,
                        /*width: a.width,
                      height: a.width / 5,*/
                        /*padding: EdgeInsets.only(
                          //top: a.height / 36,
                          right: a.width / 20,
                          left: a.width / 20,
                        ),*/
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            //Logo
                            Row(
                              children: <Widget>[
                                SizedBox(width: appBarHeight / 8),
                                Container(
                                    height: a.width / 7,
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                        'assets/scraplogofinal.svg',
                                        width: a.width / 4,
                                        fit: BoxFit.contain)),
                              ],
                            ),
                            // SizedBox(width: a.width / 4.7),
                            Row(
                              children: <Widget>[
                                Container(
                                    height: a.width / 5,
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      child: Container(
                                        width: a.width / 11,
                                        height: a.width / 11,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(a.width),
                                          color: Color(0xffFF4343),
                                        ),
                                        child: Icon(Icons.favorite,
                                            color: Colors.white,
                                            size: a.width / 18),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Gridfavorite()));
                                      },
                                    )),
                                SizedBox(
                                  width: appBarHeight / 10,
                                ),
                                Container(
                                    height: a.width / 5,
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      child: Container(
                                        width: a.width / 11,
                                        height: a.width / 11,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(a.width),
                                          color: Color(0xff26A4FF),
                                        ),
                                        child: Icon(Icons.people,
                                            color: Colors.white,
                                            size: a.width / 18),
                                      ),
                                      onTap: () {
                                        nav.push(context, Subpeople());
                                      },
                                    )),
                                SizedBox(
                                  width: appBarHeight / 10,
                                ),
                                Container(
                                    height: a.width / 5,
                                    alignment: Alignment.center,
                                    child: InkWell(
                                        child: Container(
                                          width: a.width / 11,
                                          height: a.width / 11,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      a.width),
                                              color: Colors.white,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white)),
                                          child: initInfoFinish
                                              ? ClipRRect(
                                                  child: Image.file(
                                                      File(user.img),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          a.width / 10),
                                                )
                                              : Icon(Icons.person,
                                                  color: Colors.black,
                                                  size: a.width / 15),
                                        ),
                                        onTap: () {
                                          nav.push(context, Profile());
                                        })),
                                SizedBox(
                                  width: appBarHeight / 8,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: AdmobBanner(
                            adUnitId: AdmobService().getBannerAdId(),
                            adSize: AdmobBannerSize.FULL_BANNER),
                      )
                    ],
                  ),
                ),
              ),
              // Positioned(
              //     // left: a.width/4.8,
              //     width: a.width,
              //     top: a.height / 7.2,
              //     child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: <Widget>[
              //           SizedBox(
              //             width: 1,
              //           ),
              //           scrapLeft(a),
              //           SizedBox(
              //             width: 1,
              //           )
              //         ])),
            ],
          ),
        ),
      ),
    );
  }

  // Widget changeScrap(String scraps, Size a) {
  //   switch (scraps) {
  //     case 'Analysts':
  //       return scrapPatt(a, 'Analysts');
  //       break;
  //     case 'Diplomats':
  //       return scrapPatt(a, 'Diplomats');
  //       break;
  //     case 'Explorers':
  //       return scrapPatt(a, 'Explorers');
  //       break;
  //     case 'Girl':
  //       return scrapPatt(a, 'Girl');
  //       break;
  //     case 'Sentinels':
  //       return scrapPatt(a, 'Sentinels');
  //       break;
  //     default:
  //       return scrapPatt(a, 'Analysts');
  //       break;
  //   }
  // }

/*
       Set id = {};
            List scraps = [];
            for (var usersID in snap.data['id']) {
              id.add(usersID);
              for (var scrap in snap.data['scraps'][usersID]) {
                scraps.add(scrap);
              } /Users/gPSC1TxFcXVVZ1nQOrPR2kX9SBU2/scraps/collection
            } */

  Widget gpsCheck(Size a, String text) {
    return Center(
      child: Container(
        width: a.width / 1.2,
        height: a.width / 3.2,
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                width: a.width / 4.2,
                height: a.width / 4.2,
                child: FlareActor(
                  'assets/loadingpaper.flr',
                  animation: 'Untitled',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  text,
                  style: TextStyle(fontSize: a.width / 16, color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }

  toast(String text) {
    return Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        // timeInSecForIos: 1,
        backgroundColor: Colors.white60,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
