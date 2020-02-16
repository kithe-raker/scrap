import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final DocumentSnapshot doc;
  Search({@required this.doc});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
        .updateData({'id': id, 'searchIndex': index});
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
                        'ค้นหาผู้ใช้',
                        style: TextStyle(
                            fontSize: a.width / 6.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),
                      Text(
                        'ค้นหาคนที่คุณรู้จักแล้วปากระดาษใส่พวกเขากัน',
                        style: TextStyle(
                            fontSize: a.width / 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: a.width / 13,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: a.width,
                    decoration: BoxDecoration(
                      color: Color(0xff282828),
                      borderRadius: BorderRadius.all(Radius.circular(300)),
                      border: Border.all(width: 2, color: Colors.grey[800]),
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: a.width / 12,
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
                            ? ' '
                            : null;
                      }),
                      //onSaved: (gId) => id = gId.trim(),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),

                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 50.0, left: 5.0, right: 5.0),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: a.height / 4.5,
                            width: a.width,
                            decoration: BoxDecoration(
                                color: Color(0xff282828),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0),
                                )),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 20, right: 13),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(a.width),
                                          border: Border.all(
                                              color: Colors.white,
                                              width: a.width / 190)),
                                      width: a.width / 3.3,
                                      height: a.width / 3.3,
                                      child: Image.asset(
                                          "assets/userprofile.png")),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '@somename',
                                        style: TextStyle(
                                            fontSize: a.width / 13,
                                            color: Colors.white),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Join ',
                                            style: TextStyle(
                                                fontSize: a.width / 11,
                                                color: Color(0xff26A4FF)),
                                          ),
                                          Text(
                                            '15/02/2020',
                                            style: TextStyle(
                                                fontSize: a.width / 11,
                                                color: Color(0xff26A4FF)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Positioned(
                            right: 10.0,
                            top: 10.0,
                            child: Icon(
                              Icons.arrow_forward,
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
                            height: a.height / 4.5,
                            width: a.width,
                            decoration: BoxDecoration(
                                color: Color(0xff282828),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0),
                                )),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 20, right: 13),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(a.width),
                                          border: Border.all(
                                              color: Colors.white,
                                              width: a.width / 190)),
                                      width: a.width / 3.3,
                                      height: a.width / 3.3,
                                      child: Image.asset(
                                          "assets/userprofile.png")),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '@somename',
                                        style: TextStyle(
                                            fontSize: a.width / 13,
                                            color: Colors.white),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Join ',
                                            style: TextStyle(
                                                fontSize: a.width / 11,
                                                color: Color(0xff26A4FF)),
                                          ),
                                          Text(
                                            '15/02/2020',
                                            style: TextStyle(
                                                fontSize: a.width / 11,
                                                color: Color(0xff26A4FF)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Positioned(
                            right: 10.0,
                            top: 10.0,
                            child: Icon(
                              Icons.arrow_forward,
                              color: Color(0xffA3A3A3),
                              size: 30.0,
                            ),
                          )
                        ],
                      ),
                    ),
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
