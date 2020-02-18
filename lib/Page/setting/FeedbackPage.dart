import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrap/widget/Toast.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(children: <Widget>[
        Container(
          color: Colors.black,
          width: a.width,
          child: Padding(
            padding: EdgeInsets.only(
                top: a.width / 20,
                right: a.width / 25,
                left: a.width / 25,
                bottom: a.width / 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      //back btn
                      child: Container(
                        width: a.width / 7,
                        height: a.width / 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(a.width),
                            color: Colors.white),
                        child: Icon(Icons.arrow_back,
                            color: Colors.black, size: a.width / 15),
                      ),
                      onTap: () {
                        Navigator.pop(
                          context,
                        );
                      },
                    ),
                  ],
                ), //back btn

                SizedBox(height: a.height / 10.5),

                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'ให้คำแนะนำแก่เรา',
                    style: TextStyle(
                        fontSize: a.width / 6.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    'หากคุณมีไอเดียดีๆที่อยากเพิ่มฟังก์ชันการใช้งานหรือความกวนใจขณะใช้งานแอปพลิเคชัน\n“ ปากระดาษใส่เราสิ! ”',
                    style: TextStyle(
                        fontSize: a.width / 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  margin: EdgeInsets.only(top: a.width / 50),
                  width: a.width / 1,
                  height: a.height / 1.8,
                  //ทำเป็นชั้นๆ
                  child: Stack(
                    children: <Widget>[
                      //ช���้นที่ 1 ส่วนของก���ะดาษ
                      Container(
                        child: Image.asset(
                          'assets/paper-readed.png',
                          width: a.width / 1,
                          height: a.height / 1.8,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'เขียนถึง : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey)),
                                  TextSpan(
                                      text: '@scrapteam',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue)),
                                ],
                              ),
                            ),
                            // Text("เวลา" + " : " + time,
                            //     style:
                            //         TextStyle(color: Colors.grey))
                          ],
                        ),
                      ),
                      //ชั้นที่ 3 เอาไว้สำหรับเขียนข้อความ
                      Container(
                        width: a.width,
                        height: a.height,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: a.width / 1.5,
                          child: TextFormField(
                            textAlign:
                                TextAlign.center, //เพื่อให้ข้อความอยู่ตรงกลาง
                            style: TextStyle(fontSize: a.width / 15),
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none, //สำหรับใหเส้นใต้หาย
                              hintText: 'เขียนข้อความบางอย่าง',
                              hintStyle: TextStyle(
                                fontSize: a.width / 15,
                                color: Colors.grey,
                              ),
                            ),
                            //หากไม่ได้กรอกจะขึ้น
                            validator: (val) {
                              return val.trim() == null || val.trim() == ""
                                  ?  Taoast().toast("เขียนข้อความบางอย่างสิ") 
                                  : "";
                            },
                            //เนื้อหาที่กรอกเข้าไปใน text
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

                SizedBox(height: a.height / 30),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: a.height / 9,
                        width: a.width,
                        decoration: BoxDecoration(
                            color: Color(0xff282828),
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.image,
                                size: a.width / 13,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'แตะเพื่อแนบภาพ',
                                style: TextStyle(
                                  fontSize: a.width / 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          right: 12.0,
                          top: 8.0,
                          child: Text('0 ภาพ',
                              style: TextStyle(
                                  fontSize: a.width / 19,
                                  color: Colors.grey[300])))
                    ],
                  ),
                ),

                 SizedBox(height: a.height / 40),

                Center(
                  child: InkWell(
                    child: Container(
                      width: a.width / 4.0,
                      height: a.width / 8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(a.width)),
                      alignment: Alignment.center,
                      child:
                          Text("ปาใส่", style: TextStyle(fontSize: a.width / 13 , color: Colors.black , fontWeight: FontWeight.w900)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ]),

      /*   Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: a.width / 50),
            width: a.width / 1,
            height: a.height / 1.8,
            //ทำเป็นชั้นๆ
            child: Stack(
              children: <Widget>[
                //ช���้นที่ 1 ส่วนของก���ะดาษ
                Container(
                  child: Image.asset(
                    'assets/paper-readed.png',
                    width: a.width / 1,
                    height: a.height / 1.8,
                    fit: BoxFit.cover,
                  ),
                ),
                //ชั้นที่ 2
                Container(
                  margin:
                      EdgeInsets.only(left: a.width / 20, top: a.width / 20),
                  width: a.width,
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'เขียนถึง : ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                            TextSpan(
                                text: '@scrapteam',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue)),
                          ],
                        ),
                      ),
                      // Text("เวลา" + " : " + time,
                      //     style:
                      //         TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
                //ชั้นที่ 3 เอาไว้สำหรับเขียนข้อความ
                Container(
                  width: a.width,
                  height: a.height,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: a.width / 1.5,
                    child: TextFormField(
                      textAlign: TextAlign.center, //เพื่อให้ข้อความอยู่ตรงกลาง
                      style: TextStyle(fontSize: a.width / 15),
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none, //สำหรับใหเส้นใต้หาย
                        hintText: 'เขียนข้อความบางอย่าง',
                        hintStyle: TextStyle(
                          fontSize: a.width / 15,
                          color: Colors.grey,
                        ),
                      ),
                      //หากไม่ได้กรอกจะขึ้น
                      validator: (val) {
                        return val.trim() == null || val.trim() == ""
                            ? 'เขียนบางอย่างสิ'
                            : null;
                      },
                      //เนื้อหาที่กรอกเข้าไปใน text
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
        ],
      ), */
    );
  }
}
