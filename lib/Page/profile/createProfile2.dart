import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/authenPage/AuthenPage.dart';
import 'package:scrap/function/authServices/authService.dart';
import 'package:scrap/function/others/resizeImage.dart';
import 'package:scrap/provider/authen_provider.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';

class CreateProfile2 extends StatefulWidget {
  @override
  _CreateProfile2State createState() => _CreateProfile2State();
}

class _CreateProfile2State extends State<CreateProfile2> {
  var _formKey = GlobalKey<FormState>();
  DateTime now = DateTime.now(), bDay;
  String genders, selectYear, region = 'th';
  bool loading = false;
  StreamSubscription loadStatus;

  Future<Null> _selectDate(BuildContext context) async {
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(1990, 1, 1),
        firstDate: DateTime(1950, 1),
        lastDate: DateTime(int.parse(selectYear) - 17, 1));
    if (picked != null && picked != now)
      setState(() {
        bDay = picked;
        authenInfo.birthday = picked;
      });
  }

  Future uploadImg(File img, String uid, String imgNm) async {
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    String type = Platform.isAndroid ? 'webp' : 'jpeg';
    var resizeImg = await resize.resize(image: img, type: type, quality: 40);

    var meta = StorageMetadata(contentType: 'image/$type');
    final StorageReference ref = FirebaseStorage.instance.ref().child(imgNm);
    final StorageUploadTask task = ref.putFile(resizeImg, meta);
    
    var picUrl = await (await task.onComplete).ref.getDownloadURL();
    authenInfo.img = picUrl;
    await addImg(uid, picUrl);
  }

  addImg(String uid, String pic) async {
    await Firestore.instance
        .collection('User')
        .document(region)
        .collection('users')
        .document(uid)
        .setData({
      'img': pic,
      'imgList': FieldValue.arrayUnion([pic])
    }, merge: true);
  }

  @override
  void initState() {
    selectYear = DateFormat('y').format(now);
    loadStatus =
        authService.load.listen((value) => setState(() => loading = value));
    super.initState();
  }

  @override
  void dispose() {
    loadStatus.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size scr = MediaQuery.of(context).size;
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () => null,
      child: Scaffold(
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
                                        DateFormat('d/M/y').format(bDay ?? now),
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
                                        authenInfo.gender = ty;
                                      },
                                      value: 'male',
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
                                        authenInfo.gender = ty;
                                      },
                                      value: 'female',
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
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                  hintText: 'ระบุ',
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey[400]),
                                                ),
                                                validator: (val) {
                                                  return val.trim() == ''
                                                      ? Taoast().toast(
                                                          'ระบุเพศของคุณ')
                                                      : null;
                                                },
                                                onSaved: (gen) {
                                                  genders = gen.trim();
                                                  authenInfo.gender =
                                                      gen.trim();
                                                }))
                                        : SizedBox(width: scr.width / 20),
                                    SizedBox(width: scr.width / 10),
                                  ],
                                ),
                                TextFormField(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: scr.width / 15,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'password',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w900,
                                      fontSize: scr.width / 15,
                                    ),
                                  ),
                                  validator: (val) {
                                    return val.trim() == ""
                                        ? Taoast()
                                            .toast("กรุณาใส่รหัสผ่านของคุณ")
                                        : val.trim().length < 6
                                            ? Taoast().toast(
                                                "รหัสผ่านต้องมี6หลักขึ้นไป")
                                            : null;
                                  },
                                  onSaved: (val) {
                                    authenInfo.password = val.trim();
                                  },
                                ),
                                TextFormField(
                                    style: TextStyle(
                                        fontSize: scr.width / 12,
                                        color: Colors.white),
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      hintText: 'ประเทศ',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                    ),
                                    validator: (val) {
                                      return val.trim() == ''
                                          ? Taoast().toast('ระบุประเทศของคุณ')
                                          : null;
                                    },
                                    onSaved: (region) {
                                      region = region.trim();
                                      authenInfo.region = region.trim();
                                    }),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: scr.height / 15),
                              child: MaterialButton(
                                child: Text('เสร็จสิ้น',
                                    style: TextStyle(
                                      fontSize: scr.width / 12,
                                      color: Color(0xfffffffff),
                                      fontWeight: FontWeight.w800,
                                    )),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    if (bDay != null && genders != null) {
                                      _formKey.currentState.save();
                                      creatAccount();
                                    } else {
                                      bDay == null
                                          ? Taoast().toast('เลือกวันเกิดของคุณ')
                                          : region == null
                                              ? Taoast().toast(
                                                  'เลือกประเทศที่คุณอยู่')
                                              : Taoast()
                                                  .toast('เลือกเพศของคุณ');
                                    }
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
      ),
    );
  }

  creatAccount() async {
    authService.load.add(true);
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    final uid = await authService.getuid();
    authenInfo.img.runtimeType == String
        ? await addImg(uid, authenInfo.img)
        : await uploadImg(authenInfo.img, uid, uid + '_pro0');
    await authService.setAccount(context);
    print('creat fin');
    authService.navigatorReplace(context, AuthenPage());
    authService.load.add(false);
  }
}
