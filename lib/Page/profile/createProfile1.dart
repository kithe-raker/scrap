import 'dart:io'; //ref from creatProfile
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scrap/provider/UserData.dart';
import 'package:scrap/widget/ScreenUtil.dart';
import 'package:scrap/widget/Toast.dart';
import 'package:scrap/Page/profile/createProfile2.dart';

class CreateProfile1 extends StatefulWidget {
  @override
  _CreateProfile1State createState() => _CreateProfile1State();
}

class _CreateProfile1State extends State<CreateProfile1> {
  var _formKey = GlobalKey<FormState>();
  String id, pass;
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

  Widget next() {
    Size scr = MediaQuery.of(context).size;
    if (checkpass.text != '' &&
        checkpass.text != null &&
        checkid.text != '' &&
        checkid.text != null) {
      return Container(
        child: GestureDetector(
          child: Container(
            // margin: EdgeInsets.only(top: scr.width / 16),
            padding: EdgeInsets.all(appBarHeight / 7),
            width: scr.width / 1.5,
            height: scr.height / 15,
            decoration: BoxDecoration(
                color: Color(0xff26A4FE),
                borderRadius: BorderRadius.all(Radius.circular(7))),
            child: Text(
              'ต่อไป',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: s52,
                  fontWeight: FontWeight.w900,
                  color: Color(0xfffFFFFFF)),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateProfile2()),
            );
          },
        ),
      );
    } else {
      return Container(
        // margin: EdgeInsets.only(top: scr.width / 16),
        padding: EdgeInsets.all(appBarHeight / 7),
        width: scr.width / 1.5,
        height: scr.height / 15,
        decoration: BoxDecoration(
            color: Color(0xff515151),
            borderRadius: BorderRadius.all(Radius.circular(7))),
        child: Text(
          'ต่อไป',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: s52,
              fontWeight: FontWeight.w900,
              color: Color(0xfffFFFFFF).withOpacity(0.38)),
        ),
      );
    }
  }

  TextEditingController checkid = TextEditingController();
  TextEditingController checkpass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size scr = MediaQuery.of(context).size;
    screenutilInit(context);
    final user = Provider.of<UserData>(context, listen: false);
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: scr.width / 3,
                          ),
                          child: Text(
                            'สร้างไอดี',
                            style: TextStyle(
                              fontSize: scr.width / 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: appBarHeight / 3.5),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  child: Container(
                                    width: scr.width / 2.4,
                                    height: scr.width / 2.4,
                                    decoration: BoxDecoration(
                                      color: Color(0xff6A6A6A),
                                      borderRadius: BorderRadius.circular(
                                        scr.width / 3,
                                      ),
                                      border: Border.all(
                                          width: 3, color: Colors.white),
                                    ),
                                    child: ClipRRect(
                                        child: image == null
                                            ? SizedBox(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.person,
                                                      size: scr.width / 5,
                                                      color: Color(0xfffffffff)
                                                          .withOpacity(0.37),
                                                    ),
                                                    Text(
                                                      'เพิ่มรูป',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: s42,
                                                        color: Color(
                                                                0xfffffffff)
                                                            .withOpacity(0.37),
                                                      ),
                                                    ),
                                                  ],
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
                                              width: scr.width / 1.5,
                                              height: scr.height / 15,
                                              decoration: BoxDecoration(
                                                  color: Color(0xfff272727),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7))),
                                              child: TextFormField(
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: s52,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: '@somename',
                                                  hintStyle: TextStyle(
                                                      fontSize: s52,
                                                      height: 1.2,
                                                      color: Color(0xffFFFFFF)
                                                          .withOpacity(0.15)),
                                                ),
                                                validator: ((val) {
                                                  return val.trim() == null ||
                                                          val.trim() == ''
                                                      ? Taoast().toast(
                                                          "กรุณาใส่ไอดีของท่าน")
                                                      : null;
                                                }),
                                                onChanged: (val) {
                                                  checkid.text = val.trim();
                                                  checkid.selection =
                                                      TextSelection.fromPosition(
                                                          TextPosition(
                                                              offset: checkid
                                                                  .text
                                                                  .length));
                                                  setState(() {});
                                                },
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
                                            //pass
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: scr.width / 16),
                                              width: scr.width / 1.5,
                                              height: scr.height / 15,
                                              decoration: BoxDecoration(
                                                  color: Color(0xfff272727),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7))),
                                              child: TextFormField(
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: s52,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                                obscureText: true,
                                                //autofocus: false,
                                                //obscureText: true,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'password',
                                                  hintStyle: TextStyle(
                                                      fontSize: s52,
                                                      height: 1.2,
                                                      color: Color(0xffFFFFFF)
                                                          .withOpacity(0.15)),
                                                ),
                                                controller: checkpass,
                                                onChanged: (val2) {
                                                  checkpass.text = val2.trim();
                                                  checkpass.selection =
                                                      TextSelection.fromPosition(
                                                          TextPosition(
                                                              offset: checkpass
                                                                  .text
                                                                  .length));
                                                  setState(() {});
                                                },
                                                validator: ((val) {
                                                  return val.trim() == null ||
                                                          val.trim() == ''
                                                      ? Taoast().toast(
                                                          "กรุณาใส่พาสเวิร์ดของท่าน")
                                                      : null;
                                                }),
                                                textInputAction:
                                                    TextInputAction.done,
                                              ),
                                            ),
                                            SizedBox(
                                              height: appBarHeight,
                                            ),
                                            next(),
                                          ],
                                        ),
                                        /*Padding(
                                          padding: EdgeInsets.only(
                                              top: scr.height / 15,
                                              left: scr.width / 6.5,
                                              right: scr.width / 6.5),
                                          child: MaterialButton(
                                            child: next(),
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
                                                                        uid: user
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
                                            color: Color(0xfff515151),
                                            elevation: 0,
                                            height: appBarHeight / 1.2,
                                            textColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),*/
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
