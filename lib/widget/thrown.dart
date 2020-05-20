import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:scrap/function/toDatabase/scrap.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/SelectPosition.dart';

//ฟังก์ชั่นปากระดาษ
bool public = false;
void writerScrap(BuildContext context, {LatLng latLng, bool isThrow = false}) {
  String text;
  var _key = GlobalKey<FormState>();
  showDialog(
      context: context,
      builder: (context) {
        Size a = MediaQuery.of(context).size;
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: <Widget>[
                GestureDetector(
                    child: Container(
                      width: a.width,
                      height: a.height,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    }),
                Container(
                  width: a.width,
                  margin: EdgeInsets.only(
                      top: a.height / 8,
                      right: a.width / 60,
                      left: a.width / 40,
                      bottom: a.width / 8),
                  child: ListView(
                    children: <Widget>[
                      Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: a.height,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  //ปุ่มกดหากต้องการที่จะเปิดเผยตัวตน
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: a.width / 13,
                                          height: a.width / 13,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  color: Colors.transparent)),
                                          child: Checkbox(
                                            tristate: false,
                                            activeColor: Color(0xfff707070),
                                            value: public ?? false,
                                            onChanged: (bool value) {
                                              setState(() {
                                                public = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "\t" + "ไม่ระบุตัวตน",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: a.width / 20),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  //ออกจากหน้าปากระดาษ
                                  InkWell(
                                    child: Icon(
                                      Icons.cancel,
                                      size: a.width / 15,
                                      color: Color(0xfff707070),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            //กระดาษที่ไว้เขียนไงจ้ะ
                            Container(
                              margin: EdgeInsets.only(top: a.width / 150),
                              width: a.width / 1,
                              height: a.height / 1.8,
                              //ใช้สแต็กเอา
                              child: Stack(
                                children: <Widget>[
                                  //รูปกระดาษ
                                  Container(
                                    child: Image.asset(
                                      'assets/paper-readed.png',
                                      width: a.width / 1.04,
                                      height: a.width / 1.04 * 1.115,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    width: a.width,
                                    height: a.height,
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 25, right: 25),
                                      width: a.width,
                                      child: Form(
                                        key: _key,
                                        child: TextFormField(
                                          maxLength: 250,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              height: 1.35,
                                              fontSize: a.width / 14),
                                          maxLines: null,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            counterText: "",
                                            counterStyle: TextStyle(
                                                color: Colors.transparent),
                                            border: InputBorder
                                                .none, //สำหรับให้เส้นใต้หาย
                                            hintText:
                                                'เขียนข้อความบางอย่างที่อยู่ในใจคุณ\nไม่ต้องห่วง มันจะหายไปใน 24 ชั่วโมง\n(แต่อย่าลืมสัญญาของเราล่ะ)',
                                            hintStyle: TextStyle(
                                              fontSize: a.width / 18,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          validator: (val) {
                                            return val.trim() == ""
                                                ? scrap.toast(
                                                    "ลองเขียนข้อความบางอย่างสิ")
                                                : null;
                                          },
                                          onSaved: (val) {
                                            text = val;
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: screenWidthDp / 21),
                              child: GestureDetector(
                                  child: Container(
                                    width: a.width / 4.5,
                                    height: a.width / 10,
                                    decoration: BoxDecoration(
                                        color: isThrow
                                            ? Colors.white
                                            : Color(0xff26A4FF),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    alignment: Alignment.center,
                                    child: Text(isThrow ? "ปาใส่" : 'โยนไว้',
                                        style: TextStyle(
                                            color: isThrow
                                                ? Color(0xff26A4FF)
                                                : Colors.white,
                                            fontSize: a.width / 18,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  onTap: () {
                                    if (_key.currentState.validate()) {
                                      _key.currentState.save();
                                      if (!isThrow)
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SelectPosition(
                                                        defaultLatLng:
                                                            latLng)));
                                      // scrap.toast('คุณได้ทิ้งกระดาษไว้แล้ว');
                                      // Navigator.pop(context);
                                      // await scrap.binScrap(
                                      //     text, public, widget.doc);
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // แปะโฆษณา
                Positioned(
                    bottom: 0,
                    child: Container(
                      height: a.width / 6.4,
                      width: a.width,
                      child: Image.network(
                          'https://www.fluxcreative.com.au/images/blog/facebook-advertising.png'),
                    )),
              ],
            ),
          );
        });
      });
}
