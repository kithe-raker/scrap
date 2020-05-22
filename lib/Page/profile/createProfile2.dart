import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/widget/warning.dart';

bool checkpromise = false;

class CreateProfile2 extends StatefulWidget {
  final String uid;
  final Map pro;
  CreateProfile2({@required this.uid, @required this.pro});
  @override
  _CreateProfile2State createState() => _CreateProfile2State();
}

class _CreateProfile2State extends State<CreateProfile2> {
  var _formKey = GlobalKey<FormState>();
  DateTime now = DateTime.now(), bDay;
  String genders, selectYear;
  bool loading = false;

  Widget finished() {
    return Container(
      child: GestureDetector(
        onTap: () {
          print('success');
        },
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: appBarHeight / 10),
            decoration: BoxDecoration(
                color: Color(0xfff26A4FE),
                borderRadius: BorderRadius.all(Radius.circular(7))),
            height: appBarHeight / 1.7,
            width: appBarHeight * 3.2,
            child: Text(
              'เสร็จสิ้น',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: s48,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget unfinished() {
    return Container(
      child: GestureDetector(
        onTap: () {
          print('Kuay');
          if (bDay != now) {
            _formKey.currentState.save();
            setState(() {
              loading = true;
            });
            //await creatProfile();
          } else {
            bDay == now ? Taoast().toast('อย่าลืมเลือกวันเกิดของคุณ') : null;
          }
        },
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: appBarHeight / 10),
            decoration: BoxDecoration(
                color: Color(0xfff515151),
                borderRadius: BorderRadius.all(Radius.circular(7))),
            height: appBarHeight / 1.7,
            width: appBarHeight * 3.2,
            child: Text(
              'เสร็จสิ้น',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: s48,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget finish() {
    if (genders != null && checkpromise != false && bDay != now) {
      return finished();
    } else
      return unfinished();
  }

  @override
  void initState() {
    bDay = now;
    selectYear = DateFormat('y').format(now);
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(1990, 1, 1),
        firstDate: DateTime(1950, 1),
        lastDate: DateTime(int.parse(selectYear) - 17, 1));
    if (picked != null && picked != now)
      setState(() {
        bDay = picked;
      });
  }

  Future cimg(File img, String uid, String imgNm) async {
    final StorageReference ref = FirebaseStorage.instance.ref().child(imgNm);
    final StorageUploadTask task = ref.putFile(img);
    var picUrl = await (await task.onComplete).ref.getDownloadURL();
    await addImg(uid, picUrl);
    if (task.isInProgress) {
      setState(() {
        loading = true;
      });
    } else {
      print('complet');
    }
  }

  addImg(String uid, String pic) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document(uid)
        .updateData({
      'img': pic,
    });
  }

  addData(String uid) async {
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document(uid)
        .setData({
      'birthDay': bDay,
      'genders': genders ?? '',
      'createdDay': FieldValue.serverTimestamp()
    });
    await cimg(widget.pro['img'], uid, uid + '_pro');
    await addID(uid);
    setState(() {
      loading = false;
    });
  }

  addID(String uid) async {
    await Firestore.instance
        .collection('SearchUsers')
        .document(widget.pro['id'][0])
        .collection('users')
        .document(uid)
        .setData({
      'id': widget.pro['id'],
      'uid': uid,
    });
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .updateData({'id': widget.pro['id']});
  }

  creatProfile() async {
    try {
      setState(() {
        loading = true;
      });
      await addData(widget.uid);
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Authen()));
    } catch (e) {
      setState(() {
        loading = false;
      });
      Dg().warnDate(context, 'เกิดข้อผิดพลาดไม่ทราบสาเหตุกรุณาลองอีกครั้ง');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size scr = MediaQuery.of(context).size;
    screenutilInit(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: appBarHeight,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: scr.width / 10, left: scr.width / 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'เกือบเสร็จแล้ว!',
                          style: TextStyle(
                            fontSize: scr.width / 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'สำหรับการให้ของขวัญในโอกาสพิเศษ',
                          style: TextStyle(
                            fontSize: scr.width / 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
                    margin: EdgeInsets.only(top: scr.width / 15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'วันเกิด',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: scr.width / 8),
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () => _selectDate(context),
                                    child: Icon(
                                      Icons.date_range,
                                      size: scr.width / 12,
                                      color: Color(0xff26A4FF),
                                    ),
                                  ),
                                  SizedBox(
                                    width: appBarHeight / 10,
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      DateFormat('d/M/y').format(bDay),
                                      style: TextStyle(
                                        fontSize: scr.width / 10,
                                        color: Color(0xff26A4FF),
                                      ),
                                    ),
                                    onTap: () => _selectDate(context),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'เพศ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: scr.width / 8),
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: appBarHeight / 10,
                                  ),
                                  Radio(
                                    onChanged: (String ty) {
                                      setState(() => genders = ty);
                                    },
                                    value: 'ชาย',
                                    groupValue: genders,
                                    activeColor: Color(0xff26A4FF),
                                  ),
                                  Text(
                                    'ชาย',
                                    style: TextStyle(
                                        fontSize: s60, color: Colors.white),
                                  ),
                                  Radio(
                                    onChanged: (String ty) {
                                      setState(() => genders = ty);
                                    },
                                    value: 'หญิง',
                                    groupValue: genders,
                                    activeColor: Color(0xff26A4FF),
                                  ),
                                  Text(
                                    'หญิง',
                                    style: TextStyle(
                                        fontSize: s60, color: Colors.white),
                                  ),
                                  Radio(
                                    onChanged: (String ty) {
                                      setState(() => genders = ty);
                                    },
                                    value: '',
                                    groupValue: genders,
                                    activeColor: Color(0xff26A4FF),
                                  ),
                                  Text(
                                    'อื่นๆ',
                                    style: TextStyle(
                                        fontSize: s60, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: appBarHeight / 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Checkbox(
                                value: checkpromise,
                                onChanged: (bool value) {
                                  setState(() {
                                    checkpromise = value;
                                  });
                                },
                              ),
                              Text(
                                'ฉันได้อ่านและยอมรับ\t',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: s42,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'นโยบายและข้อกำหนด',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color(0xfff26A4FF),
                                    fontSize: s42,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: appBarHeight / 2),
                          finish(),
                          /* Padding(
                            padding: EdgeInsets.only(top: appBarHeight / 2.5),
                            child: 
                            
                            
                            MaterialButton(
                              child: Text('เสร็จสิ้น',
                                  style: TextStyle(
                                    fontSize: scr.width / 15,
                                    color: Color(0xfffffffff),
                                    fontWeight: FontWeight.w800,
                                  )),
                              onPressed: () async {
                                if (bDay != now) {
                                  _formKey.currentState.save();
                                  setState(() {
                                    loading = true;
                                  });
                                  await creatProfile();
                                } else {
                                  bDay == now
                                      ? Taoast()
                                          .toast('อย่าลืมเลือกวันเกิดของคุณ')
                                      : null;
                                }
                              },
                              color: Color(0xff26A4FF),
                              elevation: 0,
                              minWidth: 350,
                              height: 60,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            loading ? Loading() : SizedBox()
          ],
        ),
      ),
    );
  }
}
