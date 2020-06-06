import 'dart:math';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrap/function/authentication/AuthenService.dart';
import 'package:scrap/function/cacheManage/HistoryUser.dart';
import 'package:scrap/provider/RealtimeDB.dart';
import 'package:scrap/provider/Report.dart';
import 'package:scrap/widget/LoadNoBlur.dart';

void showdialogBurn(context, {bool thrown = false, List burntScraps}) {
  bool loading = false;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Size a = MediaQuery.of(context).size;
        return StatefulBuilder(builder: (context, StateSetter setDialog) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                 width: a.width,
                        height: a.height ,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xff282828),
                            borderRadius: BorderRadius.circular(a.width / 50)),
                        width: a.width,
                        height: a.height / 1.4,
                        padding: EdgeInsets.all(a.width / 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Icon(Icons.whatshot,
                                    color: Color(0xffFF8F3A),
                                    size: a.width / 3),
                                Text(
                                  "เผาสแครป",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: a.width / 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  "หากมีคนกดเผาสแครปมากพอ",
                                  style: TextStyle(
                                      fontSize: a.width / 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "สแครปนี้จะหายไป",
                                  style: TextStyle(
                                      fontSize: a.width / 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // Text(
                                //   "รวมถึงสแครปบางส่วนในมือ",
                                //   style: TextStyle(
                                //       fontSize: a.width / 20,
                                //       color: Colors.white,
                                //       fontWeight: FontWeight.bold),
                                // ),
                                // Text(
                                //   "ของผู้เขียนด้วย",
                                //   style: TextStyle(
                                //       fontSize: a.width / 20,
                                //       color: Colors.white,
                                //       fontWeight: FontWeight.bold),
                                // ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                RaisedButton(
                                    color: Color(0xff797979),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(a.width),
                                    ),
                                    child: Container(
                                      width: a.width / 4,
                                      height: a.width / 8,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "เผาเลย",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: a.width / 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    onPressed: () async {
                                      setDialog(() => loading = true);
                                      thrown
                                          ? await burnThrownScrap(context)
                                          : await burnScrap(
                                              context, burntScraps);
                                      setDialog(() => loading = false);
                                    }),
                                Text(
                                  '"แน่ใจนะ"',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          child: Container(
                            // margin: EdgeInsets.only(
                            //     top: a.width / 20, bottom: a.width / 15),
                            width: a.width / 12,
                            height: a.width / 12,
                            decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(a.width)),
                            child: Center(
                              child: Icon(Icons.clear, color: Colors.white),
                            ),
                          ),
                          onTap: () => nav.pop(context)),
                    ),
                    loading ? Center(child: LoadNoBlur()) : SizedBox()
                  ],
                ),
              ),
            ),
          );
        });
      });
}

burnThrownScrap(BuildContext context) async {
  final report = Provider.of<Report>(context, listen: false);
  final db = Provider.of<RealtimeDB>(context, listen: false);
  final rand = Random();
  var userDb = FirebaseDatabase(app: db.userTransact);
  var batch = fireStore.batch();
  var burn = rand.nextInt(1) + 3;
  var papers =
      await userDb.reference().child('users/${report.targetId}/papers').once();
  batch.delete(fireStore.collection(report.scrapRef).document(report.scrapId));
  batch.updateData(
      fireStore
          .collection(
              'Users/${report.region}/users/${report.targetId}/thrownLog')
          .document(report.scrapId),
      {'burnt': true});
  await userDb.reference().child('users/${report.targetId}').update(
      {'papers': (papers.value - burn).isNegative ? 0 : papers.value - burn});
  await batch.commit();
  burntDialog(context, thrownScrap: true);
}

burnScrap(BuildContext context, List burntScraps) async {
  final report = Provider.of<Report>(context, listen: false);
  var ref =
      FirebaseDatabase.instance.reference().child('scraps/${report.scrapId}');
  var data = await ref.once();
  burntScraps.add(report.scrapId);
  var batch = fireStore.batch();
  dynamic point = data.value['point'] ?? 0;
  int burn = data.value['burn'] + 1;
  await cacheHistory.addBurn(id: report.scrapId);
  if (point < 26 && burn > 4) {
    batch.setData(
        fireStore.collection('BurntScraps').document(report.scrapId), {
      'id': report.scrapId,
      'writer': report.targetId,
      'ref': report.scrapRef
    });
    batch.updateData(
        fireStore
            .collection(
                'Users/${report.region}/users/${report.targetId}/history')
            .document(report.scrapId),
        {'burnt': true});
    await batch.commit();
    burntDialog(context);
  } else if (point < 26 && burn < 5) {
    await ref.update({'burn': burn});
    notBurntDialog(context);
  } else if (burn >= point * 0.2) {
    batch.setData(
        fireStore.collection('BurntScraps').document(report.scrapId), {
      'id': report.scrapId,
      'writer': report.targetId,
      'ref': report.scrapRef
    });
    batch.updateData(
        fireStore
            .collection(
                'Users/${report.region}/users/${report.targetId}/history')
            .document(report.scrapId),
        {'burnt': true});
    await batch.commit();
    burntDialog(context);
  } else {
    await ref.update({'burn': burn});
    notBurntDialog(context);
  }
}

void burntDialog(BuildContext context, {bool thrownScrap = false}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Size a = MediaQuery.of(context).size;
        Future.delayed(Duration(milliseconds: 2400), () {
          if (thrownScrap) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        });
        return WillPopScope(
          onWillPop: () => null,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: <Widget>[
                  Container(
                    width: a.width,
                    height: a.height,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.whatshot,
                              size: a.width / 3, color: Color(0xffFF8F3A)),
                          Text("สแครปนี้โดนเผาแล้ว !",
                              style: TextStyle(
                                  fontSize: a.width / 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            thrownScrap
                                ? 'ไฟได้ลามไปยังกระดาษของคนที่ปาแล้ว'
                                : "ขอบคุณสำหรับการควบคุมเนื้อหา",
                            style: TextStyle(
                                fontSize: a.width / 17,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

void notBurntDialog(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        Size a = MediaQuery.of(context).size;
        Future.delayed(Duration(milliseconds: 2400), () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
        return WillPopScope(
          onWillPop: () => null,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: <Widget>[
                  Container(
                    width: a.width,
                    height: a.height,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.whatshot,
                            size: a.width / 3,
                            color: Color(0xff909090),
                          ),
                          SizedBox(
                            height: a.width / 100,
                          ),
                          Text(
                            "สแครปนี้ยังไม่โดนเผา",
                            style: TextStyle(
                                fontSize: a.width / 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "ต้องการผู้เผามากกว่านี้",
                            style: TextStyle(
                                fontSize: a.width / 17,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
