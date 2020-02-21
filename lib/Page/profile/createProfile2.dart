import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/warning.dart';

import '../Auth.dart';

class CreateProfile2 extends StatefulWidget {
  final String uid;
  final Map pro;
  CreateProfile2({@required this.uid, @required this.pro});
  @override
  _CreateProfile2State createState() => _CreateProfile2State();
}

class _CreateProfile2State extends State<CreateProfile2> {
  var _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String bDay, genders, created, selectYear;
  bool loading = false;

  @override
  void initState() {
    bDay = DateFormat('d/M/y').format(selectedDate);
    created = DateFormat('d/M/y').format(selectedDate);
    selectYear = DateFormat('y').format(selectedDate);
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(1990, 1, 1),
        firstDate: DateTime(1950, 1),
        lastDate: DateTime(int.parse(selectYear), 1));
    if (picked != null && picked != selectedDate)
      setState(() {
        bDay = DateFormat('d/M/y').format(picked);
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
    List index = [];
    for (int i = 0; i <= widget.pro['id'].length; i++) {
      index
          .add(i == 0 ? widget.pro['id'][0] : widget.pro['id'].substring(0, i));
    }
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document(uid)
        .setData({'birthDay': bDay, 'genders': genders, 'createdDay': created});
    await cimg(widget.pro['img'], widget.uid, widget.uid + '_pro');
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .updateData({'id': widget.pro['id'], 'searchIndex': index});
    setState(() {
      loading = false;
    });
  }

  creatProfile() async {
    try {
      setState(() {
        loading = true;
      });
      await addData(widget.uid);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Authen()));
    } catch (e) {
      setState(() {
        loading = false;
      });
      Dg().warnDate(context,'เกิดข้อผิดพลาดไม่ทราบสาเหตุกรุณาลองอีกครั้ง');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size scr = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: scr.width / 20, left: scr.width / 20),
                    child: InkWell(
                      child: Container(
                        width: scr.width / 7,
                        height: scr.width / 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(scr.width),
                            color: Colors.white),
                        child: Icon(Icons.arrow_back,
                            color: Colors.black, size: scr.width / 15),
                      ),
                      onTap: () {
                        Navigator.pop(
                          context,
                        );
                      },
                    ),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  IconButton(
                                    padding: EdgeInsets.all(0),
                                    iconSize: scr.width / 9,
                                    icon: Icon(Icons.date_range),
                                    color: Color(0xff26A4FF),
                                    onPressed: () => _selectDate(context),
                                  ),
                                  FlatButton(
                                    child: Text(
                                      bDay,
                                      style: TextStyle(
                                        fontSize: scr.width / 10,
                                        color: Color(0xff26A4FF),
                                      ),
                                    ),
                                    onPressed: () => _selectDate(context),
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
                                'เพศของคุณ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: scr.width / 8),
                              ),
                              Row(
                                children: <Widget>[
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
                                        fontSize: scr.width / 10,
                                        color: Colors.white),
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
                                        fontSize: scr.width / 10,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
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
                                        fontSize: scr.width / 10,
                                        color: Colors.white),
                                  ),
                                  SizedBox(width: scr.width / 30),
                                  genders == ''
                                      ? Expanded(
                                          child: TextFormField(
                                          style: TextStyle(
                                              fontSize: scr.width / 12,
                                              color: Colors.white),
                                          validator: ((val) {
                                            return val.trim() == ''
                                                ? 'กรุณาระบุเพศ'
                                                : null;
                                          }),
                                          onSaved: (gen) =>
                                              genders = gen.trim(),
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: 'ระบุ',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400]),
                                          ),
                                        ))
                                      : SizedBox(width: scr.width / 20),
                                  SizedBox(width: scr.width / 10),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: scr.height / 15),
                            child: MaterialButton(
                              child: Text('เสร็จสิน',
                                  style: TextStyle(
                                    fontSize: scr.width / 12,
                                    color: Color(0xfffffffff),
                                    fontWeight: FontWeight.w800,
                                  )),
                              onPressed: () async {
                                _formKey.currentState.save();
                                if (_formKey.currentState.validate() &&
                                    genders != null &&
                                    bDay != created) {
                                  setState(() {
                                    loading = true;
                                  });
                                  await creatProfile();
                                } else {
                                  bDay == created
                                      ? Dg().warnDate(context,'อย่าลืมเลือกวันเกิดของคุณ')
                                      : Dg().warnDate(context,'อย่าลืมเลือกเพศของคุณ');
                                }
                              },
                              color: Color(0xff26A4FF),
                              elevation: 0,
                              minWidth: 350,
                              height: 60,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
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
