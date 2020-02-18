import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrap/Page/OTPScreen.dart';
import 'package:scrap/widget/Toast.dart';

class EditProfile extends StatefulWidget {
  final DocumentSnapshot doc;
  final DocumentSnapshot info;
  EditProfile({@required this.doc, @required this.info});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var _key = GlobalKey<FormState>();
  bool read = true, readMail = true, loading = false;
  File image;
  String id;
  Map account = {};

  summitNewID(String uid) async {
    List index = [];
    for (int i = 0; i <= id.length; i++) {
      index.add(i == 0 ? id[0] : id.substring(0, i));
    }
    await Firestore.instance
        .collection('Users')
        .document(uid)
        .updateData({'id': id, 'searchIndex': index});
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

  newAccount() async {
    var user = await FirebaseAuth.instance.currentUser();
    if (user.email != account['email']) {
      user.updateEmail(account['email']);
      await updateAccount('email', account['email']);
    }
    if (widget.doc['password'] != account['password']) {
      user.updatePassword(account['password']);
      await updateAccount('password', account['password']);
    }
  }

  updateAccount(String key, String value) async {
    await Firestore.instance
        .collection('User')
        .document(widget.doc['uid'])
        .updateData({key: value});
  }

  saveEdit() async {
    try {
      if (id != widget.doc['id']) {
        await summitNewID(widget.doc['uid']);
      }
      if (image != null) {
        await cimg(image, widget.doc['uid'], widget.doc['uid'] + '_pro');
      }
      await newAccount();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(children: <Widget>[
        Form(
          key: _key,
          child: Container(
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
                          if (_key.currentState.validate()) {
                            _key.currentState.save();
                            saveEdit();
                          }
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
                                InkWell(
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 13),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(a.width),
                                        border: Border.all(
                                            color: Colors.white,
                                            width: a.width / 190)),
                                    width: a.width / 3.3,
                                    height: a.width / 3.3,
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(a.width),
                                        child: image == null
                                            ? Image.network(
                                                widget.info['img'],
                                                fit: BoxFit.cover,
                                              )
                                            : Image.file(
                                                image,
                                                fit: BoxFit.cover,
                                              )),
                                  ),
                                  onTap: () {
                                    selectImg(context);
                                  },
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    inputID(a, widget.doc['id']),
                                    Text(
                                      'Join ${widget.info['createdDay']}',
                                      style: TextStyle(
                                          fontSize: a.width / 11,
                                          color: Color(0xff26A4FF)),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                        Positioned(
                          right: 10.0,
                          top: 10.0,
                          child: IconButton(
                            icon: Icon(Icons.create),
                            color: Color(0xff5F5F5F),
                            iconSize: 30.0,
                            onPressed: () {
                              read = false;
                              setState(() {});
                            },
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
                                editAccount(a, 'email', 'name@mail.com',
                                    widget.doc['email'],
                                    validator: (val) => val.trim() == ""
                                        ?  Taoast().toast("put isas") 
                                        : val.contains('@') &&
                                                val.contains(
                                                    '.com', val.length - 4)
                                            ? ""
                                            : Taoast().toast("format pls") ),
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
                                editAccount(a, 'password', '••••••••',
                                    widget.doc['password'],
                                    validator: (val) => val.trim() == ""
                                        ?  Taoast().toast("กรุณากรอกข้อมูลให้ครบ") 
                                        : val.trim().length < 6
                                            ?  Taoast().toast("รหัสต้องมีอย่างน้อย 6 ตัว") 
                                            : "")
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 10.0,
                          top: 10.0,
                          child: IconButton(
                            icon: Icon(Icons.create),
                            color: Color(0xff5F5F5F),
                            iconSize: 30.0,
                            onPressed: () {
                              readMail = false;
                              setState(() {});
                            },
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
                                fontSize: a.width / 17,
                                color: Color(0xff5F5F5F)),
                          ),
                          Text(
                            "${widget.doc['phone'].substring(0, 3)}-${widget.doc['phone'].substring(3, 6)}-${widget.doc['phone'].substring(6, 10)}",
                            style: TextStyle(
                                fontSize: a.width / 12,
                                color: Color(0xff5F5F5F)),
                          ),
                          InkWell(
                            child: Row(
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
                                      fontSize: a.width / 18,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (read && readMail) {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChangePhone()));
                              } else {
                                warning(context,
                                    'ข้อมูลที่ท่านกรอกไว้จะหายไปทั้งหมด');
                              }
                            },
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
        )
      ]),
    );
  }

  warning(BuildContext context, String sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            "คุณต้องการออกจากหน้านี้ใช่หรือไม่",
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            sub,
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ยกเลิก',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              'ตกลง',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChangePhone()));
            },
          ),
        ],
      ),
    );
  }

  Widget inputID(Size a, String value) {
    var tx = TextEditingController();
    tx.text = '@' + value;
    return Container(
      width: a.width / 2,
      height: a.height / 21,
      child: TextFormField(
        readOnly: read,
        controller: tx,
        style: TextStyle(fontSize: a.width / 13, color: Colors.white),
        decoration:
            InputDecoration(border: InputBorder.none, hintText: 'ใส่@ของคุณ'),
        validator: (val) {
          return val.trim() == ""
              ? Taoast().toast("กรุณากรอกข้อความ")
              : "";
        },
        onSaved: (val) {
          val.trim()[0] == '@' ? id = val.trim().substring(1) : id = val.trim();
        },
      ),
    );
  }

  Widget editAccount(Size a, String type, String hint, String value,
      {String validator(String val)}) {
    var tx = TextEditingController();
    tx.text = value;
    return Container(
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
        readOnly: readMail,
        controller: tx,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.white,
          fontSize: a.width / 13,
          fontWeight: FontWeight.w900,
        ),
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[700]),
        ),
        validator: validator,
        onSaved: (gId) => account[type] = gId.trim(),
        textInputAction: TextInputAction.next,
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

class ChangePhone extends StatefulWidget {
  @override
  _ChangePhoneState createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  String phone;
  var _key = GlobalKey<FormState>();

  Future<void> phoneVerified() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String id) {
      print(id);
    };
    final PhoneCodeSent smsCode = (String id, [int resendCode]) {
      print(id.toString() + " sent and " + resendCode.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPScreen(
                    verifiedID: id,
                    phone: phone,
                    edit: true,
                  )));
    };
    final PhoneVerificationCompleted success = (AuthCredential credent) async {
      print('yes sure');
      // FirebaseUser user = await FirebaseAuth.instance.currentUser();
      // user.linkWithCredential(credent);
    };
    PhoneVerificationFailed failed = (AuthException error) {
      print(error);
    };
    await FirebaseAuth.instance
        .verifyPhoneNumber(
            phoneNumber: '+66' + phone,
            timeout: Duration(seconds: 120),
            verificationCompleted: success,
            verificationFailed: failed,
            codeSent: smsCode,
            codeAutoRetrievalTimeout: autoRetrieval)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<bool> alreadyUse(String phone) async {
    final QuerySnapshot phones = await Firestore.instance
        .collection('Users')
        .where('phone', isEqualTo: phone)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> doc = phones.documents;
    return doc.length == 1;
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(a.width / 20),
        child: Container(
          width: a.width,
          alignment: Alignment.topLeft,
          child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: a.width / 7,
                    height: a.width / 10,
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(a.width),
                            color: Colors.white),
                        child: Icon(Icons.arrow_back,
                            color: Colors.black, size: a.width / 15),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "เปลี่ยนเบอร์โทรศัพท์",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: a.width / 8),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: a.width / 20, bottom: a.width / 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(40.0),
                                      bottomLeft: const Radius.circular(40.0)),
                                  border: Border(
                                    top: BorderSide(
                                        width: 1.0, color: Colors.white),
                                    left: BorderSide(
                                        width: 1.0, color: Colors.white),
                                    right: BorderSide(
                                        width: 1.0, color: Colors.white),
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.white),
                                  ),
                                ),
                                width: a.width / 4,
                                height: a.width / 6.3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '+66',
                                      style: TextStyle(
                                        fontSize: a.width / 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Container(
                                      child: Image.asset(
                                        'assets/thai-flag-round.png',
                                        width: a.width / 18,
                                        height: a.width / 18,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
                              Container(
                                width: a.width / 1.7,
                                height: a.width / 6.3,
                                padding: EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      topRight: const Radius.circular(40.0),
                                      bottomRight: const Radius.circular(40.0)),
                                  border: Border(
                                    top: BorderSide(
                                        width: 1.0, color: Colors.white),
                                    left: BorderSide(
                                        width: 1.0, color: Colors.white),
                                    right: BorderSide(
                                        width: 1.0, color: Colors.white),
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.white),
                                  ),
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: a.width / 14,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'เบอร์โทรศัพท์',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[500]),
                                  ),
                                  validator: (val) {
                                    return val.trim() == ""
                                        ?  Taoast().toast("put isas") 
                                        : val.trim().length > 10
                                            ?  Taoast().toast("cheak 10 หลัก") 
                                            : "";
                                  },
                                  onSaved: (val) {
                                    phone = val.trim();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Text(
                          "เราจะส่งเลข 6 หลัก เพื่อยืนยันเบอร์คุณ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: a.width / 18),
                        ),
                        SizedBox(
                          height: a.width / 7,
                        ),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(a.width / 10)),
                            width: a.width / 2.5,
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            child: Text(
                              "ต่อไป",
                              style: TextStyle(
                                  fontSize: a.width / 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onTap: () async {
                            if (_key.currentState.validate()) {
                              _key.currentState.save();
                              await alreadyUse(phone)
                                  ? warning(context,
                                      'เบอร์โทรนี้ได้ทำการลงทะเบียนไว้แล้ว')
                                  : await phoneVerified();
                            } else {
                              print('nope');
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: a.width,
                    height: a.width / 10,
                    alignment: Alignment.center,
                    color: Colors.black,
                    child: Text(
                      'สร้างบัญชีใหม่',
                      style: TextStyle(
                          fontSize: a.width / 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500]),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  warning(BuildContext context, String sub) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(
            "เกิดข่้อผิดพลาด",
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            sub,
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'ตกลง',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
