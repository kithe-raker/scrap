import 'dart:async';
import 'dart:io'; //ref from creatProfile
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scrap/Page/profile/createProfile2.dart';
import 'package:scrap/function/authServices/authService.dart';
import 'package:scrap/provider/authen_provider.dart';
import 'package:scrap/widget/Loading.dart';
import 'package:scrap/widget/Toast.dart';

class CreateProfile1 extends StatefulWidget {
  @override
  _CreateProfile1State createState() => _CreateProfile1State();
}

class _CreateProfile1State extends State<CreateProfile1> {
  var _formKey = GlobalKey<FormState>();
  String pName;
  dynamic image;
  bool loading = true;
  FirebaseUser user;
  StreamSubscription loadStatus;
  var nameController = TextEditingController();

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

  initUserInfo() async {
    user = await fireAuth.currentUser();
    nameController.text = user?.displayName ?? null;
    image = user?.photoUrl ?? null;
    loading = false;
    setState(() {});
    loadStatus =
        authService.load.listen((value) => setState(() => loading = value));
  }

  validator() async {
    authService.load.add(true);
    image != null || user?.photoUrl != null
        ? await authService.hasAccount('pName', pName)
            ? authService.warn('นามนี้ได้ทำการลงทะเบียนไว้แล้ว', context)
            : register()
        : authService.warn('กรุณาเลือกรูปโปรไฟล์ของท่าน', context);
  }

  register() async {
    final authenInfo = Provider.of<AuthenProvider>(context, listen: false);
    authenInfo.img = image;
    authenInfo.pName = pName;
    await fireStore
        .collection('Account')
        .document(user.uid)
        .setData({'pName': pName}, merge: true);
    authService.navigatorReplace(context, CreateProfile2());
    authService.load.add(false);
  }

  @override
  void initState() {
    super.initState();
    initUserInfo();
  }

  @override
  void dispose() {
    loadStatus.cancel();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size scr = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => null,
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
                                            : image.runtimeType == String
                                                ? Image.network(
                                                    user.photoUrl,
                                                    width: scr.width / 3,
                                                    height: scr.width / 3,
                                                    fit: BoxFit.cover,
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
                                                controller: nameController,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: scr.width / 13,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'penname',
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey[500]),
                                                ),
                                                validator: ((val) {
                                                  return val.trim() == ''
                                                      ? Taoast().toast(
                                                          "กรุณาใส่นามปากกาของท่าน")
                                                      : null;
                                                }),
                                                onSaved: (name) =>
                                                    pName = name.trim(),
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
                                                validator();
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
            loading ? Loading() : SizedBox()
          ],
        ),
      ),
    );
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
