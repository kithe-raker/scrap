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
