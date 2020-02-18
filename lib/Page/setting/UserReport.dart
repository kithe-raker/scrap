import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scrap/widget/Toast.dart';

class UserReport extends StatefulWidget {
  @override
  _UserReportState createState() => _UserReportState();
}

class _UserReportState extends State<UserReport> {
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
                    FloatingActionButton.extended(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        //save
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.black,
                        size: a.width / 20,
                      ),
                      label: Text(
                        "ส่ง",
                        style: TextStyle(
                            color: Colors.black, fontSize: a.width / 16),
                      ),
                    ),
                  ],
                ), //back btn

                SizedBox(height: a.height / 10.5),

                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'ร้องเรียนผู้ใช้',
                    style: TextStyle(
                        fontSize: a.width / 6.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    'คุณสามารถร้องเรียนเมื่่อพบข้อความที่เป็นการอนาจาร , ข่มขู่ , ก่อกวนหรืออื่นๆที่ทำให้คุณ\nไม่สบายใจ เราจะพิจารณาในการระงับบัญชีผู้ใช้งาน',
                    style: TextStyle(
                        fontSize: a.width / 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: a.width,
                    decoration: BoxDecoration(
                        color: Color(0xff282828),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0))),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: a.width / 13,
                        fontWeight: FontWeight.w300,
                      ),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '@somename',
                        hintStyle: TextStyle(color: Colors.grey[700]),
                      ),
                      validator: ((val) {
                        return val.trim() == null || val.trim() == ''
                            ? Taoast().toast("") 
                            : "";
                            
                      }
                      ),
                      //onSaved: (gId) => id = gId.trim(),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: a.height / 2.3,
                        width: a.width,
                        color: Color(0xff282828),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.image,
                                size: a.width / 4,
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
                        right: 15.0,
                        top: 10.0,
                        child: Text(
                          '0 ภาพ',
                          style : TextStyle(fontSize: a.width / 17 , color: Colors.grey[300])
                        )
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: a.height / 4.5,
                    width: a.width,
                    decoration: BoxDecoration(
                        color: Color(0xff282828),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16.0))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'เบอร์โทรศัพท์',
                          style: TextStyle(
                              fontSize: a.width / 17, color: Color(0xff5F5F5F)),
                        ),
                        Text(
                          '063-303-8380',
                          style: TextStyle(
                              fontSize: a.width / 12, color: Color(0xff5F5F5F)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: a.width / 18,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'เปลี่ยนเบอร์โทรศัพท์',
                              style: TextStyle(
                                  fontSize: a.width / 18, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /* Form(
                  //id section
                  key: _key,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      inputBox(a, 'ชื่อของคุณ', widget.doc['id']),
                    ],
                  ),
                ), //id section */
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
