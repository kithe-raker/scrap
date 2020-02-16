import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final DocumentSnapshot doc;
  EditProfile({@required this.doc});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
                    FloatingActionButton.extended(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        //save
                      },
                      icon: Icon(
                        Icons.save,
                        color: Colors.black,
                        size: a.width / 20,
                      ),
                      label: Text(
                        "บันทึก",
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
                    'แก้ไขบัญชี',
                    style: TextStyle(
                        fontSize: a.width / 6.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: a.height / 4.5,
                        width: a.width,
                        decoration: BoxDecoration(
                            color: Color(0xff282828),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(left: 20, right: 13),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(a.width),
                                      border: Border.all(
                                          color: Colors.white,
                                          width: a.width / 190)),
                                  width: a.width / 3.3,
                                  height: a.width / 3.3,
                                  child: Image.asset("assets/userprofile.png")),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                          Icons.create,
                          color: Color(0xff5F5F5F),
                          size: 30.0,
                        ),
                      )
                    ],
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.mail,
                                    color: Colors.white,
                                    size: a.width / 13,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'อีเมล',
                                    style: TextStyle(
                                        fontSize: a.width / 13,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: a.width / 30),
                                padding: EdgeInsets.only(left: 15),
                                width: a.width,
                                height: a.height / 11.5,
                                decoration: BoxDecoration(
                                  color: Color(0xff363636),
                                  borderRadius: BorderRadius.only(
                                      topRight: const Radius.circular(10.0),
                                      bottomRight: const Radius.circular(10.0),
                                      topLeft: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0)),
                                ),
                                child: TextFormField(
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: a.width / 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'name@mail.com',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[700]),
                                  ),
                                  validator: ((val) {
                                    return val.trim() == null ||
                                            val.trim() == ''
                                        ? ' '
                                        : null;
                                  }),
                                  onSaved: (gId) => id = gId.trim(),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              SizedBox(height: a.height / 30),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                    size: a.width / 13,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'รหัสผ่าน',
                                    style: TextStyle(
                                        fontSize: a.width / 13,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: a.width / 30),
                                padding: EdgeInsets.only(left: 15),
                                width: a.width,
                                height: a.height / 11.5,
                                decoration: BoxDecoration(
                                  color: Color(0xff363636),
                                  borderRadius: BorderRadius.only(
                                      topRight: const Radius.circular(10.0),
                                      bottomRight: const Radius.circular(10.0),
                                      topLeft: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0)),
                                ),
                                child: TextFormField(
                                  obscureText: true,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    letterSpacing: 10,
                                    color: Colors.white,
                                    fontSize: a.width / 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '••••••••',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[700]),
                                  ),
                                  validator: ((val) {
                                    return val.trim() == null ||
                                            val.trim() == ''
                                        ? ' '
                                        : null;
                                  }),
                                  onSaved: (gId) => id = gId.trim(),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10.0,
                        top: 10.0,
                        child: Icon(
                          Icons.create,
                          color: Color(0xff5F5F5F),
                          size: 30.0,
                        ),
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
                            SizedBox(width : 5),
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
