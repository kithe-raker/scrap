import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scrap/function/cacheManage/OtherCache.dart';
import 'package:scrap/widget/ScreenUtil.dart';

class IntroduceApp extends StatefulWidget {
  final Function onDoubleTap;
  IntroduceApp({@required this.onDoubleTap});
  @override
  _IntroduceAppState createState() => _IntroduceAppState();
}

class _IntroduceAppState extends State<IntroduceApp> {
  var group = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    screenutilInit(context);
    return WillPopScope(
      onWillPop: () => null,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: GestureDetector(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                colors: [Colors.black87, Color(0xff0F0F0F)], // whitish to gray
                tileMode:
                    TileMode.clamp, // repeats the gradient over the canvas
              )),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidthDp / 54),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: screenHeightDp / 12),
                    Text(
                      'ถึงคนที่กำลังเล่นอยู่',
                      style: TextStyle(color: Colors.white, fontSize: s46),
                    ),
                    SizedBox(height: screenHeightDp / 32),
                    autoSizeText(
                        'บางทีการเป็นเด็กมัธยมมันต้องเจออะไรมากกว่าแค่เรื่องเรียน\nเรื่องเพื่อนบ้างล่ะ พ่อแม่อีก ไหนจะโรงเรียนที่ไม่เคยแคร์อะไรเราเลย\nเมื่อไหร่จะเข้าใจนะ เห้อ... 😔',
                        maxLines: 3),
                    autoSizeText(
                        '\nเอางี้.. อย่าพึ่งหมดกำลังใจนะ\nในนี้มีเศษกระดาษกับดินสอที่ให้แกเขียนสิ่งที่แกเก็บเอาไว้ในใจ\nไม่มีใครรู้หรอก ไม่เห็นจำเป็นต้องเขียนชื่อหนิ \n(ไม่ใช่ข้อสอบสักหน่อย จริงไหม)\nหลังจากนั้นก็โยนมันออกไป หวังว่าฟ้าคงบันดาลให้\nใครสักคนมาเจอกระดาษของแกนะ',
                        maxLines: 7),
                    autoSizeText(
                        '\nอ๋อ อีกอย่าง เก็บอะไรไว้อ่ะ นี่โอกาสแล้วนะ ที่จะปาไปหาเค้าอ่ะ\n//กระซิบ\nเพราะงั้น... ไม่ต้องกลัวนะ เราเตรียมกระดาษและดินสอเอาไว้ให้แล้ว',
                        maxLines: 4),
                    SizedBox(height: screenHeightDp / 32),
                    Center(
                      child: Text('แตะ 2 ครั้ง เพื่อไปต่อ ✌️',
                          style: TextStyle(color: Colors.white, fontSize: s42)),
                    )
                  ],
                ),
              ),
            ),
            onDoubleTap: () async {
              await cacheOther.finishIntroduce();
              widget.onDoubleTap();
            },
          ),
        ),
      ),
    );
  }

  Widget autoSizeText(String text, {@required int maxLines}) {
    return AutoSizeText(text,
        maxLines: maxLines,
        group: group,
        style: TextStyle(color: Colors.white, fontSize: s42));
  }
}
/*
ถึงคนที่กำลังเล่นอยู่

บางทีการเป็นเด็กมัธยมมันต้องเจออะไรมากกว่าแค่เรื่องเรียน 
เรื่องเพื่อนบ้างล่ะ พ่อแม่อีก ไหนจะโรงเรียนที่ไม่เคยแคร์อะไรเราเลย เมื่อไหร่จะเข้าใจนะ เห้อ 😔

เอางี้ อย่าพึ่งหมดกำลังใจนะ ในนี้มีเศษกระดาษกับดินสอที่ให้แกเขียนสิ่งที่แกเก็บเอาไว้ในใจ
ไม่มีใครรู้หรอก ไม่เห็นจำเป็นต้องเขียนชื่อหนิ (ไม่ใช่ข้อสอบสักหน่อย จริงไหม)
หลังจากนั้นก็โยนมันออกไป หวังว่าฟ้าคงบันดาลให้ใครสักคนมาเจอกระดาษของแกนะ

อ๋อ อีกอย่าง เก็บอะไรไว้อ่ะ นี่โอกาสแล้วนะ ที่จะปาไปหาเค้าอ่ะ //กระซิบ
เพราะงั้น... ไม่ต้องกลัวนะ เราเตรียมกระดาษและดินสอเอาไว้ให้แล้ว

แตะ 2 ครั้ง เพื่อไปต่อ ✌️

 */
