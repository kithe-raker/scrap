import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationHistory extends StatefulWidget {
  final DocumentSnapshot doc;
  NotificationHistory({@required this.doc});
  @override
  _NotificationHistoryState createState() => _NotificationHistoryState();
}

class _NotificationHistoryState extends State<NotificationHistory> {
  var _key = GlobalKey<FormState>();
  String id;

  summit(String uid) async {
    List index = [];
    for (int i = 0; i <= id.length; i++) {
      index.add(i == 0 ? id[0] : id.substring(0, i));
    }
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .updateData({'id': id, 'NotificationHistoryIndex': index});
  }

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
                        Icons.clear_all,
                        color: Color(0xff26A4FF),
                        size: a.width / 20,
                      ),
                      label: Text(
                        "ล้าง",
                        style: TextStyle(
                            color: Color(0xff26A4FF), fontSize: a.width / 16),
                      ),
                    ),
                  ],
                ), //back btn

                SizedBox(height: a.height / 12.5),

                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'การแจ้งเตือน',
                        style: TextStyle(
                            fontSize: a.width / 6.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    //////////// make widget ////////////////////
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 5.0, right: 5.0),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: a.height / 7,
                            width: a.width,
                            decoration: BoxDecoration(
                                color: Color(0xff282828),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(0.0),
                                )),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              '@somename ',
                                              style: TextStyle(
                                                  fontSize: a.width / 15,
                                                  color: Color(0xff26A4FF)),
                                            ),
                                            Text(
                                              'ปากระดาษใส่คุณ',
                                              style: TextStyle(
                                                  fontSize: a.width / 15,
                                                  color: Colors.grey[300]),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '14:49 15/02/2020',
                                          style: TextStyle(
                                              fontSize: a.width / 18,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                          Positioned(
                            right: 10.0,
                            top: 10.0,
                            child: Icon(
                              Icons.clear,
                              color: Color(0xffA3A3A3),
                              size: 30.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 5.0, right: 5.0),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: a.height / 7,
                            width: a.width,
                            decoration: BoxDecoration(
                                color: Color(0xff282828),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(0.0),
                                )),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'ใครบางคน ',
                                              style: TextStyle(
                                                  fontSize: a.width / 15,
                                                  color: Colors.grey[300]),
                                            ),
                                            Text(
                                              'ปากระดาษใส่คุณ',
                                              style: TextStyle(
                                                  fontSize: a.width / 15,
                                                  color: Colors.grey[300]),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '14:49 15/02/2020',
                                          style: TextStyle(
                                              fontSize: a.width / 18,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                          Positioned(
                            right: 10.0,
                            top: 10.0,
                            child: Icon(
                              Icons.clear,
                              color: Color(0xffA3A3A3),
                              size: 30.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 5.0, right: 5.0),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: a.height / 7,
                            width: a.width,
                            decoration: BoxDecoration(
                                color: Color(0xff282828),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(0.0),
                                )),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'ใครบางคน ',
                                              style: TextStyle(
                                                  fontSize: a.width / 15,
                                                  color: Colors.grey[300]),
                                            ),
                                            Text(
                                              'อ่านกระดาษที่คุณโยนทิ้งไว้',
                                              style: TextStyle(
                                                  fontSize: a.width / 15,
                                                  color: Colors.grey[300]),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '14:49 15/02/2020',
                                          style: TextStyle(
                                              fontSize: a.width / 18,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                          Positioned(
                            right: 10.0,
                            top: 10.0,
                            child: Icon(
                              Icons.clear,
                              color: Color(0xffA3A3A3),
                              size: 30.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 5.0, right: 5.0),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: a.height / 7,
                            width: a.width,
                            decoration: BoxDecoration(
                                color: Color(0xff282828),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(0.0),
                                )),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              '@somename ',
                                              style: TextStyle(
                                                  fontSize: a.width / 15,
                                                  color: Color(0xff26A4FF)),
                                            ),
                                            Text(
                                              'อ่านกระดาษที่คุณปาใส่',
                                              style: TextStyle(
                                                  fontSize: a.width / 15,
                                                  color: Colors.grey[300]),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '14:49 15/02/2020',
                                          style: TextStyle(
                                              fontSize: a.width / 18,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                          Positioned(
                            right: 10.0,
                            top: 10.0,
                            child: Icon(
                              Icons.clear,
                              color: Color(0xffA3A3A3),
                              size: 30.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    //////////// make widget ////////////////////
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget inputBox(Size a, String hint, String value) {
    var tx = TextEditingController();
    tx.text = value;
    return Container(
      width: a.width,
      height: a.width / 6,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(a.width)),
      child: TextFormField(
        style: TextStyle(color: Colors.black, fontSize: a.width / 15),
        controller: tx,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            labelStyle: TextStyle(color: Colors.black, fontSize: a.width / 15)),
        validator: (val) {
          return val.trim() == "" ? 'กรุณากรอก' : null;
        },
        onSaved: (val) {
          val.trim()[0] == '@' ? id = val.trim().substring(1) : id = val.trim();
        },
      ),
    );
  }
}
