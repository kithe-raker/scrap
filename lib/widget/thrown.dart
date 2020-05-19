import 'package:flutter/material.dart';
import 'dart:async';

//ฟังก์ชั่นปากระดาษ
bool public = false;
void showAlert(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        Size a = MediaQuery.of(context).size;
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: <Widget>[
                InkWell(
                  child: Container(
                    width: a.width,
                    height: a.height,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
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
                                            "\t" + "เปิดเผยตัวตน",
                                            style: TextStyle(
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
                                        //หากไม่ได้กรอกจะขึ้น ------- เอาไปทำต่อนะจ้ะ
                                        /* validator: (val) {
                                            return val.trim() == null ||
                                                    val.trim() == ""
                                                ? Taoast().toast(
                                                    "ลองเขียนข้อความบางอย่างสิ")
                                                : null;
                                          },*/
                                        //เนื้อหาที่ต้องกรอกเข้าไปใน text
                                        onChanged: (val) {
                                          //text = val;
                                        },
                                      ),
                                    ),
                                  )
                                  //)
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: a.width / 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                      child: Container(
                                        width: a.width / 4.5,
                                        height: a.width / 10,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        alignment: Alignment.center,
                                        child: Text("ปาใส่",
                                            style: TextStyle(
                                                color: Color(0xff26A4FF),
                                                fontSize: a.width / 15,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      //ให้ dialog แรกหายไปก่อนแล้วเปิด dialog2
                                      onTap: () {}),
                                ],
                              ),
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
                      // height: a.width / 5,
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
