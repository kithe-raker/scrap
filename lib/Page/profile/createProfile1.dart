import 'dart:io'; //ref from creatProfile
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/Page/profile/createProfile2.dart';

class CreateProfile1 extends StatefulWidget {
  final String uid;
  CreateProfile1({@required this.uid});
  @override
  _CreateProfile1State createState() => _CreateProfile1State();
}

class _CreateProfile1State extends State<CreateProfile1> {
  var _formKey = GlobalKey<FormState>();
  String id;
  File image;
  bool loading = false;

  @override
  void initState() {
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

  Future<bool> hasAccount(String user) async {
    final QuerySnapshot users = await Firestore.instance
        .collection('Users')
        .where('id', isEqualTo: user)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> doc = users.documents;
    return doc.length == 1;
  }

  @override
  Widget build(BuildContext context) {
    Size scr = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () =>
          warning('คุณต้องการออกจากหน้านี้ใช่หรือไม่', function: () {
        Navigator.pop(context);
        Navigator.pop(context);
      }),
      child: Scaffold(
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
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: scr.width / 16),
                                              width: scr.width / 1.8,
                                              height: scr.height / 12.1,
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
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: '@yourname',
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey[500]),
                                                ),
                                                validator: ((val) {
                                                  return val.trim() == null ||
                                                          val.trim() == ''
                                                      ? Taoast().toast(
                                                          "กรุณาใส่ @ นำหน้าไอดี")
                                                      : null;
                                                }),
                                                onSaved: (gId) =>
                                                    gId.trim()[0] == '@'
                                                        ? id = gId
                                                            .trim()
                                                            .substring(1)
                                                        : id = gId.trim(),
                                                textInputAction:
                                                    TextInputAction.done,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 15),
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
                                              style: TextStyle(
                                                  fontSize: scr.width / 13,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.black),
                                            ),
                                            onPressed: () async {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                _formKey.currentState.save();
                                                image != null
                                                    ? await hasAccount(id)
                                                        ? warning(
                                                            'ไอดีนี้ได้ทำการลงทะเบียนไว้แล้ว')
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    CreateProfile2(
                                                                        uid: widget
                                                                            .uid,
                                                                        pro: {
                                                                          'img':
                                                                              image,
                                                                          'id':
                                                                              id
                                                                        })))
                                                    : warning(
                                                        'กรุณาเลือกรูปโปรไฟล์ของท่าน');
                                              }
                                            },
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
      ),
    );
  }

  warning(String warn, {Function function}) {
    return showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('ขออภัยค่ะ'),
            content: Container(
              child: Text(warn),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: function ??
                      () {
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
