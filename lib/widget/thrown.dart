import 'package:flutter/material.dart';
import 'dart:async';

bool public = false;
void showAlert(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        Size a = MediaQuery.of(context).size;
        return /*AlertDialog(
          content: Text("hi"),
        );*/
            StatefulBuilder(builder: (context, StateSetter setState) {
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
                  margin: EdgeInsets.only(
                      top: a.height / 8,
                      right: a.width / 20,
                      left: 20,
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
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    left: a.width / 10000,
                                    child: Container(
                                      child: Checkbox(
                                        value: public ?? false,
                                        onChanged: (bool value) {
                                          setState(() {
                                            public = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      child: Container(
                                    child: InkWell(
                                      child: Icon(
                                        Icons.cancel,
                                        size: a.width / 12,
                                        color: Color(0xfff707070),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ))
                                ],
                              ),
                              /*Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  //ปุ่มกดหากต้องการที่จะเปิดเผยตัวตน
                                  Container(
                                    child: Row(
                                      /*   mainAxisAlignment:
                                          MainAxisAlignment.start,*/
                                      /* crossAxisAlignment:
                                          CrossAxisAlignment.start,*/
                                      children: <Widget>[
                                        Checkbox(
                                          value: public ?? false,
                                          onChanged: (bool value) {
                                            setState(() {
                                              public = value;
                                            });
                                          },
                                        ),
                                        /*  Container(
                                          width: a.width / 13,
                                          height: a.width / 13,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      a.width / 50),
                                              border: Border.all(
                                                  color: Colors.transparent)),
                                        ),*/
                                        Container(
                                          child: Text(
                                            "\t" + 'ไม่เปิดเผยตัวตน',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: a.width / 20),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  //ออกจาก��น้านี้
                                  InkWell(
                                    child: Icon(
                                      Icons.cancel,
                                      size: a.width / 12,
                                      color: Color(0xfff707070),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),*/
                            ),
                            //ส่ว��ข���งกระดาษที่เขีย���
                            Container(
                              margin: EdgeInsets.only(top: a.width / 150),
                              width: a.width / 1,
                              height: a.height / 1.8,
                              //ทำเป���น�������ั้นๆ
                              child: Stack(
                                children: <Widget>[
                                  //ช������้นที่ 1 ส่วนของก���ะดาษ
                                  Container(
                                    child: Image.asset(
                                      'assets/paper-readed.png',
                                      width: a.width / 1.04,
                                      height: a.width / 1.04 * 1.115,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  //ชั้นที่ 2
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: a.width / 20, top: a.width / 20),
                                    width: a.width,
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[],
                                    ),
                                  ),
                                  //ชั้นที่ 3 เอาไว้สำหรับเขียนข้อความ
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
                                              .none, //สำหรับใหเส้นใต้หาย
                                          hintText:
                                              'เขียนข้อความบางอย่างที่อยู่ในใจคุณ\nไม่ต้องห่วง มันจะหายไปใน 24 ชั่วโมง\n(แต่อย่าลืมสัญญาของเราล่ะ)',
                                          hintStyle: TextStyle(
                                            fontSize: a.width / 18,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        //หากไม่ได้กรอกจะขึ้น
                                        validator: (val) {},
                                        //เนื้อหาท��่กรอกเข้าไปใน text
                                        onChanged: (val) {},
                                      ),
                                    ),
                                  )
                                  //)
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: a.width / 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                      child: Container(
                                        width: a.width / 4.5,
                                        height: a.width / 8,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                a.width / 30)),
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
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      });
}
/*void dialog2() {
    DateTime now = DateTime.now();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
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
                  Positioned(
                    bottom: 0,
                    child: AdmobBanner(
                        adUnitId: AdmobService().getBannerAdId(),
                        adSize: AdmobBannerSize.FULL_BANNER),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: a.height / 8,
                        right: a.width / 20,
                        left: 20,
                        bottom: a.width / 8),
                    child: ListView(
                      children: <Widget>[
                        Form(
                          key: _key,
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
                                                    BorderRadius.circular(
                                                        a.width / 50),
                                                border: Border.all(
                                                    color: Colors.transparent)),
                                            child: Checkbox(
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
                                    //ออกจาก��น้านี้
                                    InkWell(
                                      child: Icon(
                                        Icons.clear,
                                        size: a.width / 10,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              //ส่ว��ข���งกระดาษที่เขีย���
                              Container(
                                margin: EdgeInsets.only(top: a.width / 150),
                                width: a.width / 1,
                                height: a.height / 1.8,
                                //ทำเป���น�������ั้นๆ
                                child: Stack(
                                  children: <Widget>[
                                    //ช������้นที่ 1 ส่วนของก���ะดาษ
                                    Container(
                                      child: Image.asset(
                                        'assets/paper-readed.png',
                                        width: a.width / 1.04,
                                        height: a.width / 1.04 * 1.115,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    //ชั้นที่ 2
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: a.width / 20,
                                          top: a.width / 20),
                                      width: a.width,
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          public ?? false
                                              ? Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "เขียนโดย : ",
                                                      style: TextStyle(
                                                          fontSize:
                                                              a.width / 22,
                                                          color: Colors.grey),
                                                    ),
                                                    Text("@${widget.doc['id']}",
                                                        style: TextStyle(
                                                            fontSize:
                                                                a.width / 22,
                                                            color: Color(
                                                                0xff26A4FF)))
                                                  ],
                                                )
                                              : Text(
                                                  'เขียนโดย : ใครสักคน',
                                                  style: TextStyle(
                                                      fontSize: a.width / 22,
                                                      color: Colors.grey),
                                                ),
                                          Text(
                                              now.minute < 10
                                                  ? 'เวลา: ${now.hour}:0${now.minute}'
                                                  : 'เวลา: ${now.hour}:${now.minute}',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: a.width / 22))
                                        ],
                                      ),
                                    ),
                                    //ชั้นที่ 3 เอาไว้สำหรับเขียนข้อความ
                                    Container(
                                      width: a.width,
                                      height: a.height,
                                      alignment: Alignment.center,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 25, right: 25),
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
                                                .none, //สำหรับใหเส้นใต้หาย
                                            hintText:
                                                'เขียนข้อความบางอย่างที่อยู่ในใจคุณ\nไม่ต้องห่วง มันจะหายไปใน 24 ชั่วโมง\n(แต่อย่าลืมสัญญาของเราล่ะ)',
                                            hintStyle: TextStyle(
                                              fontSize: a.width / 18,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          //หากไม่ได้กรอกจะขึ้น
                                          validator: (val) {
                                            return val.trim() == null ||
                                                    val.trim() == ""
                                                ? Taoast().toast(
                                                    "ลองเขียนข้อความบางอย่างสิ")
                                                : null;
                                          },
                                          //เนื้อหาท��่กรอกเข้าไปใน text
                                          onChanged: (val) {
                                            text = val;
                                          },
                                        ),
                                      ),
                                    )
                                    //)
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: a.width / 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                        child: Container(
                                          width: a.width / 4.5,
                                          height: a.width / 8,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      a.width / 30)),
                                          alignment: Alignment.center,
                                          child: Text("ปาใส่",
                                              style: TextStyle(
                                                  color: Color(0xff26A4FF),
                                                  fontSize: a.width / 15,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        //ให้ dialog แรกหายไปก่อนแล้วเปิด dialog2
                                        onTap: () {
                                          if (_key.currentState.validate()) {
                                            _key.currentState.save();

                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FriendList(
                                                    doc: widget.doc,
                                                    data: {'text': text},
                                                  ),
                                                ));
                                          }
                                        }),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          );
        },
        fullscreenDialog: true));
  }
*/
