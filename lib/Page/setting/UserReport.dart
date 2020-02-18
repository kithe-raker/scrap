import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UserReport extends StatefulWidget {
  final String uid;
  UserReport({@required this.uid});
  @override
  _UserReportState createState() => _UserReportState();
}

//
//
class _UserReportState extends State<UserReport> {
  var _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String created, describe, selectYear, id;
  File image;
  bool loading = false;

  @override
  void initState() {
    created = DateFormat('d/M/y').format(selectedDate);
    selectYear = DateFormat('y').format(selectedDate);
    super.initState();
  }

  sendCam() async {
    File img = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 25);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  sendPic() async {
    File img = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 25);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  Future cimg(File img, String docRef) async {
    final StorageReference ref = FirebaseStorage.instance.ref().child(docRef);
    final StorageUploadTask task = ref.putFile(img);
    var picUrl = await (await task.onComplete).ref.getDownloadURL();
    await addImg(docRef, picUrl);
    if (task.isInProgress) {
      setState(() {
        loading = true;
      });
    } else {
      print('complet');
    }
  }

  addImg(String ref, String pic) async {
    await Firestore.instance.collection('Report').document(ref).updateData({
      'img': pic,
    });
  }

  addData() async {
    await Firestore.instance
        .collection('Report')
        .add({'createdDay': created, 'id': widget.uid}).then((value) {
      if (image == null) {
        cimg(image, value.documentID);
      }
    });
  }

  report() async {
    try {
      await addData();
    } catch (e) {
      setState(() {
        loading = false;
      });
      warnDate('เกิดข้อผิดพลาดของระบบ');
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size scr = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                height: scr.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          scr.width / 13.5, 0, scr.width / 13.5, 0),
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // image section
                            InkWell(
                              child: Container(
                                width: scr.width / 3,
                                height: scr.width / 3,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(
                                      scr.width / 3,
                                    )),
                                child: ClipRRect(
                                    child: image == null
                                        ? SizedBox(
                                            child: Icon(
                                              Icons.edit,
                                            ),
                                          )
                                        : Image.file(
                                            image,
                                            width: scr.width / 3,
                                            height: scr.width / 3,
                                            fit: BoxFit.cover,
                                          ),
                                    borderRadius: BorderRadius.circular(
                                      scr.width / 3,
                                    )),
                              ),
                              onTap: () {
                                selectImg(context);
                              },
                            ),

                            //id section
                            Container(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Container(
                                      width: scr.width,
                                      height: scr.height / 12,
                                      child: TextFormField(
                                        validator: ((val) {
                                          return val.trim() == null ||
                                                  val.trim() == ''
                                              ? 'กรุณากรอกคำอธิบาย'
                                              : null;
                                        }),
                                        onSaved: (gDescribe) =>
                                            describe = gDescribe.trim(),
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            hintText:
                                                'อธิบายปัญหาที่ท่านพบเจอภายในแอปพลิเคชั่น'),
                                      ),
                                    ),

                                           Container(
                                      width: scr.width,
                                      height: scr.height / 12,
                                      child: TextFormField(
                                        validator: ((val) {
                                          return val.trim() == null ||
                                                  val.trim() == ''
                                              ? 'กรุณากรอกคำอธิบาย'
                                              : null;
                                        }),
                                        onSaved: (gDescribe) =>
                                            describe = gDescribe.trim(),
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                            hintText:
                                                'อธิบายปัญหาที่ท่านพบเจอภายในแอปพลิเคชั่น'),
                                      ),
                                    ),
                                    
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: scr.height / 10),
                                      child: MaterialButton(
                                        child: Text(
                                          'รายงาน',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        onPressed: () async {
                                          _formKey.currentState.save();
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              loading = true;
                                            });
                                            await report();
                                          }
                                        },
                                        color: Color(0xffEF7D36),
                                        elevation: 0,
                                        minWidth: 350,
                                        height: 60,
                                        textColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox()
      ],
    ));
  }

  warnDate(String warn) {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              child: Text(warn),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ok'))
            ],
          );
        });
  }

  selectImg(BuildContext context) {
    Size scr = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        contentPadding: EdgeInsets.all(3),
        content: Container(
          height: scr.height / 3.8,
          width: scr.width / 1.1,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20, top: 20),
                child: Text(
                  "อัปโหลดรูปภาพ",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  iconImg(
                    Icons.image,
                    () {
                      sendPic();
                      Navigator.pop(context);
                    },
                  ),
                  iconImg(Icons.camera_alt, () {
                    sendCam();
                    Navigator.pop(context);
                  })
                ],
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ยกเลิก',
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget iconImg(IconData icon, Function func) {
    Size scr = MediaQuery.of(context).size;
    return Container(
      width: scr.width / 1.1 / 2.8,
      height: scr.height / 6.4,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(18)),
      child: IconButton(
          icon: Icon(
            icon,
            size: scr.width / 6,
            color: Colors.grey[800],
          ),
          onPressed: func),
    );
  }
}

/* class _UserReportState extends State<UserReport> {
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
                      onPressed: () {},
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
                ),
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
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '@somename',
                        hintStyle: TextStyle(color: Colors.grey[700]),
                      ),
                      validator: ((val) {
                        return val.trim() == null || val.trim() == ''
                            ? Taoast().toast("") 
                            : null;
                      }),
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
                          child: Text('0 ภาพ',
                              style: TextStyle(
                                  fontSize: a.width / 17,
                                  color: Colors.grey[300])))
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
              ],
            ),
          ),
        ),
      ]),
    );
  }
} */
