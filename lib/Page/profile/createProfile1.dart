import 'dart:io'; //ref from creatProfile

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:scrap/widget/Toast.dart';

class CreateProfile1 extends StatefulWidget {
  final String uid;
  CreateProfile1({@required this.uid});
  @override
  _CreateProfile1State createState() => _CreateProfile1State();
}

class _CreateProfile1State extends State<CreateProfile1> {
  var _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String date, genders, name, created, lname, selectYear, id;
  File image;
  bool loading = false;

  @override
  void initState() {
    date = DateFormat('d/M/y').format(selectedDate);
    created = DateFormat('d/M/y').format(selectedDate);
    selectYear = DateFormat('y').format(selectedDate);
    super.initState();
  }

  sendCam() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  sendPic() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  Future cimg(File img, String uuid, String imgNm) async {
    final StorageReference ref = FirebaseStorage.instance.ref().child(imgNm);
    final StorageUploadTask task = ref.putFile(img);
    var picUrl = await (await task.onComplete).ref.getDownloadURL();
    await addImg(uuid, picUrl);
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
    for (int i = 0; i <= id.length; i++) {
      index.add(i == 0 ? id[0] : id.substring(0, i));
    }
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .collection('info')
        .document(uid)
        .setData({
      'name': name + ' ' + lname,
      'birthDay': date,
      'genders': genders,
      'createdDay': created
    });
    await cimg(image, widget.uid, widget.uid + '_pro');
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .updateData({'id': id, 'searchIndex': index});
  }

  creatProfile() async {
    try {
      await addData(widget.uid);
    } catch (e) {
      setState(() {
        loading = false;
      });
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
                  color: Colors.black,
                  height: scr.height,
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
                              'บัญชีผู้ใช้',
                              style: TextStyle(
                                fontSize: scr.width / 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'เพิ่มข้อมูลเพื่อให้ผู้คนค้นหาคุณเจอ',
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
                          margin: EdgeInsets.only(top: scr.height / 15),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  width: scr.width / 2.4,
                                  height: scr.width / 2.4,
                                  decoration: BoxDecoration(
                                    color: Color(0xff26A4FF),
                                    borderRadius: BorderRadius.circular(
                                      scr.width / 3,
                                    ),
                                    border: Border.all(
                                        width: 3, color: Colors.white),
                                  ),
                                  child: ClipRRect(
                                      child: image == null
                                          ? SizedBox(
                                              child: Icon(
                                                Icons.image,
                                                size: scr.width / 6,
                                                color: Colors.white,
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
                              Container(
                                // padding: EdgeInsets.all(16),
                                // color: Colors.grey[300],
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Column(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.stretch,
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: scr.width / 16),
                                            width: scr.width / 1.5,
                                            height: scr.height / 11.5,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.only(
                                                  topRight:
                                                      const Radius.circular(
                                                          10.0),
                                                  bottomRight:
                                                      const Radius.circular(
                                                          10.0),
                                                  topLeft:
                                                      const Radius.circular(
                                                          10.0),
                                                  bottomLeft:
                                                      const Radius.circular(
                                                          10.0)),
                                              border: Border(
                                                top: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.white),
                                                left: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.white),
                                                right: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.white),
                                                bottom: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: scr.width / 13,
                                                fontWeight: FontWeight.w900,
                                              ),
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: '@somename',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[500]),
                                              ),
                                              validator: ((val) {
                                                return val.trim() == null ||
                                                        val.trim() == ''
                                                    ?  Taoast().toast("กรุณาใส่ @ นำหน้าไอดี") 
                                                    : "";
                                              }),
                                              onSaved: (gId) => id = gId.trim(),
                                              textInputAction:
                                                  TextInputAction.next,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top:15),
                                        child: Text(
                                          'คุณสามารถเลือกรูปแบบ\nไม่เปิดเผยตัวตนได้ในขณะที่คุณใช้งาน',
                                          style: TextStyle(
                                            fontSize: scr.width / 19,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w100,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: scr.height / 15,
                                            left: scr.width / 6.5,
                                            right: scr.width / 6.5),
                                        child: MaterialButton(
                                          child: Text(
                                            'ต่อไป',
                                            style: TextStyle(fontSize: scr.width/13 , fontWeight: FontWeight.w900 , color: Colors.black),
                                          ),
                                          onPressed: () async {},
                                          color: Colors.white,
                                          elevation: 0,
                                          height: 60,
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(300),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
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
      ),
    );
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
